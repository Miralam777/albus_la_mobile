import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:albus_la_mobile/core/utils/helpers/helpers.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/models/product_group_model.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/gen_qrcode/gen_product.dart';
import 'package:albus_la_mobile/features/home/presentation/widgets/order_details_page/order_add_qrcode_model.dart';

class FirestoreService {
  FirestoreService._();

  //! qrCode tabel
  static Future<bool> productManufactured(String? dId) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(dId).update({
        'manufactured': true,
      });

      return true;
    } catch (_) {
      return false;
    }
  }

  static Future<OrderAddQrcodeModel?> getOrderAddQrcodeModel(String? id) async {
    if ((id ?? '').isEmpty) return null;
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('id', isEqualTo: id)
          .where('uId', isNull: true)
          .where('manufactured', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return OrderAddQrcodeModel.fromMap(querySnapshot.docs[0].data());
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  /*   static Future<bool> testProductQrcode(String? qrId) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(dId)
          .update({'manufactured': true});

      return true;
    } catch (_) {
      return false;
    }
  } */

  //! ******************** add group and products
  /// Adds a product group and generates the specified number of products with custom 8-char IDs.
  /// Uses transactions to ensure no duplicate IDs even with concurrent users.
  static Future<void> addGroupAndProducts(
    ProductGroupModel group,
    Function(int percent) onProgress,
  ) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Step 1: Create the product group document
      final groupDocRef = firestore.collection('productGroups').doc();
      final groupId = groupDocRef.id;
      final groupNumber = Helpers.genIntId(length: 10);

      final groupData = group
          .copyWith(dId: groupId, groupNr: groupNumber)
          .toMap();
      groupData['created'] = FieldValue.serverTimestamp();

      await groupDocRef.set(groupData);

      // Step 2: Create products for this group
      final productCount = group.quantity ?? 0;
      if (productCount <= 0) {
        print('No products to create (quantity: $productCount)');
        return;
      }

      print('Creating $productCount products for group $groupNumber');
      await _createProductsSequentially(
        firestore: firestore,
        productCount: productCount,
        group: group,
        groupNumber: groupNumber,
        onProgress: onProgress,
      );
    } catch (error, stackTrace) {
      print('Error adding product group: $error');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Creates products sequentially, each in its own transaction.
  /// This ensures race-condition safety when multiple users create products simultaneously.
  static Future<void> _createProductsSequentially({
    required FirebaseFirestore firestore,
    required int productCount,
    required ProductGroupModel group,
    required int groupNumber,
    required void Function(int percent) onProgress,
  }) async {
    final productsCollection = firestore.collection('products');
    var successCount = 0;
    var failCount = 0;

    for (var i = 0; i < productCount; i++) {
      print('=========> index: ${i + 1}');
      try {
        await _createSingleProductWithTransaction(
          index: i + 1,
          firestore: firestore,
          productsCollection: productsCollection,
          group: group,
          groupNumber: groupNumber,
          productIndex: i + 1,
        );
        successCount++;

        // Log progress every 10 products
        if ((i + 1) % 10 == 0 || i == productCount - 1) {
          print('Progress: ${i + 1}/$productCount products created');
        }

        final percent = ((i + 1) / productCount * 100).toInt();
        print('Progress: ${i + 1}/$productCount products ($percent%)');
        onProgress(percent);
      } catch (error) {
        failCount++;
        print('Failed to create product ${i + 1}: $error');
        // Continue creating remaining products even if one fails
      }
    }

    print(
      'Product creation completed: $successCount succeeded, $failCount failed',
    );

    if (failCount > 0) {
      throw Exception(
        'Failed to create $failCount out of $productCount products',
      );
    }
  }

  /// Creates a single product using a transaction to ensure ID uniqueness.
  /// Retries with a new ID if collision is detected.
  static Future<void> _createSingleProductWithTransaction({
    required int index,
    required FirebaseFirestore firestore,
    required CollectionReference<Map<String, dynamic>> productsCollection,
    required ProductGroupModel group,
    required int groupNumber,
    required int productIndex,
  }) async {
    const maxAttempts = 100;
    var attempts = 0;
    var created = false;

    while (!created && attempts < maxAttempts) {
      attempts++;

      // Generate unique 10-character ID
      final productId = Helpers.genRandomString(length: 10);
      final docRef = productsCollection.doc(productId);

      try {
        // Use transaction to atomically check and create
        await firestore.runTransaction(
          (transaction) async {
            // Read phase: Check if document exists
            final snapshot = await transaction.get(docRef);

            if (snapshot.exists) {
              // Document already exists, throw to retry with new ID
              throw FirebaseException(
                plugin: 'cloud_firestore',
                code: 'already-exists',
                message: 'Product ID $productId already exists',
              );
            }

            // Write phase: Create the product
            final productData = _createProductData(
              index: index,
              productId: productId,
              group: group,
              groupNumber: groupNumber,
            );

            transaction.set(docRef, productData);
          },
          // Set timeout to prevent hanging transactions
          timeout: const Duration(seconds: 10),
        );

        // Transaction succeeded
        print(
          'Product $productIndex created successfully with ID: $productId (attempt $attempts)',
        );

        created = true;
      } on FirebaseException catch (e) {
        if (e.code == 'already-exists') {
          // ID collision detected, retry with new ID
          print(
            'ID collision for product $productIndex (ID: $productId), retrying... (attempt $attempts)',
          );
          continue;
        } else {
          // Other Firestore error, rethrow
          print('Firestore error creating product $productIndex: ${e.message}');
          rethrow;
        }
      } catch (error) {
        // Unexpected error
        print('Unexpected error creating product $productIndex: $error');
        rethrow;
      }
    }

    if (!created) {
      throw Exception(
        'Failed to create product $productIndex after $maxAttempts attempts. '
        'This suggests high collision rate or system issues.',
      );
    }
  }

  /// Creates the product data map for a new product.
  static Map<String, dynamic> _createProductData({
    required int index,
    required String productId,
    required ProductGroupModel group,
    required int groupNumber,
  }) {
    final product = GenProduct(
      index: index,
      creator: group.creator,
      imageUrl: null,
      id: productId,
      manufactured: false,
      pin: Helpers.genIntId(length: 8).toString(),
      name: group.pName,
      productId: group.pId,
      type: group.pType,
      groupNr: groupNumber,
      uId: null,
    ).toMap();

    product['createdAt'] = FieldValue.serverTimestamp();

    return product;
  }
  //! ******************** add group and products

  /*   static Future<void> deleteProductGroupAndProducts(
      ProductGroupModel group) async {
    final firestore = FirebaseFirestore.instance;

    // Safety checks (optional but recommended)
    if (group.groupNr == null) {
      throw ArgumentError('group.groupNr must not be null');
    }
    if (group.dId == null || group.dId!.isEmpty) {
      throw ArgumentError('group.dId must not be null or empty');
    }

    final productsRef = firestore.collection('products');
    final groupsRef = firestore.collection('productGroups');

    // 1) Load all products that belong to this groupNr
    final productsSnapshot =
        await productsRef.where('groupNr', isEqualTo: group.groupNr).get();

    // 2) Delete all matching products + the group document in a batch
    //    (not a transaction, but atomic as a single commit)
    final batch = firestore.batch();

    // Delete all product documents that match the groupNr
    for (final doc in productsSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // Delete the group document by its dId
    final groupDocRef = groupsRef.doc(group.dId);
    batch.delete(groupDocRef);

    // Commit all deletes
    await batch.commit();
  } */

  //! ******************** delete group and products
  /// Alternative version using a transaction for full atomicity.
  /// This ensures that either EVERYTHING is deleted (group + all products)
  /// or NOTHING is deleted if any error occurs.
  ///
  /// Note: For groups with more than 499 products, this method automatically
  /// falls back to batched deletes (which are not fully atomic but handle
  /// large datasets).
  ///
  /// Use this version if you need guaranteed atomicity across all deletes
  /// (only possible for groups with <= 499 products).
  static Future<void> deleteProductGroupAndProducts(
    ProductGroupModel group,
  ) async {
    try {
      final firestore = FirebaseFirestore.instance;

      if (group.dId == null || group.dId!.isEmpty) {
        throw ArgumentError('Product group must have a valid document ID');
      }

      if (group.groupNr == null) {
        throw ArgumentError('Product group must have a valid group number');
      }

      print('Starting deletion of group ${group.groupNr}');

      // First, check how many products exist
      final productsSnapshot = await firestore
          .collection('products')
          .where('groupNr', isEqualTo: group.groupNr)
          .get();

      final productCount = productsSnapshot.docs.length;

      // If more than 499 products, use batched deletion
      if (productCount > 499) {
        print(
          'Group has $productCount products (> 499). '
          'Using batched deletion instead of transaction.',
        );
        await _deleteWithBatches(firestore, group, productsSnapshot.docs);
      } else {
        // Use atomic transaction for smaller datasets
        print('Deleting $productCount products atomically');
        await _deleteWithTransaction(firestore, group, productsSnapshot.docs);
      }

      print('Successfully deleted group ${group.groupNr}');
    } catch (error, stackTrace) {
      print('Error in deletion: $error');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Deletes using a transaction (atomic, max 500 operations)
  static Future<void> _deleteWithTransaction(
    FirebaseFirestore firestore,
    ProductGroupModel group,
    List<QueryDocumentSnapshot> productDocs,
  ) async {
    await firestore.runTransaction((transaction) async {
      // Delete all products
      for (final doc in productDocs) {
        transaction.delete(doc.reference);
      }

      // Delete the group
      transaction.delete(firestore.collection('productGroups').doc(group.dId));
    });
  }

  /// Deletes using batches (not atomic, but handles large datasets)
  static Future<void> _deleteWithBatches(
    FirebaseFirestore firestore,
    ProductGroupModel group,
    List<QueryDocumentSnapshot> productDocs,
  ) async {
    const batchSize = 500;
    var deletedCount = 0;

    // Delete products in batches
    for (var i = 0; i < productDocs.length; i += batchSize) {
      final batch = firestore.batch();
      final end = (i + batchSize < productDocs.length)
          ? i + batchSize
          : productDocs.length;

      for (var j = i; j < end; j++) {
        batch.delete(productDocs[j].reference);
      }

      await batch.commit();
      deletedCount += (end - i);
      print('Deleted $deletedCount / ${productDocs.length} products');
    }

    // Delete the group in a final batch
    final finalBatch = firestore.batch();
    finalBatch.delete(firestore.collection('productGroups').doc(group.dId));
    await finalBatch.commit();
  }

  //! ******************** delete group and products
}

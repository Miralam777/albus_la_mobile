import 'dart:io';

import 'package:albus_la_mobile/core/utils/helpers/helpers.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/product/product.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@injectable
class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> get getProducts => _products;

  Future<void> init() async {
    FirebaseFirestore.instance
        .collection('shop')
        .orderBy('created', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            print('products snapshot.docs.length');
            print(snapshot.docs.length);
            List<Product> products = [];
            for (var d in snapshot.docs) {
              final doc = d.data();
              final prod = Product.fromMap(doc);
              products.add(prod);
            }

            _products = products;
            notifyListeners();
          },
          onError: (_) {
            // Fehlerbehandlung
          },
        );
  }

  Future<void> add(Product product) async {
    try {
      String dId = FirebaseFirestore.instance.collection('shop').doc().id;
      print('dId: ${dId}');

      await FirebaseFirestore.instance
          .collection('shop')
          .doc(dId)
          .set(product.copyWith(dId: dId).toMap());
    } catch (error) {
      print('Fehler beim Hinzufügen der Kategorie: $error');
    }
  }

  Future<void> update(Product? product) async {
    try {
      if (product != null) {
        await FirebaseFirestore.instance
            .collection('shop')
            .doc(product.dId)
            .update(product.toMap());
      }
    } catch (_) {}
  }

  Future<void> delete(Product product) async {
    try {
      //! delete images
      await deleteImageFromStorage(product.thumbnail ?? '');
      for (var img in product.images ?? []) {
        await deleteImageFromStorage(img);
      }

      //! delete product
      await FirebaseFirestore.instance
          .collection('shop')
          .doc(product.dId)
          .delete();
    } catch (_) {}
  }

  Future<void> deleteImageFromStorage(String? fileUrl) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
        _getFilePathFromUrl(fileUrl ?? ''),
      );
      await storageRef.delete();
    } catch (_) {}
  }

  String _getFilePathFromUrl(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    final encodedFileName = pathSegments.last;
    final fileName = Uri.decodeComponent(encodedFileName);
    print('===========> fileName');
    print(fileName);
    return fileName;
  }

  Future<String?> uploadImageToStorage(String? imagePath) async {
    try {
      final image = File(imagePath ?? '');
      final storageRef = FirebaseStorage.instance.ref().child(
        'products/${Helpers.genRandomString(length: 17)}.jpg',
      );
      await storageRef.putFile(image);
      final downloadURL = await storageRef.getDownloadURL();
      print('Download-Link: $downloadURL');
      return downloadURL;
    } catch (_) {
      return null;
    }
  }
}

// TODO: Delete
List productsDummyData = [
  Product(
    productId: 1234567891,
    name: 'schlüsselanhänger',
    description: 'Kurzbeschreibung des Produkts',
    category: 'KategorieName',
    price: 999,
    currency: "EUR",
    stock: 100,
    rating: 45,
    thumbnail:
        "https://firebasestorage.googleapis.com/v0/b/call-my-car-7a910.appspot.com/o/products%2Fkey_m_11.png?alt=media&token=cf1af65c-d179-478b-85b1-caeb1cccf140",
    images: const [
      "https://firebasestorage.googleapis.com/v0/b/call-my-car-7a910.appspot.com/o/products%2Fkey_3.png?alt=media&token=c4c764d5-23b8-4de3-9546-bd2103281040",
      "https://firebasestorage.googleapis.com/v0/b/call-my-car-7a910.appspot.com/o/products%2Fkey_4.png?alt=media&token=7314e28d-23f3-4115-8ae0-2d5d2b1c4379",
      "https://firebasestorage.googleapis.com/v0/b/call-my-car-7a910.appspot.com/o/products%2Fkey_5.png?alt=media&token=8212fa88-039d-47fc-b654-fc5ff934157f",
      "https://firebasestorage.googleapis.com/v0/b/call-my-car-7a910.appspot.com/o/products%2Fkey_m_10.png?alt=media&token=635abf24-088d-407f-bb22-2ce45bde776e",
    ],
    attributes: const Attributes(
      color: "rot",
      size: "M",
      weight: "500g",
      dimensions: "30x20x10 cm",
    ),
    tags: const ["tag1", "tag2", "tag3"],
    reviews: const [
      Review(
        reviewId: "r1",
        user: "Benutzer1",
        rating: 5,
        comment: "Sehr gutes Produkt!",
        date: "2023-09-12",
      ),
      Review(
        reviewId: "r2",
        user: "Benutzer2",
        rating: 4,
        comment: "Gut, aber könnte besser sein.",
        date: "2023-09-15",
      ),
    ],
    relatedProducts: const ["12346", "12347", "12348"],
    // TODO: timestemp from api
    created: Timestamp.now(),
    supplier: const Supplier(
      supplierId: "s123",
      name: "Lieferantname",
      contact: "info@lieferant.de",
      phone: "+49 123 456 789",
    ),
  ),
  Product(
    productId: 1834963891,
    name: 'Autoaufkleber',
    description: 'Kurzbeschreibung des Produkts',
    category: 'KategorieName',
    price: 599,
    currency: "EUR",
    stock: 100,
    rating: 45,
    thumbnail:
        "https://firebasestorage.googleapis.com/v0/b/call-my-car-7a910.appspot.com/o/products%2Fkey_m_11.png?alt=media&token=cf1af65c-d179-478b-85b1-caeb1cccf140",
    images: const [
      "https://firebasestorage.googleapis.com/v0/b/call-my-car-7a910.appspot.com/o/products%2Fkey_3.png?alt=media&token=c4c764d5-23b8-4de3-9546-bd2103281040",
      "https://firebasestorage.googleapis.com/v0/b/call-my-car-7a910.appspot.com/o/products%2Fkey_4.png?alt=media&token=7314e28d-23f3-4115-8ae0-2d5d2b1c4379",
      "https://firebasestorage.googleapis.com/v0/b/call-my-car-7a910.appspot.com/o/products%2Fkey_5.png?alt=media&token=8212fa88-039d-47fc-b654-fc5ff934157f",
      "https://firebasestorage.googleapis.com/v0/b/call-my-car-7a910.appspot.com/o/products%2Fkey_m_10.png?alt=media&token=635abf24-088d-407f-bb22-2ce45bde776e",
    ],
    attributes: const Attributes(
      color: "rot",
      size: "M",
      weight: "500g",
      dimensions: "30x20x10 cm",
    ),
    tags: const ["tag1", "tag2", "tag3"],
    reviews: const [
      Review(
        reviewId: "r1",
        user: "Benutzer1",
        rating: 5,
        comment: "Sehr gutes Produkt!",
        date: "2023-09-12",
      ),
      Review(
        reviewId: "r2",
        user: "Benutzer2",
        rating: 4,
        comment: "Gut, aber könnte besser sein.",
        date: "2023-09-15",
      ),
    ],
    relatedProducts: const ["12346", "12347", "12348"],
    // TODO: timestemp from api
    created: Timestamp.now(),
    supplier: const Supplier(
      supplierId: "s123",
      name: "Lieferantname",
      contact: "info@lieferant.de",
      phone: "+49 123 456 789",
    ),
  ),
  Product(
    productId: 1874763893,
    name: 'Brieftaschenkarte',
    description: 'Kurzbeschreibung des Produkts',
    category: 'KategorieName',
    price: 799,
    currency: "EUR",
    stock: 100,
    rating: 45,
    thumbnail:
        "https://firebasestorage.googleapis.com/v0/b/call-my-car-7a910.appspot.com/o/products%2Fkey_m_11.png?alt=media&token=cf1af65c-d179-478b-85b1-caeb1cccf140",
    images: [
      "https://firebasestorage.googleapis.com/v0/b/call-my-car-7a910.appspot.com/o/products%2Fkey_3.png?alt=media&token=c4c764d5-23b8-4de3-9546-bd2103281040",
      "https://firebasestorage.googleapis.com/v0/b/call-my-car-7a910.appspot.com/o/products%2Fkey_4.png?alt=media&token=7314e28d-23f3-4115-8ae0-2d5d2b1c4379",
      "https://firebasestorage.googleapis.com/v0/b/call-my-car-7a910.appspot.com/o/products%2Fkey_5.png?alt=media&token=8212fa88-039d-47fc-b654-fc5ff934157f",
      "https://firebasestorage.googleapis.com/v0/b/call-my-car-7a910.appspot.com/o/products%2Fkey_m_10.png?alt=media&token=635abf24-088d-407f-bb22-2ce45bde776e",
    ],
    attributes: Attributes(
      color: "rot",
      size: "M",
      weight: "500g",
      dimensions: "30x20x10 cm",
    ),
    tags: ["tag1", "tag2", "tag3"],
    reviews: [
      Review(
        reviewId: "r1",
        user: "Benutzer1",
        rating: 5,
        comment: "Sehr gutes Produkt!",
        date: "2023-09-12",
      ),
      Review(
        reviewId: "r2",
        user: "Benutzer2",
        rating: 4,
        comment: "Gut, aber könnte besser sein.",
        date: "2023-09-15",
      ),
    ],
    relatedProducts: ["12346", "12347", "12348"],
    // TODO: timestemp from api
    created: Timestamp.now(),
    supplier: Supplier(
      supplierId: "s123",
      name: "Lieferantname",
      contact: "info@lieferant.de",
      phone: "+49 123 456 789",
    ),
  ),
];

/* 
{
  "product": {
    "product_id": "12345",
    "name": "Produktname",
    "description": "Kurzbeschreibung des Produkts",
    "category": "KategorieName",
    "price": 49.99,
    "currency": "EUR",
    "stock": 100,
    "rating": 4.5,
    "thumbnail": "https://example.com/images/thumbnail.jpg",
    "images": [
      "https://example.com/images/image1.jpg",
      "https://example.com/images/image2.jpg",
      "https://example.com/images/image3.jpg"
    ],
    "attributes": {
      "color": "rot",
      "size": "M",
      "weight": "500g",
      "dimensions": "30x20x10 cm"
    },
    "tags": ["tag1", "tag2", "tag3"],
    "reviews": [
      {
        "review_id": "r1",
        "user": "Benutzer1",
        "rating": 5,
        "comment": "Sehr gutes Produkt!",
        "date": "2023-09-12"
      },
      {
        "review_id": "r2",
        "user": "Benutzer2",
        "rating": 4,
        "comment": "Gut, aber könnte besser sein.",
        "date": "2023-09-15"
      }
    ],
    "related_products": ["12346", "12347", "12348"],
    "created_at": "2023-08-01T12:34:56Z",
    "updated_at": "2023-09-01T10:00:00Z",
    "supplier": {
      "supplier_id": "s123",
      "name": "Lieferantname",
      "contact": "info@lieferant.de",
      "phone": "+49 123 456 789"
    }
  }
}
 */

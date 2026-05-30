import 'package:albus_la_mobile/configs/routes/routes.dart';
import 'package:albus_la_mobile/configs/services/firebase/firestore_service.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/global/nfc_notifier.dart';
import 'package:albus_la_mobile/core/utils/helpers/platform_helper.dart';
import 'package:albus_la_mobile/core/utils/utility/dialogs_utils.dart';
import 'package:albus_la_mobile/core/widgets/empty_list_widget.dart';
import 'package:albus_la_mobile/core/widgets/loading_indicator.dart';
import 'package:albus_la_mobile/core/widgets/nfc/nfc_read_icon_btn.dart';
import 'package:albus_la_mobile/core/widgets/nfc/nfc_write_icon_btn.dart';
import 'package:albus_la_mobile/core/widgets/page_stack_loading.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/core/widgets/text_field.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/models/product_group_model.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/widgets/products_pdf_btm_nav_sheet/products_pdf_btm_nav_sheet.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/gen_qrcode/gen_product.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// Displays all products belonging to a specific product group.
/// Shows product details in a list with search and filter capabilities.
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key, required this.group});
  final ProductGroupModel group;

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isLoading = true;
  List<GenProduct> _allProducts = [];
  List<GenProduct> _filteredProducts = [];
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Loads all products for this group from Firestore
  Future<void> _loadProducts() async {
    if (widget.group.groupNr == null) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('groupNr', isEqualTo: widget.group.groupNr)
          .orderBy('index', descending: false)
          .get();

      final products = snapshot.docs
          .map((doc) => GenProduct.fromMap(doc.data()))
          .toList();

      setState(() {
        _allProducts = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (error) {
      print('Error loading products: $error');
      setState(() => _isLoading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error loading products: $error',
              overflow: TextOverflow.clip,
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Filters products based on search query
  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();

    setState(() {
      _searchQuery = query;

      if (query.isEmpty) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts = _allProducts.where((product) {
          return product.index?.toString().contains(query) == true ||
              // product.name?.toLowerCase().contains(query) == true ||
              product.id?.toLowerCase().contains(query) == true ||
              product.pin?.toLowerCase().contains(query) == true;
        }).toList();
      }
    });
  }

  /// Refreshes the product list
  Future<void> _refreshProducts() async {
    setState(() => _isLoading = true);
    await _loadProducts();
  }

  /// Deletes a single product with confirmation
  Future<void> _deleteProduct(GenProduct product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text(
          'Are you sure you want to delete product "${product.name}" (${product.id})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.id)
          .delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted successfully')),
        );
      }

      // Refresh the list
      await _refreshProducts();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting product: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Shows detailed information about a product
  void _showProductDetails(GenProduct product) {
    final nfcDataNotifier = ValueNotifier<String?>(null);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            controller: scrollController,
            children: [
              // Handle for dragging
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // TODO:
              Text(
                nfcDataNotifier.value ?? 'null',
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.titleMedium,
              ),

              NfcWriteIconBtn(
                type: NdefMsgType.url,
                data: '${K.lookAppNfcMsgBaseUrl}${product.id}',
                // TODO: aktive at end
                // writeLock: true,
                onDone: () {
                  nfcDataNotifier.value = 'write done';
                },
                onError: (error, {isAvailable}) {
                  nfcDataNotifier.value = error;
                },
              ),
              NfcReadIconBtn(
                onRead: (data) {
                  nfcDataNotifier.value = data;
                },
                onError: (error, {isAvailable}) {
                  nfcDataNotifier.value = error;
                },
              ),

              Text(
                product.name ?? 'Unnamed Product',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),

              _buildDetailRow('Product ID', product.id ?? 'N/A'),
              _buildDetailRow('PIN', product.pin ?? 'N/A'),
              // TODO:
              // _buildDetailRow('Type', product.type ?? 'N/A'),
              _buildDetailRow(
                'Group Number',
                product.groupNr?.toString() ?? 'N/A',
              ),
              _buildDetailRow(
                'Manufactured',
                product.manufactured == true ? 'Yes' : 'No',
              ),
              _buildDetailRow('Creator', product.creator ?? 'N/A'),
              _buildDetailRow('User ID', product.uId ?? 'Not assigned'),

              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteProduct(product);
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        // TODO: Implement edit functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit functionality coming soon'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper widget to build detail rows
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isDeleting,
      child: PageStackLoading(
        visible: _isDeleting,
        // TODO: text
        title: 'Bitte warten, Upload läuft.',
        undrawPath: Assets.undraws.upload,
        scaffold: Scaffold(
          body: CupertinoScrollbar(
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverAppBar.large(
                  centerTitle: false,
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TODO: text
                      Text(
                        widget.group.name ?? 'Unknown Group',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(height: 0.0),
                      ),
                      // TODO: text
                      Text(
                        'Gruppe #${widget.group.groupNr ?? 'N/A'} • ${_allProducts.length} Produkte',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          height: 0.0,
                          color: Theme.of(context).secondaryHeaderColor,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    _buildSettingIconBtn(),
                    _buildDeleteGroupAndProudoctsIconBtn(),
                  ],
                ),

                // Search bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: K.pvmH,
                      horizontal: K.pm,
                    ),
                    child: TextFieldWidget(
                      controller: _searchController,
                      // TODO: text and search bar
                      hintText: 'Suche nach Nummer, ID oder PIN...',
                      suffixIcon: I.search,
                    ),
                  ),
                ),

                // Products list
                _buildProductList(),

                SliverToBoxAdapter(child: K.pvl2x.verticalSpace),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingIconBtn() {
    return Visibility(
      visible: _allProducts.isNotEmpty && !_isLoading,
      child: IconButton(
        icon: Icon(I.settings),
        onPressed: () async {
          // context.push(Routes.printPdfPage);
          showProductsPdfBtmNavSheet(
            context,
            group: widget.group,
            genProducts: _allProducts,
          );
        },
      ),
    );
  }

  IconButton _buildDeleteGroupAndProudoctsIconBtn() {
    return IconButton(
      icon: Icon(I.delete),
      onPressed: () async {
        /* title: const Text('Delete Product'),
        content: Text(
          'Are you sure you want to delete product "${product.name}" (${product.id})?',
        ), */
        await DialogsUtils.showOkCancelDialog(
          context: context,
          icon: I.delete,
          // TODO: text
          title: 'Löschen?',
          // showLoadingIndacator: true,
          onOk: () async {
            setState(() => _isDeleting = true);
            context.pop();
          },
        );

        if (_isDeleting) {
          await FirestoreService.deleteProductGroupAndProducts(widget.group);

          _isDeleting = false;

          if (!mounted) return;
          context.pop();
        }
      },
    );
  }

  Widget _buildProductList() {
    final colorScheme = Theme.of(context).colorScheme;
    final isIos = PlatformHelper.isIos();
    // final isIos = true;

    return _isLoading
        ? const SliverToBoxAdapter(child: LoadingIndicator())
        : _filteredProducts.isEmpty
        ? const SliverToBoxAdapter(child: EmptyListWidget())
        : SliverList.builder(
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return Card(
                elevation: 3.0,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: isIos
                      ? BorderRadius.circular(K.rm)
                      : BorderRadius.zero,
                ),
                margin: EdgeInsets.symmetric(
                  vertical: K.pvsH,
                  horizontal: isIos ? K.pm : 0.0,
                ),
                child: InkWell(
                  onTap: () => _showProductDetails(product),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          padding: EdgeInsets.all(K.ps),
                          decoration: BoxDecoration(
                            color: colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(K.rs),
                          ),
                          child: Text(
                            '${product.index}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        SizedBox(width: K.pm),

                        // Product info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*                                   Text(
                                    product.name ?? 'Unnamed Product',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ), */
                              // const SizedBox(height: 4),
                              Text(
                                'ID: ${product.id ?? 'N/A'} • PIN: ${product.pin ?? 'N/A'}',
                                maxLines: 2,
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              // TODO: nfc
                              if (product.type != null) ...[
                                // const SizedBox(height: 4),
                                _doneIconAndText('NFC'),
                              ],
                              // TODO: keychain
                              if (product.type != null) ...[
                                // const SizedBox(height: 4),
                                _doneIconAndText('Schlüsselanhänger'),
                              ],
                            ],
                          ),
                        ),

                        // Arrow icon
                        Icon(I.arrowForwardIos),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
  }

  Widget _doneIconAndText(String title) {
    return Row(
      children: [
        Icon(I.done, color: Colors.green),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(),
          ),
        ),
      ],
    );
  }
}

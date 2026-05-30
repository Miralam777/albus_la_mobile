import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:albus_la_mobile/configs/extensions/extensions.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/helpers.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/utils/utility/file_picker_utils.dart';
import 'package:albus_la_mobile/core/utils/utility/image_copper_utils.dart';
import 'package:albus_la_mobile/core/utils/utility/toast_utils.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/core/widgets/firebase_image_widget.dart';
import 'package:albus_la_mobile/core/widgets/loading_indicator.dart';
import 'package:albus_la_mobile/core/widgets/svg_un_draw_image.dart';
import 'package:albus_la_mobile/core/widgets/switch.dart';
import 'package:albus_la_mobile/core/widgets/text_field.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/product/product.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/product_provider.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

class AddUpdateProductPage extends StatefulWidget {
  const AddUpdateProductPage({super.key, required this.product});
  final Product? product;

  @override
  State<AddUpdateProductPage> createState() => _AddUpdateProductPageState();
}

class _AddUpdateProductPageState extends State<AddUpdateProductPage> {
  late TextEditingController _tecName,
      _tecLabelName,
      _tecDescription,
      _tecPrice,
      _tecAvt,
      _tecCurrency,
      _tecStock,
      _tecCategories,
      _tecAtbColor,
      _tecAtbSize,
      _tecAtbWeight,
      _tecAtbDimensions,
      _tecSuppliersName;

  late bool _isActive;
  bool _isUploading = false;
  String? _pickedThumbnail;
  final List<String> _pickedProductImages = [];

  final _horizontalPaddingPm = EdgeInsets.symmetric(horizontal: K.pm);

  @override
  void initState() {
    final product = widget.product;
    _isActive = product?.isActive ?? false;

    _tecName = TextEditingController(text: product?.name);
    _tecLabelName = TextEditingController(text: product?.labelName);
    _tecDescription = TextEditingController(text: product?.description);
    _tecPrice = TextEditingController(
      text: product?.price.toStringPricePoint(),
    );
    _tecAvt = TextEditingController(
      text: product?.avt != null ? product?.avt.toString() : '19',
    );
    _tecCurrency = TextEditingController(text: product?.currency);
    _tecStock = TextEditingController(text: product?.stock.toString());
    _tecCategories = TextEditingController(text: product?.category);
    _tecAtbColor = TextEditingController(text: product?.attributes?.color);
    _tecAtbSize = TextEditingController(text: product?.attributes?.size);
    _tecAtbWeight = TextEditingController(text: product?.attributes?.weight);
    _tecAtbDimensions = TextEditingController(
      text: product?.attributes?.dimensions,
    );
    _tecSuppliersName = TextEditingController(text: product?.supplier?.name);
    super.initState();
  }

  @override
  void dispose() {
    _tecName.dispose();
    _tecLabelName.dispose();
    _tecDescription.dispose();
    _tecPrice.dispose();
    _tecAvt.dispose();
    _tecCurrency.dispose();
    _tecStock.dispose();
    _tecCategories.dispose();
    _tecAtbColor.dispose();
    _tecAtbSize.dispose();
    _tecAtbWeight.dispose();
    _tecAtbDimensions.dispose();
    _tecSuppliersName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PrimaryAppBar(
            // TODO: text
            title: widget.product == null
                ? 'Produkt hinzufügen'
                : 'Produkt bearbeiten',
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaHelper.statusAndAppBarH(context) + K.pvm,
              bottom: MediaHelper.androidBtmNavBarH(context) + K.pvl2x,
            ),
            child: Column(
              children: [
                // ! ************************* thumbnail
                Padding(
                  padding: _horizontalPaddingPm,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(K.rm),
                        border: Border.all(
                          color: colorScheme.outline,
                          width: K.bm,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(K.rm),
                        child: Stack(
                          children: [
                            ImageFiltered(
                              imageFilter: ImageFilter.blur(
                                sigmaX: 15,
                                sigmaY: 15,
                              ),
                              child: SizedBox(
                                height: double.infinity,
                                width: double.infinity,
                                child: _pickedThumbnail != null
                                    ? Image.file(
                                        File(_pickedThumbnail ?? ''),
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const SizedBox.shrink(),
                                      )
                                    : FirebaseImageWidget(
                                        image: widget.product?.thumbnail,
                                        fit: BoxFit.cover,
                                        showLoadingIndicator: false,
                                        errorWidget: const SizedBox.shrink(),
                                      ),
                              ),
                            ),
                            if (_pickedThumbnail != null)
                              Container(
                                height: double.infinity,
                                width: double.infinity,
                                color: MediaHelper.isBrightnessDark(context)
                                    ? Colors.black.withValues(alpha: 0.6)
                                    : Colors.white.withValues(alpha: 0.6),
                              ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: K.pvl,
                                  horizontal: K.pl,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(K.rs),
                                  child: _pickedThumbnail != null
                                      ? Image.file(
                                          File(_pickedThumbnail ?? ''),
                                          fit: BoxFit.contain,
                                        )
                                      : FirebaseImageWidget(
                                          image: widget.product?.thumbnail,
                                          fit: BoxFit.contain,
                                          showLoadingIndicator: false,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                K.pvm.verticalSpace,
                TextButton.icon(
                  label: const Text(
                    // TODO: text
                    'Vorschaubild auswählen',
                  ),
                  icon: Icon(I.addPhoto),
                  onPressed: () async {
                    final logo = await FilePickerUtils.pickImageFromGallery();
                    if (logo != null) {
                      if (!context.mounted) return;
                      final cropedLogo = await ImageCropperUtils.cropImage(
                        context: context,
                        imagePath: logo,
                        cropStyle: CropStyle.rectangle,
                      );
                      if (cropedLogo != null) {
                        _pickedThumbnail = cropedLogo;
                        setState(() {});
                      }
                    }
                  },
                ),

                // ! ************************* product images
                K.pvm.verticalSpace,
                SizedBox(
                  height: 90.0.h,
                  child: widget.product != null && _pickedProductImages.isEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          padding: _horizontalPaddingPm,
                          itemCount: (widget.product?.images ?? []).length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 90.0.h,
                              width: 90.0.h,
                              margin: EdgeInsets.symmetric(
                                horizontal: K.pm * 0.4,
                              ),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(K.rm),
                                color: colorScheme.secondaryContainer,
                              ),
                              child: FirebaseImageWidget(
                                image: widget.product?.images?[index],
                                showLoadingIndicator: false,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        )
                      : _pickedProductImages.isEmpty
                      ? Align(
                          child: Text(
                            // TODO: text
                            'Keine Bilder ausgewählt',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: _horizontalPaddingPm,
                          itemCount: _pickedProductImages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              height: 90.0.h,
                              width: 90.0.h,
                              margin: EdgeInsets.symmetric(
                                horizontal: K.pm * 0.4,
                              ),
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(K.rm),
                                color: colorScheme.secondaryContainer,
                              ),
                              child: Stack(
                                children: [
                                  Image.file(
                                    File(_pickedProductImages[index]),
                                    fit: BoxFit.cover,
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: SizedBox(
                                      height: 30.0,
                                      width: 30.0,
                                      child: IconButton(
                                        icon: Icon(
                                          I.close,
                                          color: Colors.white,
                                        ),
                                        style: ButtonStyle(
                                          padding: const WidgetStatePropertyAll(
                                            EdgeInsets.zero,
                                          ),
                                          backgroundColor:
                                              WidgetStatePropertyAll(
                                                Colors.red.withValues(
                                                  alpha: 0.2,
                                                ),
                                              ),
                                        ),
                                        onPressed: () => setState(
                                          () => _pickedProductImages.removeAt(
                                            index,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                K.pvm.verticalSpace,
                TextButton.icon(
                  label: const Text(
                    // TODO: text
                    'Produktbild auswählen',
                  ),
                  icon: Icon(I.addPhoto),
                  onPressed: () async {
                    final logo = await FilePickerUtils.pickImageFromGallery();
                    if (logo != null) {
                      if (!context.mounted) return;
                      final cropedLogo = await ImageCropperUtils.cropImage(
                        context: context,
                        imagePath: logo,
                        cropStyle: CropStyle.rectangle,
                      );
                      if (cropedLogo != null) {
                        _pickedProductImages.add(cropedLogo);
                        setState(() {});
                      }
                    }
                  },
                ),
                K.pvl.verticalSpace,

                // ! ************************* product active widget
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: K.pm),
                  padding: EdgeInsets.symmetric(horizontal: K.ps),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(K.rm),
                    border: Border.all(color: colorScheme.outline, width: K.bm),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          // TODO: text
                          'Ist das Produkt aktiv?',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      CustomSwitchWidget(
                        value: _isActive,
                        onChanged: (val) => setState(() => _isActive = val),
                      ),
                    ],
                  ),
                ),
                K.pvl.verticalSpace,

                // ! ************************* info text fields
                Padding(
                  padding: _horizontalPaddingPm,
                  child: Column(
                    children: [
                      TextFieldWidget(
                        controller: _tecName,
                        // TODO: text
                        hintText: 'Produktname',
                      ),
                      K.pvm.verticalSpace,
                      TextFieldWidget(
                        controller: _tecDescription,
                        // TODO: text
                        hintText: 'Produktbeschreibung',
                        minLines: 3,
                        maxLines: 5,
                        suffixIcon: I.description,
                      ),
                      K.pvm.verticalSpace,
                      TextFieldWidget(
                        controller: _tecLabelName,
                        // TODO: text
                        hintText: 'Bezeichnungsname',
                        // TODO: text
                        helperText:
                            'Auf Englisch, z. B: Car Label, Keycain Red',
                      ),
                      K.pvm.verticalSpace,
                      TextFieldWidget(
                        controller: _tecPrice,
                        // TODO: text
                        hintText: 'Preis',
                        // TODO: text
                        helperText: 'Z. B.: 5, 7.99, 8.01',
                        suffixIcon: I.euro,
                        keyType: TextInputType.datetime,
                      ),
                      K.pvm.verticalSpace,
                      TextFieldWidget(
                        controller: _tecAvt,
                        // TODO: text
                        hintText: 'Mehrwertsteuersatz',
                        // TODO: text
                        helperText: 'Z. B.: 19 oder 7',
                        suffixIcon: I.percent,
                        keyType: TextInputType.number,
                      ),
                      K.pvm.verticalSpace,
                      TextFieldWidget(
                        controller: _tecCurrency,
                        // TODO: text
                        hintText: 'Währung',
                        // TODO: text
                        helperText: 'Z. B.: EUR für Euro',
                        suffixIcon: I.euro,
                      ),
                      K.pvm.verticalSpace,
                      TextFieldWidget(
                        controller: _tecStock,
                        // TODO: text
                        hintText: 'Lagerbestand',
                        suffixIcon: I.inventory,
                        keyType: TextInputType.number,
                      ),
                      K.pvm.verticalSpace,
                      TextFieldWidget(
                        controller: _tecCategories,
                        // TODO: text
                        hintText: 'Kategorien',
                        // TODO: text
                        helperText:
                            'Bitte mit einem Komma trennen. Z. B.: Aufkleber, Portemonnaie',
                        suffixIcon: I.category,
                      ),
                      K.pvm.verticalSpace,

                      // ! ************************* attributes
                      TextFieldWidget(
                        controller: _tecAtbColor,
                        // TODO: text
                        hintText: 'Produktfarbe',
                        // TODO: text
                        helperText: 'Z. B.: Rot',
                        suffixIcon: I.color,
                      ),

                      K.pvm.verticalSpace,
                      TextFieldWidget(
                        controller: _tecAtbSize,
                        // TODO: text
                        hintText: 'Größe',
                        // TODO: text
                        helperText: 'Z. B.: M',
                        suffixIcon: I.size,
                      ),
                      K.pvm.verticalSpace,
                      TextFieldWidget(
                        controller: _tecAtbDimensions,
                        // TODO: text
                        hintText: 'Maße',
                        // TODO: text
                        helperText: 'Z. B.: 30x20x10 cm',
                        suffixIcon: I.size,
                      ),
                      K.pvm.verticalSpace,
                      TextFieldWidget(
                        controller: _tecAtbWeight,
                        // TODO: text
                        hintText: 'Gewicht',
                        // TODO: text
                        helperText: 'Z. B.: 10 g',
                        suffixIcon: I.scale,
                      ),
                      K.pvm.verticalSpace,
                      TextFieldWidget(
                        controller: _tecSuppliersName,
                        // TODO: text
                        hintText: 'Lieferanten',
                        // TODO: text
                        helperText:
                            'Bitte mit einem Komma trennen. Z. B.: DHL, Hermes',
                        suffixIcon: I.category,
                      ),
                      K.pvm.verticalSpace,
                    ],
                  ),
                ),

                // ! ************************* add btn
                K.pvl2x.verticalSpace,
                Padding(
                  padding: _horizontalPaddingPm,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: Icon(widget.product == null ? I.add : I.save),
                      label: Text(
                        // TODO: text
                        widget.product == null ? 'Hinzufügen' : 'Speichern',
                      ),
                      onPressed: () async {
                        // TODO: clean
                        MediaHelper.closeKeyboard(context);
                        final productProvider = Provider.of<ProductProvider>(
                          context,
                          listen: false,
                        );

                        final priceAsDouble = double.tryParse(
                          _tecPrice.text.trim(),
                        );
                        int? priceAsInt;
                        if (priceAsDouble != null) {
                          priceAsInt = (priceAsDouble * 100).toInt();
                          print('priceAsInt: $priceAsInt');
                        } else {
                          _errorToast('Ungültiger Preis');
                          return;
                        }

                        final avt = int.tryParse(_tecAvt.text.trim());
                        print('avt: $avt');
                        if (avt == null) {
                          // TODO: text
                          _errorToast('Ungültiger Mehrwertsteuersatz');
                          return;
                        }

                        final stockAsInt = int.tryParse(_tecStock.text.trim());
                        print('stockAsInt: $stockAsInt');
                        if (stockAsInt == null) {
                          // TODO: text
                          _errorToast('Ungültige Lagerbestand Eingabe');
                          return;
                        }

                        //! add product
                        if (widget.product == null) {
                          if (_pickedThumbnail == null) {
                            // TODO: text
                            _errorToast('Vorschaubild');
                            return;
                          }

                          // TODO: text
                          if (_pickedProductImages.isEmpty) {
                            _errorToast('Produktbilder');
                            return;
                          }

                          setState(() => _isUploading = true);

                          String? thumbnailUrl;
                          thumbnailUrl = await productProvider
                              .uploadImageToStorage(_pickedThumbnail ?? '');

                          List<String> imagesProductUrls = [];
                          for (var img in _pickedProductImages) {
                            final uploadedImg = await productProvider
                                .uploadImageToStorage(img);
                            if (uploadedImg != null) {
                              imagesProductUrls.add(uploadedImg);
                            }
                          }

                          final product = Product(
                            productId: Helpers.genIntId(),
                            isActive: _isActive,
                            name: _tecName.text.trim(),
                            labelName: _tecLabelName.text.trim(),
                            description: _tecDescription.text.trim(),
                            category: _tecCategories.text.trim(),
                            price: priceAsInt,
                            avt: avt,
                            currency: _tecCurrency.text.trim(),
                            stock: stockAsInt,
                            rating: 0,
                            thumbnail: thumbnailUrl,
                            images: imagesProductUrls,
                            attributes: Attributes(
                              color: _tecAtbColor.text.trim(),
                              size: _tecAtbSize.text.trim(),
                              weight: _tecAtbWeight.text.trim(),
                              dimensions: _tecAtbDimensions.text.trim(),
                            ),
                            tags: const [],
                            reviews: const [],
                            relatedProducts: const [],
                            created: Timestamp.now(),
                            supplier: Supplier(
                              supplierId: "",
                              name: _tecSuppliersName.text.trim(),
                              contact: "",
                              phone: "",
                            ),
                          );

                          await productProvider.add(product);

                          //! update product
                        } else {
                          String? thumbnailUrl;
                          if (_pickedThumbnail != null) {
                            await productProvider.deleteImageFromStorage(
                              widget.product?.thumbnail,
                            );
                            thumbnailUrl = await productProvider
                                .uploadImageToStorage(_pickedThumbnail ?? '');
                          }

                          List<String>? imagesProductUrls;
                          if (_pickedProductImages.isNotEmpty) {
                            List<String> uploadedImagesUrls = [];

                            for (var img in widget.product?.images ?? []) {
                              await productProvider.deleteImageFromStorage(img);
                            }

                            for (var img in _pickedProductImages) {
                              final uploadedImg = await productProvider
                                  .uploadImageToStorage(img);
                              if (uploadedImg != null) {
                                uploadedImagesUrls.add(uploadedImg);
                              }
                            }

                            imagesProductUrls = uploadedImagesUrls;
                          }

                          final product = widget.product?.copyWith(
                            isActive: _isActive,
                            name: _tecName.text.trim(),
                            labelName: _tecLabelName.text.trim(),
                            description: _tecDescription.text.trim(),
                            category: _tecCategories.text.trim(),
                            price: priceAsInt,
                            avt: avt,
                            currency: _tecCurrency.text.trim(),
                            stock: stockAsInt,
                            rating: 0,
                            thumbnail: thumbnailUrl,
                            images: imagesProductUrls,
                            attributes: Attributes(
                              color: _tecAtbColor.text.trim(),
                              size: _tecAtbSize.text.trim(),
                              weight: _tecAtbWeight.text.trim(),
                              dimensions: _tecAtbDimensions.text.trim(),
                            ),
                            supplier: Supplier(
                              name: _tecSuppliersName.text.trim(),
                            ),
                          );

                          await productProvider.update(product);
                        }

                        if (context.mounted) context.pop();
                        setState(() => _isUploading = false);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _isUploading,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                height: MediaHelper.h(context),
                width: MediaHelper.w(context),
                color: Colors.black.withValues(alpha: 0.1),
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgUnDrawImage(path: Assets.undraws.upload),
                      const LoadingIndicator(),
                      K.pvm.verticalSpace,
                      Text(
                        // TODO: text
                        'Bitte warten, Upload läuft.',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _errorToast(String msg) {
    ToastUtils.show(msg: msg, bgRed: true);
  }
}

import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/utils/utility/toast_utils.dart';
import 'package:albus_la_mobile/core/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// TODO: remove

Future<bool?> showAddProductGroupBtmNavSheet({
  required BuildContext context,
}) async {
  return await showModalBottomSheet<bool?>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: false,
    useRootNavigator: true,
    builder: (_) => _AddProductGroupBtmNavSheet(),
  );
}

class _AddProductGroupBtmNavSheet extends StatefulWidget {
  const _AddProductGroupBtmNavSheet();

  @override
  State<_AddProductGroupBtmNavSheet> createState() =>
      _AddProductGroupBtmNavSheetState();
}

class _AddProductGroupBtmNavSheetState
    extends State<_AddProductGroupBtmNavSheet> {
  late TextEditingController _tecName, _tecDescription, _tecQuantity;

  bool _nameTecError = false;
  bool _priceTecError = false;

  @override
  void initState() {
    // _isUpdate = widget.productSize != null;

    // _available = widget.productSize?.available ?? true;

    _tecName = TextEditingController(text: '');
    _tecDescription = TextEditingController(text: '');
    _tecQuantity = TextEditingController(text: '');

    super.initState();
  }

  @override
  void dispose() {
    _tecName.dispose();
    _tecDescription.dispose();
    _tecQuantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInsets = MediaHelper.getBottomInsets(context);
    final btmViewPadding = MediaHelper.androidBtmNavBarH(context);
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: K.pm),
      child: Column(
        children: [
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (K.pm + (K.ps * 2) + K.pvm).verticalSpace,
                  Text(
                    // TODO: text
                    'Gruppe hinzufügen',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  K.pvl.verticalSpace,
                  Column(
                    children: [
                      /* AcitveInactiveListTile(
                        value: _available,
                        redShadowIfFalse: true,
                        //! text
                        title: 'Verfügbar?',
                        onChanged: (val) => setState(() => _available = val),
                      ), */
                      K.pvm.verticalSpace,
                      TextFieldWidget(
                        controller: _tecName,
                        //! text
                        hintText: 'Name*',
                        // TODO: icon
                        // suffixIcon: I.foodBank,
                        //! text
                        errorText: _nameTecError ? 'Pflichtfeld*' : null,
                        // maxLength: K.titleMaxLength,
                      ),
                      K.pvm.verticalSpace,
                      TextFieldWidget(
                        controller: _tecQuantity,
                        //! text
                        hintText: 'Menge',
                        keyType: TextInputType.datetime,
                        suffixIcon: I.size,
                        //! text
                        helperText: 'z. B. 100 oder 1000',
                        maxLength: 10,
                      ),
                      K.pvm.verticalSpace,
                      TextFieldWidget(
                        controller: _tecDescription,
                        //! text
                        hintText: 'Beschreibung',
                        suffixIcon: I.description,
                        //! text
                        maxLength: 500,
                        minLines: 3,
                        maxLines: 5,
                      ),
                      K.pvm.verticalSpace,
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: Icon(I.add),
                          //! text
                          label: Text('Hinzufügen'),
                          onPressed: _onAddOrUpdate,
                        ),
                      ),
                      K.pvm.verticalSpace,
                      /*                       Visibility(
                        visible: _isUpdate,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: Icon(I.delete),
                            //! text
                            label: const Text('Löschen'),
                            style: Theme.of(context)
                                .elevatedButtonTheme
                                .style
                                ?.copyWith(
                                  backgroundColor: const WidgetStatePropertyAll(
                                    Colors.red,
                                  ),
                                ),
                            onPressed: () async {
                              MediaHelper.closeKeyboard(context);
    /*                               await DialogsUtils.okCancelDialog(
                                context: context,
                                //! text
                                title: 'Löschen?',
                                message: _tecName.text.trim(),
                                onOk: () {
                                  widget.onDeleted?.call();
                                  context.pop();
                                  context.pop();
                                },
                              ); */
                            },
                          ),
                        ),
                      ), */
                    ],
                  ),
                  MediaHelper.androidBtmNavBarH(context).verticalSpace,
                ],
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: (K.ps * 2) + 15.0.h,
                  width: double.infinity,
                  color: Theme.of(
                    context,
                  ).bottomSheetTheme.backgroundColor?.withValues(alpha: 0.8),
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(K.ps),
                  child: Container(
                    height: 7.0.h,
                    width: 140.0.w,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(K.rm),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(K.ps),
                  child: CloseButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Colors.red.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: bottomInsets > 0
                ? bottomInsets + K.pvm + btmViewPadding
                : btmViewPadding + K.pvm,
          ),
        ],
      ),
    );
  }

  void _onAddOrUpdate() async {
    MediaHelper.closeKeyboard(context);

    if (_tecName.text.trim().isEmpty) {
      setState(() => _nameTecError = true);
      //! text
      ToastUtils.error('Kategoriename ist ein Pflichtfeld');
      return;
    }

    //! price check
    int? priceInt;
    final trimedPrice = _tecQuantity.text.trim();
    double? priceDouble = double.tryParse(trimedPrice.replaceAll(',', '.'));
    if (priceDouble != null) {
      priceInt = (priceDouble * 100).round();
    } else {
      setState(() => _priceTecError = true);
      return;
    }

    /*     if (_isUpdate) {
      widget.onChanged(
        widget.productSize?.copyWith(
              name: _tecName.text.trim(),
              quantity: _tecQuantity.text.trim(),
              price: priceInt,
              available: _available,
            ) ??
            ProductSize(),
      );
    } else {
      widget.onChanged(
        ProductSize(
          name: _tecName.text.trim(),
          quantity: _tecQuantity.text.trim(),
          price: priceInt,
          available: _available,
        ),
      );
    } */

    if (!mounted) return;
    // context.pop();
  }
}

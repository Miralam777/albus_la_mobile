import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:albus_la_mobile/configs/extensions/extensions.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/helpers.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/utils/utility/dialogs_utils.dart';
import 'package:albus_la_mobile/core/utils/utility/toast_utils.dart';
import 'package:albus_la_mobile/core/widgets/loading_indicator.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/core/widgets/svg_un_draw_image.dart';
import 'package:albus_la_mobile/core/widgets/switch.dart';
import 'package:albus_la_mobile/core/widgets/text_field.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/license_provider.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/license/license.dart';
import 'package:albus_la_mobile/features/home/presentation/widgets/home/products_view/license_card.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AddUpdateLicensePage extends StatefulWidget {
  const AddUpdateLicensePage({super.key, required this.license});

  final License? license;

  @override
  State<AddUpdateLicensePage> createState() => _AddUpdateLicensePageState();
}

class _AddUpdateLicensePageState extends State<AddUpdateLicensePage> {
  late TextEditingController _tecAmount,
      _tecName,
      _tecDescription,
      _tecPrice,
      _tecAvt,
      _tecCurrency;

  late bool _isActive;
  bool _isUploading = false;

  final _horizontalPaddingPm = EdgeInsets.symmetric(horizontal: K.pm);

  @override
  void initState() {
    final license = widget.license;
    _isActive = license?.isActive ?? false;

    _tecAmount = TextEditingController(text: (license?.amount ?? 0).toString());
    // TODO remove "5 Qr-Code-Lizenz nur für:"
    _tecName = TextEditingController(
      text: license?.name ?? '0 Qr-Code-Lizenz nur für:',
    );
    _tecDescription = TextEditingController(text: license?.description);
    _tecPrice = TextEditingController(
      text: (license?.price ?? 0).toStringPricePoint(),
    );
    _tecAvt = TextEditingController(
      text: license?.avt != null ? license?.avt.toString() : '19',
    );
    _tecCurrency = TextEditingController(text: license?.currency);
    super.initState();
  }

  @override
  void dispose() {
    _tecAmount.dispose();
    _tecName.dispose();
    _tecDescription.dispose();
    _tecPrice.dispose();
    _tecAvt.dispose();
    _tecCurrency.dispose();
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
            title: widget.license == null
                ? 'Lizenz hinzufügen'
                : 'Lizenz bearbeiten',
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaHelper.statusAndAppBarH(context) + K.pvm,
              bottom: MediaHelper.androidBtmNavBarH(context) + K.pvl2x,
            ),
            child: Column(
              children: [
                // ! ************************* license card
                SizedBox(
                  height: 245.h,
                  child: LicenseCard(
                    license: License(
                      isActive: _isActive,
                      amount: int.tryParse(_tecAmount.text),
                      price:
                          (int.tryParse(_tecPrice.text.replaceAll('.', '')) ??
                          0),
                      name: _tecName.text,
                    ),
                  ),
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
                        controller: _tecAmount,
                        // TODO: text
                        hintText: 'Anzahl',
                        keyType: TextInputType.number,
                        suffixIcon: I.numbers,
                        onChanged: (_) => setState(() {}),
                      ),
                      K.pvm.verticalSpace,
                      TextFieldWidget(
                        controller: _tecName,
                        // TODO: text
                        hintText: 'Produktname',
                        onChanged: (_) => setState(() {}),
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
                        controller: _tecPrice,
                        // TODO: text
                        hintText: 'Preis',
                        // TODO: text
                        helperText: 'Z. B.: 5, 7.99, 8.01',
                        suffixIcon: I.euro,
                        keyType: TextInputType.datetime,
                        onChanged: (_) => setState(() {}),
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
                      icon: Icon(widget.license == null ? I.add : I.save),
                      label: Text(
                        // TODO: text
                        widget.license == null ? 'Hinzufügen' : 'Speichern',
                      ),
                      onPressed: () async {
                        // TODO: clean

                        MediaHelper.closeKeyboard(context);
                        final licenseProvider = Provider.of<LicenseProvider>(
                          context,
                          listen: false,
                        );

                        final amount = int.tryParse(_tecAmount.text.trim());
                        print('amount: $amount');
                        if (amount == null) {
                          // TODO: text
                          _errorToast('Ungültige Anzahl Eingabe');
                          return;
                        }

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

                        //! add License
                        if (widget.license == null) {
                          setState(() => _isUploading = true);

                          final license = License(
                            licenseId: Helpers.genIntId(),
                            isActive: _isActive,
                            name: _tecName.text.trim(),
                            description: _tecDescription.text.trim(),
                            price: priceAsInt,
                            avt: avt,
                            currency: _tecCurrency.text.trim(),
                            amount: amount,
                            created: Timestamp.now(),
                          );

                          await licenseProvider.add(license);

                          //! update License
                        } else {
                          final license = widget.license?.copyWith(
                            isActive: _isActive,
                            name: _tecName.text.trim(),
                            description: _tecDescription.text.trim(),
                            price: priceAsInt,
                            avt: avt,
                            currency: _tecCurrency.text.trim(),
                            amount: amount,
                          );

                          await licenseProvider.update(license);
                        }

                        if (context.mounted) context.pop();
                        setState(() => _isUploading = false);
                      },
                    ),
                  ),
                ),
                if (widget.license != null) K.pvl.verticalSpace,

                // ! ************************* delete btn
                if (widget.license != null)
                  Padding(
                    padding: _horizontalPaddingPm,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: Icon(I.deleteForever),
                        label: const Text(
                          // TODO: text
                          'Löschen',
                        ),
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.red),
                        ),
                        onPressed: () async {
                          MediaHelper.closeKeyboard(context);
                          await DialogsUtils.showOkCancelDialog(
                            context: context,
                            // TODO: text
                            title: 'Löschen?',
                            showLoadingIndacator: true,
                            onOk: () async {
                              await Provider.of<LicenseProvider>(
                                context,
                                listen: false,
                              ).delete(widget.license?.dId);
                              if (context.mounted) {
                                context.pop();
                                context.pop();
                              }
                            },
                          );
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

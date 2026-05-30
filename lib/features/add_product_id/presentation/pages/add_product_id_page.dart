import 'package:albus_la_mobile/configs/network/network_info.dart';
import 'package:albus_la_mobile/configs/services/firebase/firestore_service.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/global/user_provider.dart';
import 'package:albus_la_mobile/core/utils/helpers/bloc_events_helper.dart';
import 'package:albus_la_mobile/core/utils/helpers/helpers.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/utils/utility/toast_utils.dart';
import 'package:albus_la_mobile/core/widgets/loading_indicator.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/core/widgets/printer_status_icon.dart';
import 'package:albus_la_mobile/features/add_product_id/domain/entities/added_id.dart';
import 'package:albus_la_mobile/features/add_product_id/helpers/add_product_id.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/bloc/add_product_id_bloc.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/widgets/widgets.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/product_label_printer_provider.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddProductIdPage extends StatefulWidget {
  const AddProductIdPage({
    super.key,
    required this.addedId,
    required this.manufactured,
  });

  final bool manufactured;
  final AddedId? addedId;

  @override
  State<AddProductIdPage> createState() => _AudGenQrcodePageState();
}

class _AudGenQrcodePageState extends State<AddProductIdPage> {
  static const _unknowString = 'Unknow';

  List<_ProducdNameAndId> _producdNameAndIdList = [
    _ProducdNameAndId(id: null, name: _unknowString),
  ];

  late _ProducdNameAndId _selectedProducdNameAndId;

  AddedId? _addedId;

  bool _manufactured = false;
  bool _wasTestSuccessful = false;
  bool _ticketPrinted = false;

  @override
  void initState() {
    _addedId = widget.addedId;

    if (widget.manufactured) {
      _manufactured = true;
      _wasTestSuccessful = true;
      _ticketPrinted = true;
    }

    final products = Provider.of<ProductProvider>(
      context,
      listen: false,
    ).getProducts;
    if (products.isNotEmpty) {
      final listOfLabelNames = products.map<_ProducdNameAndId>((p) {
        return _ProducdNameAndId(
          id: p.productId,
          name: p.labelName ?? _unknowString,
        );
      }).toList();
      _producdNameAndIdList = listOfLabelNames;
    }

    if (_addedId != null) {
      for (var producdNameAndId in _producdNameAndIdList) {
        if (producdNameAndId.id == _addedId?.productId) {
          _selectedProducdNameAndId = producdNameAndId;
          break;
        }
      }
    } else {
      _selectedProducdNameAndId = _producdNameAndIdList[0];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const PrimaryAppBar(
        // TODO: text
        // title: 'Produkt-QR-Code hinzufügen.',
        title: 'Produkt-Qr-Code',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          K.pm,
          K.pvmH + MediaHelper.statusAndAppBarH(context),
          K.pm,
          K.pvmH + MediaHelper.androidBtmNavBarH(context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddQrcode(colorScheme),
            _buildCheckBoxAndTitle(
              isActive: _addedId != null,
              value: true,
              // TODO: text
              title: 'Produkt-QR-Code wurde hinzugefügt',
              onChanged: _addedId != null ? (val) {} : null,
            ),
            K.pvl.verticalSpace,
            _buildManufacturedQrcode(colorScheme),
            K.pvl.verticalSpace,
            _buildCheckBoxAndTitle(
              isActive: _addedId != null,
              value: _manufactured,
              // TODO: text
              title: 'Wurde das Produkt hergestellt?',
              onChanged: (val) {
                if (!widget.manufactured) {
                  if (val != null) {
                    setState(() => _manufactured = val);
                  }
                }
              },
            ),
            K.pvl.verticalSpace,
            _buildTextQrcode(colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildAddQrcode(ColorScheme colorScheme) {
    return IgnorePointer(
      ignoring: _addedId != null,
      child: Opacity(
        opacity: _addedId != null ? 0.5 : 1.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // TODO: text
              'Bezeichnungsname: ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            K.pvsx.verticalSpace,
            Material(
              color: colorScheme.tertiaryContainer,
              borderRadius: BorderRadius.circular(K.rm),
              child: DropdownButton<_ProducdNameAndId>(
                value: _selectedProducdNameAndId,
                isExpanded: true,
                isDense: true,
                iconSize: Theme.of(context).iconTheme.size ?? 24.0.r,
                alignment: Alignment.center,
                borderRadius: BorderRadius.circular(K.rm),
                underline: const SizedBox.shrink(),
                padding: EdgeInsets.all(K.ps),
                dropdownColor: colorScheme.tertiaryContainer,
                items: _producdNameAndIdList.map((item) {
                  return DropdownMenuItem<_ProducdNameAndId>(
                    value: item,
                    alignment: Alignment.center,
                    child: Text(
                      item.name ?? _unknowString,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  );
                }).toList(),
                onChanged: (_ProducdNameAndId? value) {
                  if (value != null) {
                    setState(() => _selectedProducdNameAndId = value);
                  }
                },
              ),
            ),
            K.pvl.verticalSpace,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(I.add),
                // TODO: text
                label: const Text('Qr-Code Hinzufügen'),
                onPressed: () {
                  if (_selectedProducdNameAndId.id != null) {
                    final uId = BlocEventsHelper.getUser(context)?.uId;

                    BlocProvider.of<AddProductIdBloc>(context).add(
                      GetAddProductIdEvent(
                        AddProductId(
                          uId: uId,
                          // TODO:
                          type: 1,
                          // TODO:
                          productId: _selectedProducdNameAndId.id,
                          name: _selectedProducdNameAndId.name,
                          // TODO: icon
                          iconId: 0,
                        ),
                      ),
                    );
                  } else {
                    // TODO: text
                    ToastUtils.error('Keine gültige Produkt-ID');
                  }
                },
              ),
            ),
            K.pvl.verticalSpace,
            BlocConsumer<AddProductIdBloc, AddProductIdState>(
              listener: (context, state) {
                if (state is AddProductIdAdded) {
                  setState(() => _addedId = state.addedId);
                }
              },
              builder: (context, state) {
                if (state is AddProductIdLoading) {
                  return const LoadingIndicator();
                } else if (state is AddProductIdAdded) {
                  return const SizedBox.shrink();
                } else if (state is AddProductIdFailure) {
                  return Text(
                    // TODO: text and error widget and failure to message
                    // TODO: error widget
                    'Da ist etwas schiefgelaufen (${state.failure.toString()})',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: colorScheme.error),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManufacturedQrcode(ColorScheme colorScheme) {
    return Opacity(
      opacity: _addedId != null ? 1.0 : 0.5,
      child: Container(
        padding: EdgeInsets.all(K.ps),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(K.rm),
          color: colorScheme.tertiaryContainer,
          boxShadow: [
            BoxShadow(
              color: _manufactured ? colorScheme.shadow : Colors.orange,
              blurRadius: 7.0.r,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: 90.0.h,
                  width: 90.0.h,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(K.rs),
                    color: colorScheme.secondaryContainer,
                  ),
                  child: QrImageView(
                    data: _addedId?.id ?? '',
                    version: QrVersions.auto,
                    eyeStyle: QrEyeStyle(
                      color: _manufactured ? Colors.black : Colors.orange,
                      eyeShape: QrEyeShape.square,
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      color: _manufactured ? Colors.black : Colors.orange,
                      dataModuleShape: QrDataModuleShape.square,
                    ),
                    size: 200.0.r,
                  ),
                ),
                K.ps.horizontalSpace,
                Expanded(
                  child: Column(
                    children: [
                      _titleAndText(
                        context: context,
                        // TODO: text
                        title: 'ID: ',
                        text: _addedId?.id,
                      ),
                      const Divider(),
                      _titleAndText(
                        context: context,
                        // TODO: text
                        title: 'B-Name: ',
                        text: _addedId?.name,
                      ),
                      const Divider(),
                      _titleAndText(
                        context: context,
                        // TODO: text
                        title: 'P-ID: ',
                        text: _addedId?.productId.toString(),
                      ),
                      const Divider(),
                      _titleAndText(
                        context: context,
                        // TODO: text
                        title: 'Datum: ',
                        text: _addedId?.createdAt != null
                            ? Helpers.getTimeAndHourFromTimestamp(
                                _addedId?.createdAt,
                              )
                            : '',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _titleAndText({
    required BuildContext context,
    required String title,
    required String? text,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        Expanded(
          child: Text(
            text ?? '',
            maxLines: 2,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckBoxAndTitle({
    required bool isActive,
    required bool value,
    required String title,
    void Function(bool?)? onChanged,
  }) {
    return Opacity(
      opacity: isActive ? 1.0 : 0.5,
      child: Row(
        children: [
          Transform.scale(
            scale: 1.2.r,
            child: Checkbox(
              value: value,
              activeColor: Theme.of(context).colorScheme.primary,
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(360),
              ),
              onChanged: isActive ? onChanged : null,
            ),
          ),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.clip,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextQrcode(ColorScheme colorScheme) {
    return Column(
      children: [
        IgnorePointer(
          ignoring: !_manufactured,
          child: Opacity(
            opacity: _manufactured ? 1.0 : 0.5,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(I.qrCodeScanner),
                // TODO: text
                label: const Text('Qr-Code testen'),
                onPressed: () async {
                  final wasTestSuccessful =
                      await showTestProductQrcodeBtmNavSheet(
                        context: context,
                        qrId: _addedId?.id,
                      );
                  if (wasTestSuccessful ?? false) {
                    setState(() => _wasTestSuccessful = true);
                  }
                },
              ),
            ),
          ),
        ),
        K.pvm.verticalSpace,
        _buildCheckBoxAndTitle(
          isActive: _wasTestSuccessful,
          value: true,
          // TODO: text
          title: 'Test erfolgreich abgeschlossen.',
          onChanged: _wasTestSuccessful ? (val) {} : null,
        ),
        K.pvm.verticalSpace,
        IgnorePointer(
          ignoring: !_wasTestSuccessful,
          child: Opacity(
            opacity: _wasTestSuccessful ? 1.0 : 0.5,
            child: SizedBox(
              width: double.infinity,
              child: Consumer<ProductLabelPrinterProvider>(
                builder: (_, provider, __) {
                  return ElevatedButton.icon(
                    // TODO: text
                    label: const Text('Ticket ausdrucken'),
                    icon: provider.isStatusChecking
                        ? SizedBox.square(
                            dimension: 25.0.r,
                            child: const LoadingIndicator(color: Colors.white),
                          )
                        : PrinterStatusIcon(isConnected: provider.isConnected),
                    onPressed: () async {
                      await provider.checkStatus();

                      if (provider.isConnected) {
                        final islabelPrinted = await provider.printLabel(
                          title: _addedId?.name ?? '',
                          qrcode: _addedId?.id ?? '',
                          barcode: _addedId?.productId.toString() ?? '',
                        );

                        if (!islabelPrinted) {
                          // TODO: text
                          ToastUtils.error(
                            'Etikett konnte nicht gedruckt werden',
                          );
                        }

                        setState(() => _ticketPrinted = true);
                      } else {
                        print('in else');
                        // TODO: text
                        ToastUtils.error(
                          'Keine Verbindung zum Drucker (${provider.ipAddress}).',
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ),
        K.pvm.verticalSpace,
        _buildCheckBoxAndTitle(
          isActive: _ticketPrinted,
          value: true,
          // TODO: text
          title: 'Ticket erfolgreich ausgedruckt.',
          onChanged: _ticketPrinted ? (val) {} : null,
        ),
        K.pvl.verticalSpace,
        if (widget.manufactured)
          _buildCreatorWidget(uId: _addedId?.creator, colorScheme: colorScheme),
        K.pvl.verticalSpace,
        IgnorePointer(
          ignoring: !_ticketPrinted || widget.manufactured,
          child: Opacity(
            opacity: (_ticketPrinted && !widget.manufactured) ? 1.0 : 0.5,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(I.save),
                // TODO: text
                label: const Text('Speichern'),
                onPressed: () async {
                  final hasInternet = await NetworkInfo().isConnected;
                  if (hasInternet) {
                    final isUploaded =
                        await FirestoreService.productManufactured(
                          _addedId?.id,
                        );
                    if (isUploaded) {
                      if (!mounted) return;
                      context.pop();
                    } else {
                      // TODO: text
                      ToastUtils.error('Etwas ist schiefgelaufen.');
                    }
                  } else {
                    // TODO: text
                    ToastUtils.error('Keine Internetverbindung.');
                  }
                },
              ),
            ),
          ),
        ),
        K.pvl2x.verticalSpace,
      ],
    );
  }

  Row _buildCreatorWidget({
    required String? uId,
    required ColorScheme colorScheme,
  }) {
    final admin = Provider.of<UserProvider>(
      context,
      listen: false,
    ).getAdminByUId(uId);

    return Row(
      children: [
        CircleAvatar(
          maxRadius: 20.0.r,
          backgroundColor: colorScheme.secondaryContainer,
          foregroundColor: Theme.of(context).iconTheme.color,
          child: Icon(I.person),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: Text(
            '${admin?.firstname} ${admin?.surname}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class _ProducdNameAndId {
  final int? id;
  final String? name;
  _ProducdNameAndId({required this.id, required this.name});
}

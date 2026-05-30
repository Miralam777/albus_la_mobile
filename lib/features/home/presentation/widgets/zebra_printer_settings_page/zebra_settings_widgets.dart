import 'dart:io';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/widgets/text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:a_zebra_utils/zsdk.dart' as zebra;
import 'package:zsdk/zsdk.dart' as zebra;

class ZebraSettingsWidgets extends StatefulWidget {
  const ZebraSettingsWidgets({
    super.key,
    required this.printerTitle,
    required this.ipAddress,
    required this.testZplData,
    required this.onIpSave,
  });

  final String printerTitle;
  final String? ipAddress;
  final String testZplData;
  final void Function(String) onIpSave;

  @override
  State createState() => _ZebraPinterSettingsPageState();
}

enum OperationStatus { sending, receiving, success, error, none }

class _ZebraPinterSettingsPageState extends State<ZebraSettingsWidgets> {
  // ! cmds
  static const String btnPrintPdfFileOverTCPIP = 'btnPrintPdfFileOverTCPIP';
  static const String btnPrintZplFileOverTCPIP = 'btnPrintZplFileOverTCPIP';
  static const String btnPrintZplDataOverTCPIP = 'btnPrintZplDataOverTCPIP';
  static const String btnCheckPrinterStatus = 'btnCheckPrinterStatus';
  static const String btnGetPrinterSettings = 'btnGetPrinterSettings';
  static const String btnSetPrinterSettings = 'btnSetPrinterSettings';
  static const String btnResetPrinterSettings = 'btnResetPrinterSettings';
  static const String btnDoManualCalibration = 'btnDoManualCalibration';
  static const String btnPrintConfigurationLabel = 'btnPrintConfigurationLabel';
  static const String btnRebootPrinter = 'btnRebootPrinter';

  final zebra.ZSDK zsdk = zebra.ZSDK();

  final _scrollController = ScrollController();

  final _tecIpAddress = TextEditingController();
  final _tecPortAddress = TextEditingController(text: '9100');
  final _tecPath = TextEditingController();
  final _tecZplData = TextEditingController();
  final _tecWidth = TextEditingController();
  final _tecHeight = TextEditingController();
  final _tecDpi = TextEditingController();
  final _tecDarkness = TextEditingController();
  final _tecPrintSpeed = TextEditingController();
  final _tecTearOff = TextEditingController();
  final _tecPrintWidth = TextEditingController(text: '40');
  final _tecLabelLength = TextEditingController(text: '30');
  final _tecLabelLengthMax = TextEditingController(text: '50');
  final _tecLabelTop = TextEditingController();
  final _tecLeftPosition = TextEditingController();

  zebra.MediaType? _selectedMediaType;
  zebra.PrintMethod? _selectedPrintMethod;
  zebra.ZPLMode? _selectedZPLMode;
  zebra.PowerUpAction? _selectedPowerUpAction;
  zebra.HeadCloseAction? _selectedHeadCloseAction;
  zebra.PrintMode? _selectedPrintMode;
  zebra.ReprintMode? _selectedReprintMode;
  zebra.VirtualDevice? _selectedVirtualDevice;
  zebra.PrinterSettings? _settings;
  zebra.Orientation _printerOrientation = zebra.Orientation.LANDSCAPE;

  String? _message;
  String? _statusMessage;
  String? _settingsMessage;
  String? _calibrationMessage;
  OperationStatus _printStatus = OperationStatus.none;
  OperationStatus _checkingStatus = OperationStatus.none;
  OperationStatus _settingsStatus = OperationStatus.none;
  OperationStatus _calibrationStatus = OperationStatus.none;
  OperationStatus _rebootingStatus = OperationStatus.none;
  String? _filePath;
  String? _zplData;

  @override
  void initState() {
    _tecIpAddress.value = TextEditingValue(text: widget.ipAddress ?? '');

    _tecZplData.value = TextEditingValue(text: widget.testZplData);

    onClick(btnGetPrinterSettings);
    onClick(btnCheckPrinterStatus);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  String getName<T>(T value) {
    String name = 'Unknown';
    if (value is zebra.HeadCloseAction) name = value.name;
    if (value is zebra.MediaType) name = value.name;
    if (value is zebra.PowerUpAction) name = value.name;
    if (value is zebra.PrintMethod) name = value.name;
    if (value is zebra.PrintMode) name = value.name;
    if (value is zebra.ReprintMode) name = value.name;
    if (value is zebra.VirtualDevice) name = value.name;
    if (value is zebra.ZPLMode) name = value.name;
    return name;
  }

  List<DropdownMenuItem<T>> generateDropdownItems<T>(List<T> values) {
    List<DropdownMenuItem<T>> items = [];
    for (var value in values) {
      items.add(DropdownMenuItem<T>(value: value, child: Text(getName(value))));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final dropdownIconSize = Theme.of(context).iconTheme.size ?? 24.0.r;
    final dropdownColor = colorScheme.primaryContainer;

    return CupertinoScrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.fromLTRB(
          K.pvmH,
          K.pm + MediaHelper.statusAndAppBarHWithoutAppBar(context),
          K.pm,
          kToolbarHeight.h +
              K.pvl2x +
              MediaHelper.androidBtmNavBarH(context) +
              MediaHelper.statusAndAppBarHWithoutAppBar(context),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.printerTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            _buildCard(
              title: 'Printer address',
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: TextFieldWidget(
                        controller: _tecIpAddress,
                        hintText: 'Printer IP address',
                        fillColor: colorScheme.secondaryContainer,
                      ),
                    ),
                    IconButton(
                      icon: Icon(I.save),
                      onPressed: () => widget.onIpSave(_tecIpAddress.text),
                    ),
                  ],
                ),
                K.pvs.verticalSpace,
                TextFieldWidget(
                  controller: _tecPortAddress,
                  hintText: 'Printer port (defaults to 9100)',
                  fillColor: colorScheme.secondaryContainer,
                ),
                K.pvs.verticalSpace,
                Visibility(
                  visible:
                      _checkingStatus != OperationStatus.none ||
                      _rebootingStatus != OperationStatus.none,
                  child: Column(
                    children: <Widget>[
                      Text(
                        '$_statusMessage',
                        overflow: TextOverflow.clip,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: getOperationStatusColor(
                            _checkingStatus != OperationStatus.none
                                ? _checkingStatus
                                : _rebootingStatus,
                          ),
                        ),
                      ),
                      K.pvs.verticalSpace,
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  Colors.orange,
                                ),
                              ),
                              onPressed:
                                  _checkingStatus == OperationStatus.receiving
                                  ? null
                                  : () => onClick(btnCheckPrinterStatus),
                              child: const Text('Check printer status'),
                            ),
                          ),
                          K.ps.horizontalSpace,
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(
                                  Colors.red,
                                ),
                              ),
                              onPressed:
                                  _checkingStatus == OperationStatus.sending
                                  ? null
                                  : () => onClick(btnRebootPrinter),
                              child: const Text('Reboot Printer'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildCard(
              title: 'Printer settings',
              children: <Widget>[
                _buildTitleAndText(
                  isFirst: true,
                  title: 'Brand and model: ',
                  text: _settings?.printerModelName,
                ),
                _buildTitleAndText(
                  title: 'Device friendly name: ',
                  text: _settings?.deviceFriendlyName,
                ),
                _buildTitleAndText(
                  title: 'Firmware: ',
                  text: _settings?.firmware,
                ),
                _buildTitleAndText(
                  title: 'Link-OS Version: ',
                  text: _settings?.linkOSVersion,
                ),
                _buildTitleAndText(
                  title: 'Printer DPI: ',
                  text: _settings?.printerDpi,
                ),
                _buildTitleAndText(
                  title: 'Resolution in dots per millimeter (dpmm): ',
                  text: _settings?.devicePrintHeadResolution != null
                      ? '${double.tryParse(_settings?.devicePrintHeadResolution ?? '')?.truncate()}dpmm'
                      : 'Unknown',
                ),
                K.pvs.verticalSpace,
                TextFieldWidget(
                  controller: _tecDarkness,
                  hintText: 'Darkness',
                  keyType: const TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  fillColor: colorScheme.secondaryContainer,
                ),
                K.pvs.verticalSpace,
                TextFieldWidget(
                  controller: _tecPrintSpeed,
                  hintText: 'Print speed',
                  keyType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  fillColor: colorScheme.secondaryContainer,
                ),
                K.pvs.verticalSpace,
                TextFieldWidget(
                  controller: _tecTearOff,
                  hintText: 'Tear off',
                  keyType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  fillColor: colorScheme.secondaryContainer,
                ),
                K.pvs.verticalSpace,
                DropdownButtonFormField<zebra.MediaType>(
                  dropdownColor: dropdownColor,
                  iconSize: dropdownIconSize,
                  items: generateDropdownItems(zebra.MediaType.values),
                  value: _selectedMediaType,
                  onChanged: (value) =>
                      setState(() => _selectedMediaType = value),
                  decoration: const InputDecoration(labelText: 'Media type'),
                ),
                K.pvs.verticalSpace,
                DropdownButtonFormField<zebra.PrintMethod>(
                  dropdownColor: dropdownColor,
                  iconSize: dropdownIconSize,
                  items: generateDropdownItems(zebra.PrintMethod.values),
                  value: _selectedPrintMethod,
                  onChanged: (value) =>
                      setState(() => _selectedPrintMethod = value),
                  decoration: const InputDecoration(labelText: 'Print method'),
                ),
                K.pvs.verticalSpace,
                TextFieldWidget(
                  controller: _tecPrintWidth,
                  hintText: 'Print width',
                  keyType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  fillColor: colorScheme.secondaryContainer,
                ),
                K.pvs.verticalSpace,
                TextFieldWidget(
                  controller: _tecLabelLength,
                  hintText: 'Label length',
                  keyType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  fillColor: colorScheme.secondaryContainer,
                ),
                K.pvs.verticalSpace,
                TextFieldWidget(
                  controller: _tecLabelLengthMax,
                  hintText: 'Label length max',
                  keyType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  fillColor: colorScheme.secondaryContainer,
                ),
                K.pvs.verticalSpace,
                DropdownButtonFormField<zebra.ZPLMode>(
                  dropdownColor: dropdownColor,
                  iconSize: dropdownIconSize,
                  items: generateDropdownItems(zebra.ZPLMode.values),
                  value: _selectedZPLMode,
                  onChanged: (value) =>
                      setState(() => _selectedZPLMode = value),
                  decoration: const InputDecoration(labelText: 'ZPL mode'),
                ),
                K.pvs.verticalSpace,
                DropdownButtonFormField<zebra.PowerUpAction>(
                  dropdownColor: dropdownColor,
                  iconSize: dropdownIconSize,
                  items: generateDropdownItems(zebra.PowerUpAction.values),
                  value: _selectedPowerUpAction,
                  onChanged: (value) =>
                      setState(() => _selectedPowerUpAction = value),
                  decoration: const InputDecoration(
                    labelText: 'Power up action',
                  ),
                ),
                K.pvs.verticalSpace,
                DropdownButtonFormField<zebra.HeadCloseAction>(
                  dropdownColor: dropdownColor,
                  iconSize: dropdownIconSize,
                  items: generateDropdownItems(zebra.HeadCloseAction.values),
                  value: _selectedHeadCloseAction,
                  onChanged: (value) =>
                      setState(() => _selectedHeadCloseAction = value),
                  decoration: const InputDecoration(
                    labelText: 'Head close action',
                  ),
                ),
                K.pvs.verticalSpace,
                TextFieldWidget(
                  controller: _tecLabelTop,
                  hintText: 'Label top',
                  keyType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  fillColor: colorScheme.secondaryContainer,
                ),
                K.pvs.verticalSpace,
                TextFieldWidget(
                  controller: _tecLeftPosition,
                  hintText: 'Left position',
                  keyType: const TextInputType.numberWithOptions(
                    signed: false,
                    decimal: false,
                  ),
                  fillColor: colorScheme.secondaryContainer,
                ),
                K.pvs.verticalSpace,
                DropdownButtonFormField<zebra.PrintMode>(
                  dropdownColor: dropdownColor,
                  iconSize: dropdownIconSize,
                  items: generateDropdownItems(zebra.PrintMode.values),
                  value: _selectedPrintMode,
                  onChanged: (value) =>
                      setState(() => _selectedPrintMode = value),
                  decoration: const InputDecoration(labelText: 'Print mode'),
                ),
                K.pvs.verticalSpace,
                DropdownButtonFormField<zebra.ReprintMode>(
                  dropdownColor: dropdownColor,
                  iconSize: dropdownIconSize,
                  items: generateDropdownItems(zebra.ReprintMode.values),
                  value: _selectedReprintMode,
                  onChanged: (value) =>
                      setState(() => _selectedReprintMode = value),
                  decoration: const InputDecoration(labelText: 'Reprint mode'),
                ),
                K.pvs.verticalSpace,
                DropdownButtonFormField<zebra.VirtualDevice>(
                  dropdownColor: dropdownColor,
                  iconSize: dropdownIconSize,
                  items: generateDropdownItems(zebra.VirtualDevice.values),
                  value: _selectedVirtualDevice,
                  onChanged: (value) =>
                      setState(() => _selectedVirtualDevice = value),
                  decoration: const InputDecoration(
                    labelText: 'Virtual device',
                  ),
                ),
                K.pvs.verticalSpace,
                Visibility(
                  visible: _settingsStatus != OperationStatus.none,
                  child: Text(
                    '$_settingsMessage',
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: getOperationStatusColor(_settingsStatus),
                    ),
                  ),
                ),
                K.pvs.verticalSpace,
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.deepPurple,
                          ),
                        ),
                        onPressed:
                            _settingsStatus == OperationStatus.sending ||
                                _settingsStatus == OperationStatus.receiving
                            ? null
                            : () => onClick(btnSetPrinterSettings),
                        child: const Text('Set settings'),
                      ),
                    ),
                    K.ps.horizontalSpace,
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.purple,
                          ),
                        ),
                        onPressed:
                            _settingsStatus == OperationStatus.sending ||
                                _settingsStatus == OperationStatus.receiving
                            ? null
                            : () => onClick(btnGetPrinterSettings),
                        child: const Text('Get settings'),
                      ),
                    ),
                  ],
                ),
                K.pvs.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.pink),
                    ),
                    onPressed:
                        _settingsStatus == OperationStatus.sending ||
                            _settingsStatus == OperationStatus.receiving
                        ? null
                        : () => onClick(btnResetPrinterSettings),
                    child: const Text('Reset settings'),
                  ),
                ),
              ],
            ),
            _buildCard(
              title: 'ZPL data to print',
              children: <Widget>[
                TextFieldWidget(
                  controller: _tecZplData,
                  hintText: 'ZPL data',
                  fillColor: colorScheme.secondaryContainer,
                  maxLines: 5,
                ),
                K.pvs.verticalSpace,
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Colors.blueAccent,
                      ),
                    ),
                    onPressed: _printStatus == OperationStatus.sending
                        ? null
                        : () => onClick(btnPrintZplDataOverTCPIP),
                    child: const Text('Print ZPL data'),
                  ),
                ),
              ],
            ),
            _buildCard(
              title: 'Print file over TCP/IP',
              children: <Widget>[
                TextFieldWidget(
                  controller: _tecPath,
                  hintText: 'File path',
                  fillColor: colorScheme.secondaryContainer,
                ),
                K.pvs.verticalSpace,
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.green,
                          ),
                        ),
                        child: const Text('Pick .zpl file'),
                        onPressed: () async {
                          try {
                            FilePickerResult? result =
                                await FilePicker.pickFiles(type: FileType.any);
                            if (result != null) {
                              _filePath = result.files.single.path;
                              if (_filePath != null) {
                                setState(() {
                                  _tecPath.text = _filePath ?? '';
                                });
                              }
                            }
                          } catch (e) {
                            showSnackBar(e.toString());
                          }
                        },
                      ),
                    ),
                    K.ps.horizontalSpace,
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.lightGreen,
                          ),
                        ),
                        child: const Text('Pick .pdf file'),
                        onPressed: () async {
                          try {
                            FilePickerResult? result =
                                await FilePicker.pickFiles(type: FileType.any);
                            if (result != null) {
                              _filePath = result.files.single.path;
                              if (_filePath != null) {
                                setState(() {
                                  _tecPath.text = _filePath ?? '';
                                });
                              }
                            }
                          } catch (e) {
                            showSnackBar(e.toString());
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            _buildCard(
              title: 'PDF print configurations',
              children: <Widget>[
                TextFieldWidget(
                  controller: _tecWidth,
                  hintText: 'Paper width in cm (defaults to 15.20 cm)',
                  keyType: const TextInputType.numberWithOptions(decimal: true),
                  fillColor: colorScheme.secondaryContainer,
                ),
                K.pvs.verticalSpace,
                TextFieldWidget(
                  controller: _tecHeight,
                  hintText: 'Paper height in cm (defaults to 7.00 cm)',
                  keyType: const TextInputType.numberWithOptions(decimal: true),
                  fillColor: colorScheme.secondaryContainer,
                ),
                K.pvs.verticalSpace,
                TextFieldWidget(
                  controller: _tecDpi,
                  hintText: 'Printer density per inch (defaults to 203 dpi)',
                  keyType: const TextInputType.numberWithOptions(decimal: true),
                  fillColor: colorScheme.secondaryContainer,
                ),
                K.pvs.verticalSpace,
                DropdownButtonFormField<zebra.Orientation>(
                  dropdownColor: dropdownColor,
                  iconSize: dropdownIconSize,
                  items: const [
                    DropdownMenuItem(
                      value: zebra.Orientation.PORTRAIT,
                      child: Text('Portrait'),
                    ),
                    DropdownMenuItem(
                      value: zebra.Orientation.LANDSCAPE,
                      child: Text('Landscape'),
                    ),
                  ],
                  value: _printerOrientation,
                  onChanged: (value) => setState(
                    () => _printerOrientation =
                        value ?? zebra.Orientation.LANDSCAPE,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Print orientation',
                  ),
                ),
                K.pvs.verticalSpace,
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.blueAccent,
                          ),
                        ),
                        onPressed: _printStatus == OperationStatus.sending
                            ? null
                            : () => onClick(btnPrintZplFileOverTCPIP),
                        child: const Text('Print zpl from file'),
                      ),
                    ),
                    K.ps.horizontalSpace,
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.lightBlue,
                          ),
                        ),
                        onPressed: _printStatus == OperationStatus.sending
                            ? null
                            : () => onClick(btnPrintPdfFileOverTCPIP),
                        child: const Text('Print pdf from file'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            _buildCard(
              title: 'Configuration print',
              children: [
                Visibility(
                  visible: _printStatus != OperationStatus.none,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: K.pvsH),
                    child: Text(
                      '$_message',
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: getOperationStatusColor(_printStatus),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(Colors.cyan),
                    ),
                    onPressed: _printStatus == OperationStatus.sending
                        ? null
                        : () => onClick(btnPrintConfigurationLabel),
                    child: const Text('Print'),
                  ),
                ),
              ],
            ),
            _buildCard(
              title: 'Printer calibration',
              children: <Widget>[
                Visibility(
                  visible: _calibrationStatus != OperationStatus.none,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: K.pvsH),
                    child: Text(
                      '$_calibrationMessage',
                      overflow: TextOverflow.clip,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: getOperationStatusColor(_calibrationStatus),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            Colors.blueGrey,
                          ),
                        ),
                        onPressed: _calibrationStatus == OperationStatus.sending
                            ? null
                            : () => onClick(btnDoManualCalibration),
                        child: const Text('Do manual calibration'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card _buildCard({String? title, required List<Widget> children}) {
    return Card(
      color: Theme.of(context).colorScheme.tertiaryContainer,
      elevation: 4,
      margin: EdgeInsets.only(top: K.pvmH),
      child: Padding(
        padding: EdgeInsets.all(K.ps),
        child: Column(
          children: [
            if (title != null)
              Text(title, style: Theme.of(context).textTheme.titleMedium),
            K.pvs.verticalSpace,
            ...children,
          ],
        ),
      ),
    );
  }

  Column _buildTitleAndText({
    bool isFirst = false,
    required String title,
    required String? text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isFirst) Divider(height: K.pvsxH),
        RichText(
          // textAlign: TextAlign.left,
          text: TextSpan(
            style: Theme.of(context).textTheme.titleSmall,
            children: [
              TextSpan(
                text: title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).secondaryHeaderColor,
                ),
              ),
              TextSpan(text: text ?? 'Unknown'),
            ],
          ),
        ),
        Divider(height: K.pvsxH),
      ],
    );
  }

  Color getOperationStatusColor(OperationStatus status) {
    switch (status) {
      case OperationStatus.receiving:
      case OperationStatus.sending:
        return Colors.blue;
      case OperationStatus.success:
        return Colors.green;
      case OperationStatus.error:
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  void updateSettings(zebra.PrinterSettings? newSettings) {
    _settings = newSettings;
    print(_settings?.toMap());

    _tecDarkness.text = '${_settings?.darkness ?? ''}';
    _tecPrintSpeed.text = '${_settings?.printSpeed ?? ''}';
    _tecTearOff.text = '${_settings?.tearOff ?? ''}';
    // printWidthController.text = '${settings?.printWidth ?? ''}';
    // labelLengthController.text = '${settings?.labelLength ?? ''}';
    // labelLengthMaxController.text = '${settings?.labelLengthMax ?? ''}';
    _tecPrintWidth.text = '${dotsToMm(_settings?.printWidth ?? 0)}';
    _tecLabelLength.text = '${dotsToMm(_settings?.labelLength ?? 0)}';
    _tecLabelLengthMax.text =
        '${dotsToMm((_settings?.labelLengthMax ?? 0).toInt())}';
    _tecLabelTop.text = '${_settings?.labelTop ?? ''}';
    _tecLeftPosition.text = '${_settings?.leftPosition ?? ''}';
    _selectedMediaType = _settings?.mediaType;
    _selectedPrintMethod = _settings?.printMethod;
    _selectedZPLMode = _settings?.zplMode;
    _selectedPowerUpAction = _settings?.powerUpAction;
    _selectedHeadCloseAction = _settings?.headCloseAction;
    _selectedPrintMode = _settings?.printMode;
    _selectedReprintMode = _settings?.reprintMode;
    _selectedVirtualDevice = _settings?.virtualDevice;
  }

  void onClick(String id) async {
    print('==============> onClick()');
    print(id);
    try {
      switch (id) {
        case btnDoManualCalibration:
          setState(() {
            _calibrationMessage = 'Starting manual callibration...';
            _calibrationStatus = OperationStatus.sending;
          });
          zsdk
              .doManualCalibrationOverTCPIP(
                address: _tecIpAddress.text,
                port: int.tryParse(_tecPortAddress.text),
              )
              .then(
                (value) {
                  setState(() {
                    _calibrationStatus = OperationStatus.success;
                    _calibrationMessage = '$value';
                  });
                },
                onError: (error, stacktrace) {
                  try {
                    throw error;
                  } on PlatformException catch (e) {
                    zebra.PrinterResponse printerResponse;
                    try {
                      printerResponse = zebra.PrinterResponse.fromMap(
                        e.details,
                      );
                      _calibrationMessage =
                          '${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause} \n'
                          '${printerResponse.settings?.toString()}';
                    } catch (e) {
                      print(e);
                      _calibrationMessage = e.toString();
                    }
                  } on MissingPluginException catch (e) {
                    _calibrationMessage = '${e.message}';
                  } catch (e) {
                    _calibrationMessage = e.toString();
                  }
                  setState(() {
                    _calibrationStatus = OperationStatus.error;
                  });
                },
              );
          break;
        case btnGetPrinterSettings:
          setState(() {
            _settingsMessage = 'Getting printer settings...';
            _settingsStatus = OperationStatus.receiving;
          });
          zsdk
              .getPrinterSettingsOverTCPIP(
                address: _tecIpAddress.text,
                port: int.tryParse(_tecPortAddress.text),
              )
              .then(
                (value) {
                  setState(() {
                    _settingsStatus = OperationStatus.success;
                    _settingsMessage = '$value';
                    updateSettings(
                      (zebra.PrinterResponse.fromMap(value)).settings,
                    );
                  });
                },
                onError: (error, stacktrace) {
                  try {
                    throw error;
                  } on PlatformException catch (e) {
                    zebra.PrinterResponse printerResponse;
                    try {
                      printerResponse = zebra.PrinterResponse.fromMap(
                        e.details,
                      );
                      _settingsMessage =
                          '${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause} \n'
                          '${printerResponse.settings?.toString()}';
                    } catch (e) {
                      print(e);
                      _settingsMessage = e.toString();
                    }
                  } on MissingPluginException catch (e) {
                    _settingsMessage = '${e.message}';
                  } catch (e) {
                    _settingsMessage = e.toString();
                  }
                  setState(() {
                    _settingsStatus = OperationStatus.error;
                  });
                },
              );
          break;
        case btnSetPrinterSettings:
          setState(() {
            _settingsMessage = 'Setting printer settings...';
            _settingsStatus = OperationStatus.sending;
          });
          print(
            'printWidth :${mmToDots(double.tryParse(_tecPrintWidth.text) ?? 0.0)}',
          );
          print(
            'labelLength :${mmToDots(double.tryParse(_tecLabelLength.text) ?? 0.0)}',
          );
          print(
            'labelLengthMax :${dotsToMm(int.tryParse(_tecLabelLengthMax.text) ?? 0)}',
          );

          zsdk
              .setPrinterSettingsOverTCPIP(
                address: _tecIpAddress.text,
                port: int.tryParse(_tecPortAddress.text),
                // TODO: orginal
                settings: zebra.PrinterSettings(
                  darkness: double.tryParse(_tecDarkness.text),
                  printSpeed: double.tryParse(_tecPrintSpeed.text),
                  tearOff: int.tryParse(_tecTearOff.text),
                  mediaType: _selectedMediaType,
                  printMethod: _selectedPrintMethod,
                  // printWidth: int.tryParse(printWidthController.text),
                  // labelLength: int.tryParse(labelLengthController.text),
                  // labelLengthMax: double.tryParse(labelLengthMaxController.text),
                  printWidth: mmToDots(
                    double.tryParse(_tecPrintWidth.text) ?? 0.0,
                  ),
                  labelLength: mmToDots(
                    double.tryParse(_tecLabelLength.text) ?? 0.0,
                  ),
                  labelLengthMax: mmToDots(
                    double.tryParse(_tecLabelLengthMax.text) ?? 0.0,
                  ).toDouble(),
                  zplMode: _selectedZPLMode,
                  powerUpAction: _selectedPowerUpAction,
                  headCloseAction: _selectedHeadCloseAction,
                  labelTop: int.tryParse(_tecLabelTop.text),
                  leftPosition: int.tryParse(_tecLeftPosition.text),
                  printMode: _selectedPrintMode,
                  reprintMode: _selectedReprintMode,
                  virtualDevice: _selectedVirtualDevice,
                ),
                // settings: Printer.PrinterSettings(
                //   darkness: 10, // Mittlere Druckdunkelheit
                //   printSpeed: 6, // Geschwindigkeit 6 Zoll pro Sekunde
                //   tearOff: 0, // Keine Anpassung für Abriss
                //   mediaType: Printer.MediaType.MARK, // Medien mit Markierungen
                //   printMethod:
                //       Printer.PrintMethod.DIRECT_THERMAL, // Direkt-Thermodruck
                //   printWidth: 568, // Breite von 568 Punkten (2,36 Zoll bei 203 dpi)
                //   labelLength: 1202, // Länge des Etiketts (4,8 Zoll bei 203 dpi)
                //   labelLengthMax: 39, // Maximale Länge (abhängig vom Drucker)
                //   zplMode: Printer.ZPLMode.ZPL_II, // Moderne ZPL-Sprache
                //   powerUpAction: Printer
                //       .PowerUpAction.NO_MOTION, // Keine Bewegung beim Einschalten
                //   headCloseAction: Printer.HeadCloseAction
                //       .FEED, // Papierzuführung beim Schließen des Kopfes
                //   labelTop: 0, // Keine vertikale Verschiebung
                //   leftPosition: 0, // Keine horizontale Verschiebung
                //   printMode: Printer.PrintMode.TEAR_OFF, // Standard-Abrissmodus
                //   reprintMode:
                //       Printer.ReprintMode.OFF, // Wiederholungsdruck deaktiviert
                //   virtualDevice:
                //       selectedVirtualDevice, // Benutzerdefiniertes virtuelles Gerät
                // ),
                //            settings: Printer.PrinterSettings(
                //              darkness: 30, //10
                //              printSpeed: 3, //6
                //              tearOff: 100,//0
                //              mediaType: Printer.MediaType.CONTINUOUS, //MARK
                //              printMethod: Printer.PrintMethod.THERMAL_TRANS, //DIRECT_THERMAL
                //              printWidth: 568,//600
                //              labelLength: 1000,//1202
                //              labelLengthMax: 30,//39
                //              zplMode: Printer.ZPLMode.ZPL,//ZPL II
                //              powerUpAction: Printer.PowerUpAction.FEED,//NO MOTION
                //              headCloseAction: Printer.HeadCloseAction.NO_MOTION,//FEED
                //              labelTop: 50,//0
                //              leftPosition: 100,//0
                //              printMode: Printer.PrintMode.CUTTER,//TEAR_OFF
                //              reprintMode: Printer.ReprintMode.ON,//OFF
                //              virtualDevice: selectedVirtualDevice,
                //            )
              )
              .then(
                (value) {
                  setState(() {
                    _settingsStatus = OperationStatus.success;
                    _settingsMessage = '$value';
                    updateSettings(
                      (zebra.PrinterResponse.fromMap(value)).settings,
                    );
                  });
                },
                onError: (error, stacktrace) {
                  try {
                    throw error;
                  } on PlatformException catch (e) {
                    zebra.PrinterResponse printerResponse;
                    try {
                      printerResponse = zebra.PrinterResponse.fromMap(
                        e.details,
                      );
                      _settingsMessage =
                          '${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause} \n'
                          '${printerResponse.settings?.toString()}';
                    } catch (e) {
                      print(e);
                      _settingsMessage = e.toString();
                    }
                  } on MissingPluginException catch (e) {
                    _settingsMessage = '${e.message}';
                  } catch (e) {
                    _settingsMessage = e.toString();
                  }
                  setState(() {
                    _settingsStatus = OperationStatus.error;
                  });
                },
              );
          break;
        case btnResetPrinterSettings:
          setState(() {
            _settingsMessage = 'Setting default settings...';
            _settingsStatus = OperationStatus.sending;
          });
          zsdk
              .setPrinterSettingsOverTCPIP(
                address: _tecIpAddress.text,
                port: int.tryParse(_tecPortAddress.text),
                settings: zebra.PrinterSettings.defaultSettings(),
              )
              .then(
                (value) {
                  setState(() {
                    _settingsStatus = OperationStatus.success;
                    _settingsMessage = '$value';
                    updateSettings(
                      (zebra.PrinterResponse.fromMap(value)).settings,
                    );
                  });
                },
                onError: (error, stacktrace) {
                  try {
                    throw error;
                  } on PlatformException catch (e) {
                    zebra.PrinterResponse printerResponse;
                    try {
                      printerResponse = zebra.PrinterResponse.fromMap(
                        e.details,
                      );
                      _settingsMessage =
                          '${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause} \n'
                          '${printerResponse.settings?.toString()}';
                    } catch (e) {
                      print(e);
                      _settingsMessage = e.toString();
                    }
                  } on MissingPluginException catch (e) {
                    _settingsMessage = '${e.message}';
                  } catch (e) {
                    _settingsMessage = e.toString();
                  }
                  setState(() {
                    _settingsStatus = OperationStatus.error;
                  });
                },
              );
          break;
        case btnCheckPrinterStatus:
          setState(() {
            _statusMessage = 'Checking printer status...';
            _checkingStatus = OperationStatus.receiving;
          });
          zsdk
              .checkPrinterStatusOverTCPIP(
                address: _tecIpAddress.text,
                port: int.tryParse(_tecPortAddress.text),
              )
              .then(
                (value) {
                  setState(() {
                    _checkingStatus = OperationStatus.success;
                    zebra.PrinterResponse? printerResponse;
                    if (value != null) {
                      printerResponse = zebra.PrinterResponse.fromMap(value);
                    }
                    _statusMessage =
                        '${printerResponse != null ? printerResponse.toMap() : value}';
                  });
                },
                onError: (error, stacktrace) {
                  try {
                    throw error;
                  } on PlatformException catch (e) {
                    zebra.PrinterResponse printerResponse;
                    try {
                      printerResponse = zebra.PrinterResponse.fromMap(
                        e.details,
                      );
                      _statusMessage =
                          '${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause}';
                    } catch (e) {
                      print(e);
                      _statusMessage = e.toString();
                    }
                  } on MissingPluginException catch (e) {
                    _statusMessage = '${e.message}';
                  } catch (e) {
                    _statusMessage = e.toString();
                  }
                  setState(() {
                    _checkingStatus = OperationStatus.error;
                  });
                },
              );
          break;
        case btnRebootPrinter:
          setState(() {
            _statusMessage = 'Rebooting printer...';
            _rebootingStatus = OperationStatus.sending;
          });
          zsdk
              .rebootPrinterOverTCPIP(
                address: _tecIpAddress.text,
                port: int.tryParse(_tecPortAddress.text),
              )
              .then(
                (value) {
                  setState(() {
                    _rebootingStatus = OperationStatus.success;
                    zebra.PrinterResponse? printerResponse;
                    if (value != null) {
                      printerResponse = zebra.PrinterResponse.fromMap(value);
                    }
                    _statusMessage =
                        '${printerResponse != null ? printerResponse.toMap() : value}';
                  });
                },
                onError: (error, stacktrace) {
                  try {
                    throw error;
                  } on PlatformException catch (e) {
                    zebra.PrinterResponse printerResponse;
                    try {
                      printerResponse = zebra.PrinterResponse.fromMap(
                        e.details,
                      );
                      _statusMessage =
                          '${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause}';
                    } catch (e) {
                      print(e);
                      _statusMessage = e.toString();
                    }
                  } on MissingPluginException catch (e) {
                    _statusMessage = '${e.message}';
                  } catch (e) {
                    _statusMessage = e.toString();
                  }
                  setState(() {
                    _rebootingStatus = OperationStatus.error;
                  });
                },
              );
          break;
        case btnPrintConfigurationLabel:
          setState(() {
            _message = 'Print job started...';
            _printStatus = OperationStatus.sending;
          });
          zsdk
              .printConfigurationLabelOverTCPIP(
                address: _tecIpAddress.text,
                port: int.tryParse(_tecPortAddress.text),
              )
              .then(
                (value) {
                  setState(() {
                    _printStatus = OperationStatus.success;
                    _message = '$value';
                  });
                },
                onError: (error, stacktrace) {
                  try {
                    throw error;
                  } on PlatformException catch (e) {
                    zebra.PrinterResponse printerResponse;
                    try {
                      printerResponse = zebra.PrinterResponse.fromMap(
                        e.details,
                      );
                      _message =
                          '${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause}';
                    } catch (e) {
                      print(e);
                      _message = e.toString();
                    }
                  } on MissingPluginException catch (e) {
                    _message = '${e.message}';
                  } catch (e) {
                    _message = e.toString();
                  }
                  setState(() {
                    _printStatus = OperationStatus.error;
                  });
                },
              );
          break;
        case btnPrintPdfFileOverTCPIP:
          if (!_tecPath.text.endsWith('.pdf')) {
            throw Exception(
              'Make sure you properly write the path or selected a proper pdf file',
            );
          }
          setState(() {
            _message = 'Print job started...';
            _printStatus = OperationStatus.sending;
          });
          zsdk
              .printPdfFileOverTCPIP(
                filePath: _tecPath.text,
                address: _tecIpAddress.text,
                port: int.tryParse(_tecPortAddress.text),
                printerConf: zebra.PrinterConf(
                  cmWidth: double.tryParse(_tecWidth.text),
                  cmHeight: double.tryParse(_tecHeight.text),
                  dpi: double.tryParse(_tecDpi.text),
                  orientation: _printerOrientation,
                ),
              )
              .then(
                (value) {
                  setState(() {
                    _printStatus = OperationStatus.success;
                    _message = '$value';
                  });
                },
                onError: (error, stacktrace) {
                  try {
                    throw error;
                  } on PlatformException catch (e) {
                    zebra.PrinterResponse printerResponse;
                    try {
                      printerResponse = zebra.PrinterResponse.fromMap(
                        e.details,
                      );
                      _message =
                          '${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause}';
                    } catch (e) {
                      print(e);
                      _message = e.toString();
                    }
                  } on MissingPluginException catch (e) {
                    _message = '${e.message}';
                  } catch (e) {
                    _message = e.toString();
                  }
                  setState(() {
                    _printStatus = OperationStatus.error;
                  });
                },
              );
          break;
        case btnPrintZplFileOverTCPIP:
          if (_filePath == null && !_tecPath.text.endsWith('.zpl')) {
            throw Exception(
              'Make sure you properly write the path or selected a proper zpl file',
            );
          }
          File zplFile = File(_filePath!);
          if (await zplFile.exists()) {
            _zplData = await zplFile.readAsString();
          }
          if (_zplData == null || _zplData!.isEmpty) {
            throw Exception(
              'Make sure you properly write the path or selected a proper zpl file',
            );
          }
          setState(() {
            _message = 'Print job started...';
            _printStatus = OperationStatus.sending;
          });
          zsdk
              .printZplDataOverTCPIP(
                data: _zplData!,
                address: _tecIpAddress.text,
                port: int.tryParse(_tecPortAddress.text),
                printerConf: zebra.PrinterConf(
                  cmWidth: double.tryParse(_tecWidth.text),
                  cmHeight: double.tryParse(_tecHeight.text),
                  dpi: double.tryParse(_tecDpi.text),
                  orientation: _printerOrientation,
                ),
              )
              .then(
                (value) {
                  setState(() {
                    _printStatus = OperationStatus.success;
                    _message = '$value';
                  });
                },
                onError: (error, stacktrace) {
                  try {
                    throw error;
                  } on PlatformException catch (e) {
                    zebra.PrinterResponse printerResponse;
                    try {
                      printerResponse = zebra.PrinterResponse.fromMap(
                        e.details,
                      );
                      _message =
                          '${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause}';
                    } catch (e) {
                      print(e);
                      _message = e.toString();
                    }
                  } on MissingPluginException catch (e) {
                    _message = '${e.message}';
                  } catch (e) {
                    _message = e.toString();
                  }
                  setState(() {
                    _printStatus = OperationStatus.error;
                  });
                },
              );
          break;
        case btnPrintZplDataOverTCPIP:
          _zplData = _tecZplData.text;
          if (_zplData == null || _zplData!.isEmpty) {
            throw Exception('ZPL data can\'t be empty');
          }
          setState(() {
            _message = 'Print job started...';
            _printStatus = OperationStatus.sending;
          });
          zsdk
              .printZplDataOverTCPIP(
                data: _zplData!,
                address: _tecIpAddress.text,
                port: int.tryParse(_tecPortAddress.text),
                printerConf: zebra.PrinterConf(
                  cmWidth: double.tryParse(_tecWidth.text),
                  cmHeight: double.tryParse(_tecHeight.text),
                  dpi: double.tryParse(_tecDpi.text),
                  orientation: _printerOrientation,
                ),
              )
              .then(
                (value) {
                  setState(() {
                    _printStatus = OperationStatus.success;
                    _message = '$value';
                  });
                },
                onError: (error, stacktrace) {
                  try {
                    throw error;
                  } on PlatformException catch (e) {
                    zebra.PrinterResponse printerResponse;
                    try {
                      printerResponse = zebra.PrinterResponse.fromMap(
                        e.details,
                      );
                      _message =
                          '${printerResponse.message} ${printerResponse.errorCode} ${printerResponse.statusInfo.status} ${printerResponse.statusInfo.cause}';
                    } catch (e) {
                      print(e);
                      _message = e.toString();
                    }
                  } on MissingPluginException catch (e) {
                    _message = '${e.message}';
                  } catch (e) {
                    _message = e.toString();
                  }
                  setState(() {
                    _printStatus = OperationStatus.error;
                  });
                },
              );
          break;
      }
    } catch (e) {
      print(e);
      showSnackBar(e.toString());
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  /// Convert millimeters to dots for a given DPI (dots per inch).
  int mmToDots(double mm, {int dpi = 203}) {
    // Calculate dots based on the formula
    return (mm * (dpi / 25.4)).round();
  }

  /// Convert dots to millimeters for a given DPI (dots per inch).
  double dotsToMm(int dots, {int dpi = 203}) {
    // Calculate millimeters based on the formula
    return dots * 25.4 / dpi;
  }
}

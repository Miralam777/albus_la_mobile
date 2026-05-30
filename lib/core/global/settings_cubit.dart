import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/consts.dart';
import '../../configs/services/flutter_service.dart';

@lazySingleton
class SettingsCubit extends Cubit<SettingsModel> {
  final SharedPreferences sp;
  SettingsCubit(this.sp)
      : super(SettingsModel.fromJson(
          sp.getString(K.settingsPrefKey) ?? '{}',
        ));

  void setSettings(SettingsModel settingsModel) {
    emit(settingsModel);
    setBtnNavBarUnderColor();
  }

  void saveSettings() async =>
      await sp.setString(K.settingsPrefKey, state.toJson());

  void setBtnNavBarUnderColor() {
    FlutterService.setSetSystemUIOverlayStyle(state.isThemeDark);
  }
}

class SettingsModel {
  final String uId;
  final String appLocalCode;
  final String logoutTrigger;
  final bool isLoggedIn;
  final bool isThemeDark;
  final bool isWelcompageSeen;
  final String shippingLabelPrinterIp;
  final String productLabelPrinterIp;
  final CompanyModel companyModel;
  final List<String>? viewIds;

  const SettingsModel({
    required this.uId,
    required this.appLocalCode,
    required this.logoutTrigger,
    required this.isLoggedIn,
    required this.isThemeDark,
    required this.isWelcompageSeen,
    required this.shippingLabelPrinterIp,
    required this.productLabelPrinterIp,
    required this.companyModel,
    required this.viewIds,
  });

  factory SettingsModel.fromMap(Map<String, dynamic> data) => SettingsModel(
        uId: data['uId'] ?? '',
        appLocalCode: data['appLocalCode'] ?? 'de',
        logoutTrigger: data['logoutTrigger'] ?? '',
        isLoggedIn: data['isLoggedIn'] ?? false,
        isThemeDark: data['isThemeDark'] ?? false,
        isWelcompageSeen: data['isWelcompageSeen'] ?? false,
        shippingLabelPrinterIp:
            data['shippingLabelPrinterIp'] ?? '192.168.178.00',
        productLabelPrinterIp:
            data['productLabelPrinterIp'] ?? '192.168.178.00',
        companyModel: CompanyModel.fromMap(data['companyModel'] ?? {}),
        viewIds: data['viewIds'] != null
            ? (data['viewIds'] as List).map((e) => e.toString()).toList()
            : [],
      );

  Map<String, dynamic> toMap() => {
        'uId': uId,
        'appLocalCode': appLocalCode,
        'logoutTrigger': logoutTrigger,
        'isLoggedIn': isLoggedIn,
        'isThemeDark': isThemeDark,
        'isWelcompageSeen': isWelcompageSeen,
        'shippingLabelPrinterIp': shippingLabelPrinterIp,
        'productLabelPrinterIp': productLabelPrinterIp,
        'companyModel': companyModel.toMap(),
        'viewIds': viewIds,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [SettingsModel].
  factory SettingsModel.fromJson(String data) =>
      SettingsModel.fromMap(json.decode(data) as Map<String, dynamic>);

  /// `dart:convert`
  ///
  /// Converts [SettingsModel] to a JSON string.
  String toJson() => json.encode(toMap());

  SettingsModel copyWith({
    String? uId,
    String? appLocalCode,
    String? logoutTrigger,
    bool? isLoggedIn,
    bool? isThemeDark,
    bool? isWelcompageSeen,
    String? shippingLabelPrinterIp,
    String? productLabelPrinterIp,
    CompanyModel? companyModel,
    List<String>? viewIds,
  }) =>
      SettingsModel(
        uId: uId ?? this.uId,
        appLocalCode: appLocalCode ?? this.appLocalCode,
        logoutTrigger: logoutTrigger ?? this.logoutTrigger,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        isThemeDark: isThemeDark ?? this.isThemeDark,
        isWelcompageSeen: isWelcompageSeen ?? this.isWelcompageSeen,
        shippingLabelPrinterIp:
            shippingLabelPrinterIp ?? this.shippingLabelPrinterIp,
        productLabelPrinterIp:
            productLabelPrinterIp ?? this.productLabelPrinterIp,
        companyModel: companyModel ?? this.companyModel,
        viewIds: viewIds ?? this.viewIds,
      );
}

class CompanyModel {
  final String name;
  final String street;
  final String houseNr;
  final String postalCode;
  final String city;
  final String additional;
  final String countery;

  const CompanyModel({
    required this.name,
    required this.street,
    required this.houseNr,
    required this.postalCode,
    required this.city,
    required this.additional,
    required this.countery,
  });

  factory CompanyModel.fromMap(Map<String, dynamic> data) => CompanyModel(
        // TODO: init data
        name: data['name'] ?? "Call My Car",
        street: data['street'] ?? 'Firmastraße',
        houseNr: data['houseNr'] ?? '70',
        postalCode: data['postalCode'] ?? '54321',
        city: data['city'] ?? 'Berlin',
        additional: data['additional'] ?? '',
        countery: data['countery'] ?? 'Deutschland',
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'street': street,
        'houseNr': houseNr,
        'postalCode': postalCode,
        'city': city,
        'additional': additional,
        'countery': countery,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [CompanyModel].
  factory CompanyModel.fromJson(String data) {
    return CompanyModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [CompanyModel] to a JSON string.
  String toJson() => json.encode(toMap());

  CompanyModel copyWith({
    String? name,
    String? street,
    String? houseNr,
    String? postalCode,
    String? city,
    String? additional,
    String? countery,
  }) {
    return CompanyModel(
      name: name ?? this.name,
      street: street ?? this.street,
      houseNr: houseNr ?? this.houseNr,
      postalCode: postalCode ?? this.postalCode,
      city: city ?? this.city,
      additional: additional ?? this.additional,
      countery: countery ?? this.countery,
    );
  }
}

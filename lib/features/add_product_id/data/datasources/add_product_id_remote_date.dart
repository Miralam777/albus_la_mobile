import 'dart:convert';

import 'package:albus_la_mobile/configs/network/http_api.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/core/errors/errors_helper.dart';
import 'package:albus_la_mobile/env/env.dart';
import 'package:albus_la_mobile/features/add_product_id/data/models/added_id_model.dart';
import 'package:albus_la_mobile/features/add_product_id/helpers/add_product_id.dart';
import 'package:injectable/injectable.dart';

@factoryMethod
abstract class AddProductIdRemoteDate {
  Future<AddedIdModel> addProductId(AddProductId addId);
}

@Injectable(as: AddProductIdRemoteDate)
class AddProductIdRemoteDateImpl implements AddProductIdRemoteDate {
  final HttpApi client;
  AddProductIdRemoteDateImpl(this.client);

  @override
  Future<AddedIdModel> addProductId(AddProductId addId) async {
    print('=> remote class');
    final url = '${Env.apiUrl}${K.addProductLinkPart}';
    print('url');
    print(url);
    print('=> in put addVehicle');
    print(addId.toJson());
    final res = await client.post(url, addId.toJson());

    print('=> res.body');
    print(res.body);

    if (res.statusCode == 200) {
      // ? Future.value(unit)
      final decodedBody = jsonDecode(res.body);
      print('decodedBody[product]');
      print(decodedBody);
      print(decodedBody['product']);
      return AddedIdModel.fromMap(decodedBody['product']);
    } else {
      return throw ErrorsHelper.errorCodeToException(res.statusCode);
    }
  }

  // TODO: clean
  /*   @override
  Future<Unit> updateQrCode(UpdateQrCode updateQrCode) async {
    final url = '${env.apiUrl}${K.updateQrcodeLinkPart}';

    final res = await client.put(
        url, updateQrCode.copyWith(apiKey: env.apiKey).toJson());

    print('=> res.body');
    print(res.body);

    return res.statusCode == 200
        ? Future.value(unit)
        : throw ErrorsHelper.errorCodeToException(res.statusCode);
  } */

  /*   @override
  Future<Unit> activeQrCode(QrCodeActive qrCodeActive) async {
    final url = '${env.apiUrl}${K.updateActiveLinkPart}';

    final res = await client.put(
        url, qrCodeActive.copyWith(apiKey: env.apiKey).toJson());

    print('=> res.body');
    print(res.body);

    return res.statusCode == 200
        ? Future.value(unit)
        : throw ErrorsHelper.errorCodeToException(res.statusCode);
  } */

  /*   @override
  Future<Unit> removeQrCode(RemoveQrCode removeQrCode) async {
    final url = '${env.apiUrl}${K.removeQrcodeLinkPart}';

    print(removeQrCode.copyWith(apiKey: env.apiKey).toJson());

    final res = await client.delete(
        url, removeQrCode.copyWith(apiKey: env.apiKey).toJson());

    print('=> res.body');
    print(res.body);

    return res.statusCode == 200
        ? Future.value(unit)
        : throw ErrorsHelper.errorCodeToException(res.statusCode);
  } */
}

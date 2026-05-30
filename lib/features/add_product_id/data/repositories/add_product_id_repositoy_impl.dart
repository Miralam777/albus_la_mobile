import 'package:albus_la_mobile/configs/network/network_info.dart';
import 'package:albus_la_mobile/core/errors/errors_helper.dart';
import 'package:albus_la_mobile/core/errors/failures.dart';
import 'package:albus_la_mobile/features/add_product_id/data/datasources/add_product_id_remote_date.dart';
import 'package:albus_la_mobile/features/add_product_id/domain/entities/added_id.dart';
import 'package:albus_la_mobile/features/add_product_id/domain/repositories/add_product_id_repository.dart';
import 'package:albus_la_mobile/features/add_product_id/helpers/add_product_id.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

typedef UnitFunction = Future<Unit> Function();

@Injectable(as: AddProductIdRepository)
class AddProductIdRepositoryImpl implements AddProductIdRepository {
  final NetworkInfo networkInfo;
  final AddProductIdRemoteDate remoteData;
  AddProductIdRepositoryImpl(this.networkInfo, this.remoteData);

  @override
  Future<Either<Failure, AddedId>> addProductId(AddProductId addQrcode) async {
    if (await networkInfo.isConnected) {
      try {
        print('=> _getMessage');
        print('=> try');
        final addedQrcode = await remoteData.addProductId(addQrcode);
        return Right(addedQrcode);
      } catch (error) {
        print('catch');
        print(error);
        return Left(ErrorsHelper.exceptionToFailure(error));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
  // await _getMessage(() => remoteData.addProductQrcode(addQrcode));

  // TODO: clean
  // @override
  // Future<Either<Failure, Unit>> updateQrCode(UpdateQrCode updateQrCode) async =>
  // await _getMessage(() => remoteData.updateQrCode(updateQrCode));

  // @override
  // Future<Either<Failure, Unit>> activeQrCode(QrCodeActive qrCodeActive) async =>
  // await _getMessage(() => remoteData.activeQrCode(qrCodeActive));

  // @override
  // Future<Either<Failure, Unit>> removeQrCode(RemoveQrCode removeQrCode) async =>
  // await _getMessage(() => remoteData.removeQrCode(removeQrCode));

  //! helpers
  Future<Either<Failure, Unit>> _getMessage(UnitFunction unitFunction) async {
    if (await networkInfo.isConnected) {
      try {
        print('=> _getMessage');
        print('=> try');
        await unitFunction();
        return const Right(unit);
      } catch (error) {
        print('catch');
        print(error);
        return Left(ErrorsHelper.exceptionToFailure(error));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

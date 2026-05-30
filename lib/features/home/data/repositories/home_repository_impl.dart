import 'package:albus_la_mobile/configs/network/network.dart';
import 'package:albus_la_mobile/features/home/data/datasources/home_remote_data.dart';
import 'package:albus_la_mobile/features/home/domain/entities/chat.dart';
import 'package:albus_la_mobile/features/home/domain/entities/home_qr_code.dart';
import 'package:albus_la_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

typedef UnitFunction = Future<Unit> Function();

@Injectable(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final NetworkInfo networkInfo;
  final HomeRemoteData remoteData;
  HomeRepositoryImpl(this.networkInfo, this.remoteData);

  @override
  Stream<List<HomeQrCode>> getQrCodes(String uId) => remoteData.getQrCodes(uId);

  @override
  Stream<List<Chat>> getSentChats(String uId) => remoteData.getSentChats(uId);

  @override
  Stream<List<Chat>> getReceivedChats(String uId) =>
      remoteData.getReceivedChats(uId);
}

import 'package:albus_la_mobile/features/home/domain/entities/chat.dart';
import 'package:albus_la_mobile/features/home/domain/entities/home_qr_code.dart';
import 'package:injectable/injectable.dart';

@factoryMethod
abstract class HomeRepository {
  Stream<List<HomeQrCode>> getQrCodes(String uId);
  Stream<List<Chat>> getSentChats(String uId);
  Stream<List<Chat>> getReceivedChats(String uId);
}

import 'package:albus_la_mobile/configs/network/network.dart';
import 'package:albus_la_mobile/features/home/data/models/chat_model.dart';
import 'package:albus_la_mobile/features/home/data/models/home_qr_code_model.dart';
import 'package:albus_la_mobile/features/home/domain/entities/home_qr_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@factoryMethod
abstract class HomeRemoteData {
  Stream<List<HomeQrCode>> getQrCodes(String uId);
  Stream<List<ChatModel>> getSentChats(String uId);
  Stream<List<ChatModel>> getReceivedChats(String uId);
}

@Injectable(as: HomeRemoteData)
class HomeRemoteDataImpl implements HomeRemoteData {
  final HttpApi client;
  HomeRemoteDataImpl(this.client);

  @override
  Stream<List<HomeQrCodeModel>> getQrCodes(String uId) {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    return fireStore
        .collection('qrCodes')
        .where('uId', isEqualTo: uId)
        .snapshots()
        .map((snapShot) {
          final qrCodes = snapShot.docs
              .map((document) => HomeQrCodeModel.fromMap(document.data()))
              .toList();
          qrCodes.sort(
            (a, b) => b.createdAt!.compareTo(a.createdAt ?? Timestamp.now()),
          );
          return qrCodes;
        });
  }

  @override
  Stream<List<ChatModel>> getSentChats(String uId) {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;

    return fireStore
        .collection('chats')
        .where('senderId', isEqualTo: uId)
        .snapshots()
        .map((event) {
          print('??????????????????? sender');
          return event.docs.map((e) => ChatModel.fromMap(e.data())).toList();
        });
  }

  @override
  Stream<List<ChatModel>> getReceivedChats(String uId) {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;

    return fireStore
        .collection('chats')
        .where('receiverId', isEqualTo: uId)
        .snapshots()
        .map((event) {
          print('??????????????????? receiver');
          return event.docs.map((e) => ChatModel.fromMap(e.data())).toList();
        });
  }
}

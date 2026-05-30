import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String? chatId;
  // TODO: timestamp
  final Timestamp createdAt;
  final String? messagesId;
  // TODO:
  // final Reciver reciver;
  // final Sender sender;
  final int? topicId;
  final String? qrName;
  final String? receiverId;
  final String? receiverAvatar;
  // TODO: new
  final String? receiverName;
  // TODO: new
  final bool? receiverSeen;
  final String? senderId;
  final String? senderAvatar;
  final String? senderName;
  // TODO: new change
  final bool? senderSeen;

  const Chat({
    required this.chatId,
    required this.createdAt,
    required this.messagesId,
    required this.topicId,
    required this.qrName,
    required this.receiverId,
    required this.receiverAvatar,
    required this.receiverName,
    required this.receiverSeen,
    required this.senderId,
    required this.senderAvatar,
    required this.senderName,
    required this.senderSeen,
  });

  @override
  List<Object?> get props {
    return [
      chatId,
      createdAt,
      messagesId,
      topicId,
      qrName,
      receiverId,
      receiverAvatar,
      receiverName,
      receiverSeen,
      senderId,
      senderAvatar,
      senderName,
      senderSeen,
    ];
  }
}

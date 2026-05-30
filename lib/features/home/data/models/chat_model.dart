import 'dart:convert';
import 'package:albus_la_mobile/features/home/domain/entities/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel extends Chat {
  const ChatModel({
    required super.chatId,
    required super.createdAt,
    required super.messagesId,
    required super.topicId,
    required super.qrName,
    required super.receiverId,
    required super.receiverAvatar,
    required super.receiverName,
    required super.receiverSeen,
    required super.senderId,
    required super.senderAvatar,
    required super.senderName,
    required super.senderSeen,
  });

  factory ChatModel.fromMap(Map<String, dynamic> data) => ChatModel(
    chatId: data['chatId'] as String?,
    // TODO: timespam
    createdAt: data['createdAt'],
    messagesId: data['messagesId'] as String?,
    // sender: SenderModel.fromMap(data['sender'] as Map<String, dynamic>),
    // ReciverModel.fromMap(data['reciver'] as Map<String, dynamic> ),
    topicId: data['topicId'] as int?,
    qrName: data['qrName'] as String?,
    receiverId: data['receiverId'] as String?,
    receiverAvatar: data['receiverAvatar'] as String?,
    receiverName: data['receiverName'] as String?,
    receiverSeen: data['receiverSeen'] as bool?,
    senderId: data['senderId'] as String?,
    senderAvatar: data['senderAvatar'] as String?,
    senderName: data['senderName'] as String?,
    senderSeen: data['senderSeen'] as bool?,
  );

  Map<String, dynamic> toMap() => {
    'chatId': chatId,
    'createdAt': createdAt,
    'messagesId': messagesId,

    // TODO:
    /*         'reciver': ReciverModel(
          id: reciver.id,
          image: reciver.image,
          name: reciver.name,
        ).toJson(), */
    /* 'sender': SenderModel(
          id: sender.id,
          image: sender.image,
          name: sender.name,
        ).toJson(), */
    'topicId': topicId,
    'qrName': qrName,
    'receiverId': receiverId,
    'receiverAvatar': receiverAvatar,
    'receiverName': receiverName,
    'receiverSeen': receiverSeen,
    'senderName': senderName,
    'senderId': senderId,
    'senderAvatar': senderAvatar,
    'senderSeen': senderSeen,
  };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ChatModel].
  factory ChatModel.fromJson(String data) {
    return ChatModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ChatModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ChatModel copyWith({
    String? chatId,
    Timestamp? createdAt,
    String? messagesId,
    // TODO:
    // ReciverModel? reciver,
    // SenderModel? sender,
    int? topicId,
    String? qrName,
    String? receiverId,
    String? receiverAvatar,
    String? receiverName,
    bool? receiverSeen,
    String? senderId,
    String? senderAvatar,
    String? senderName,
    bool? senderSeen,
  }) {
    return ChatModel(
      chatId: chatId ?? this.chatId,
      createdAt: createdAt ?? this.createdAt,
      messagesId: messagesId ?? this.messagesId,
      // TODO
      // reciver: reciver ?? this.reciver,
      // sender: sender ?? this.sender,
      topicId: topicId ?? this.topicId,
      qrName: qrName ?? this.qrName,
      receiverId: receiverId ?? this.receiverId,
      receiverAvatar: receiverAvatar ?? this.receiverAvatar,
      receiverName: receiverName ?? this.receiverName,
      receiverSeen: receiverSeen ?? this.receiverSeen,
      senderId: senderId ?? this.senderId,
      senderAvatar: senderAvatar ?? this.senderAvatar,
      senderName: senderName ?? this.senderName,
      senderSeen: senderSeen ?? this.senderSeen,
    );
  }
}

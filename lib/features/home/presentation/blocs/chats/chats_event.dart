part of 'chats_bloc.dart';

sealed class ChatsEvent extends Equatable {
  const ChatsEvent();

  @override
  List<Object> get props => [];
}

final class GetChatsEvent extends ChatsEvent {
  final String uId;
  final int limit;
  const GetChatsEvent(this.uId, this.limit);

  @override
  List<Object> get props => [uId, limit];
}

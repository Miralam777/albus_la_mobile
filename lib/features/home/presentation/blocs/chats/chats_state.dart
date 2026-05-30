part of 'chats_bloc.dart';

sealed class ChatsState extends Equatable {
  const ChatsState();

  @override
  List<Object> get props => [];
}

final class ChatsInitial extends ChatsState {}

final class ChatsLoading extends ChatsState {}

final class ChatsLoaded extends ChatsState {
  final List<Chat> chats;
  const ChatsLoaded(this.chats);

  @override
  List<Object> get props => [chats];
}

final class ChatsFailure extends ChatsState {
  final Failure failure;
  const ChatsFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

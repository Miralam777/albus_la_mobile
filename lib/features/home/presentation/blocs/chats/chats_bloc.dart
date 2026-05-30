import 'package:albus_la_mobile/core/errors/errors.dart';
import 'package:albus_la_mobile/features/home/domain/entities/chat.dart';
import 'package:albus_la_mobile/features/home/domain/usecases/chats/received_chats_usecase.dart';
import 'package:albus_la_mobile/features/home/domain/usecases/chats/sent_chats_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'chats_event.dart';
part 'chats_state.dart';

@lazySingleton
class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final SentChatsUsecase sentChatsUsecase;
  final ReceivedChatsUsecase receivedChatsUsecase;
  ChatsBloc(this.sentChatsUsecase, this.receivedChatsUsecase)
    : super(ChatsInitial()) {
    on<ChatsEvent>((event, emit) async {
      if (event is GetChatsEvent) {
        emit(ChatsLoading());
        // TODO: clean
        try {
          print('===================== try');
          await _newGetChats(event.uId);
          print('===================== end');
        } catch (e) {
          // TODO:
          print('chats catch');
          print(e);
          emit(ChatsFailure(ServerFailure()));
        }
      }
    });
  }

  Future<void> _newGetChats(String uId) async {
    List<Chat> chats = [];
    List<Chat> sentChats = [];
    List<Chat> receivedChats = [];

    sentChatsUsecase.call(uId).listen((sentStreamChats) {
      sentChats = sentStreamChats;
      chats = [...sentChats, ...receivedChats];
      chats.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(ChatsLoaded(chats));
    });

    receivedChatsUsecase.call(uId).listen((receivedStreamChats) {
      receivedChats = receivedStreamChats;
      chats = [...sentChats, ...receivedChats];
      chats.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      emit(ChatsLoaded(chats));
    });
  }
}

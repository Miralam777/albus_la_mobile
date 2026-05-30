import 'package:albus_la_mobile/features/home/domain/entities/chat.dart';
import 'package:albus_la_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ReceivedChatsUsecase {
  final HomeRepository repository;
  ReceivedChatsUsecase(this.repository);

  Stream<List<Chat>> call(String uId) => repository.getReceivedChats(uId);
}

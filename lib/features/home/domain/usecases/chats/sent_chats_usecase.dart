import 'package:albus_la_mobile/features/home/domain/entities/chat.dart';
import 'package:albus_la_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class SentChatsUsecase {
  final HomeRepository repository;
  SentChatsUsecase(this.repository);

  Stream<List<Chat>> call(String uId) => repository.getSentChats(uId);
}

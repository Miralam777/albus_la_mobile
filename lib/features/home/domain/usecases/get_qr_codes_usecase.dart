import 'package:albus_la_mobile/features/home/domain/entities/home_qr_code.dart';
import 'package:albus_la_mobile/features/home/domain/repositories/home_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetQrCodesUsecase {
  final HomeRepository repository;
  GetQrCodesUsecase(this.repository);

  Stream<List<HomeQrCode>> call(String uId) => repository.getQrCodes(uId);
}

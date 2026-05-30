import 'package:albus_la_mobile/core/errors/failures.dart';
import 'package:albus_la_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:albus_la_mobile/features/auth/helpers/forget_password.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class ForgetPasswordUsecase {
  final AuthRepository repository;
  ForgetPasswordUsecase(this.repository);

  Future<Either<Failure, Unit>> call(ForgetPassword forgetPassword) async =>
      repository.forgetPassword(forgetPassword);
}

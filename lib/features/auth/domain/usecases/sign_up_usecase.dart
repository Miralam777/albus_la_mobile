import 'package:albus_la_mobile/core/errors/failures.dart';
import 'package:albus_la_mobile/features/auth/helpers/sign_up.dart';
import 'package:albus_la_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignupUsecase {
  final AuthRepository repository;
  SignupUsecase(this.repository);

  Future<Either<Failure, Unit>> call(SignUp signUp) async =>
      repository.signUp(signUp);
}

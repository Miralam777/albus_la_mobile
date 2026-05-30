import 'package:albus_la_mobile/core/errors/failures.dart';
import 'package:albus_la_mobile/features/auth/domain/entities/user.dart';
import 'package:albus_la_mobile/features/auth/helpers/sign_in.dart';

import 'package:albus_la_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignInUsecase {
  final AuthRepository repository;
  SignInUsecase(this.repository);

  Future<Either<Failure, User>> call(SignIn signIn) async =>
      repository.signIn(signIn);
}

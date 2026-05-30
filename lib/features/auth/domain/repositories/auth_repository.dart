import 'package:albus_la_mobile/core/errors/errors.dart';
import 'package:albus_la_mobile/features/auth/domain/entities/user.dart';
import 'package:albus_la_mobile/features/auth/helpers/auth_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@factoryMethod
abstract class AuthRepository {
  Future<Either<Failure, Unit>> signUp(SignUp signUp);
  Future<Either<Failure, User>> signIn(SignIn signIn);
  Future<Either<Failure, Unit>> forgetPassword(ForgetPassword forgetPassword);
}

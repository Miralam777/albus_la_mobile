import 'package:albus_la_mobile/core/errors/errors.dart';
import 'package:albus_la_mobile/configs/network/network.dart';
import 'package:albus_la_mobile/features/auth/data/datasources/auth_local_data.dart';
import 'package:albus_la_mobile/features/auth/data/datasources/auth_remote_data.dart';
import 'package:albus_la_mobile/features/auth/domain/entities/user.dart';
import 'package:albus_la_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:albus_la_mobile/features/auth/helpers/auth_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

typedef SignUpInUserUpdateDelete = Future<Unit> Function();

@Injectable(as: AuthRepository)
class AuthRepositorImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final AuthRemoteData remoteData;
  final AuthLocalData localData;
  AuthRepositorImpl(this.remoteData, this.networkInfo, this.localData);

  @override
  Future<Either<Failure, Unit>> signUp(SignUp signUp) async {
    return await _getMessage(() => remoteData.signup(signUp));
  }

  @override
  Future<Either<Failure, User>> signIn(SignIn signIn) async {
    if (await networkInfo.isConnected) {
      try {
        final user = await remoteData.signIn(signIn);
        await localData.cacheUser(user);
        return Right(user);
      } catch (error) {
        return Left(ErrorsHelper.exceptionToFailure(error));
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> forgetPassword(
    ForgetPassword forgetPassword,
  ) async {
    return await _getMessage(() => remoteData.forgetPassword(forgetPassword));
  }

  // TODO: clean
  Future<Either<Failure, Unit>> _getMessage(
    SignUpInUserUpdateDelete signUpInUserUpdateDelete,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        print('=> try');
        print('=> 200 status');
        await signUpInUserUpdateDelete();
        return const Right(unit);
      } catch (error) {
        print('catch');
        print(error);
        return Left(ErrorsHelper.exceptionToFailure(error));
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

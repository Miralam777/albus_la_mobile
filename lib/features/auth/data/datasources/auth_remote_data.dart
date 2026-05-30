import 'package:albus_la_mobile/env/env.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/core/errors/errors.dart';
import 'package:albus_la_mobile/configs/network/http_api.dart';
import 'package:albus_la_mobile/features/auth/data/models/user_model.dart';
import 'package:albus_la_mobile/features/auth/helpers/auth_helper.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@factoryMethod
abstract class AuthRemoteData {
  Future<Unit> signup(SignUp signUp);
  Future<UserModel> signIn(SignIn signIn);
  Future<Unit> forgetPassword(ForgetPassword forgetPassword);
}

@Injectable(as: AuthRemoteData)
class AuthRemoteDataImpl implements AuthRemoteData {
  final HttpApi client;
  AuthRemoteDataImpl(this.client);

  @override
  Future<Unit> signup(SignUp signUp) async {
    final url = '${Env.apiUrl}${K.signupLinkPart}';

    final res = await client.post(
      url,
      signUp.copyWith(apiKey: Env.apiKey).toJson(),
    );

    // TODO: check the error codes
    print('=> res.body');
    print(res.body);

    return res.statusCode == 200
        ? Future.value(unit)
        : throw ErrorsHelper.errorCodeToException(res.statusCode);

    // TODO: this for test
    /*     final statusCode = 200;
    print('input status code: $statusCode');
    return statusCode == 200
        ? Future.value(unit)
        : throw ErrorsHelper.getException(statusCode); */
  }

  @override
  Future<UserModel> signIn(SignIn signIn) async {
    print('=> signin');
    print(signIn);

    await Future.delayed(const Duration(seconds: 2));
    return UserModel.fromMap({
      'uId': "ENTuzN00ymV4xACheIeWqUy29ux2",
      'uName': 'Miralam',
      // 'createdAt': Timestamp.now().toString(),
      // 'lastLoginAt': Timestamp.now().toString(),
      'email': 'www.miralam777@gmail.com',
      'emailVerified': true,
    });

    // TODO: orginal

    final url = '${Env.apiUrl}${K.signinLinkPart}';

    final res = await client.post(
      url,
      signIn.copyWith(apiKey: Env.apiKey).toJson(),
    );

    // TODO: check the error codes
    print('=> res.body');
    print(res.statusCode);
    print(res.body);

    return res.statusCode == 200
        ? UserModel.fromJson(res.body)
        : throw ErrorsHelper.errorCodeToException(res.statusCode);
  }

  @override
  Future<Unit> forgetPassword(ForgetPassword forgetPassword) async {
    print('=> forgetPassword');
    print(forgetPassword);

    final url = '${Env.apiUrl}${K.forgetPasswordLinkPart}';

    final res = await client.post(
      url,
      forgetPassword.copyWith(apiKey: Env.apiKey).toJson(),
    );

    // TODO: check the error codes
    print('=> res.body');
    print(res.body);

    return res.statusCode == 200
        ? Future.value(unit)
        : throw ErrorsHelper.errorCodeToException(res.statusCode);
  }
}

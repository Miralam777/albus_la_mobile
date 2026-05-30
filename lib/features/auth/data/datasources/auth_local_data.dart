import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@factoryMethod
abstract class AuthLocalData {
  Future<Unit> cacheUser(UserModel userModel);
}

@Injectable(as: AuthLocalData)
class AuthLocalDataImpl implements AuthLocalData {
  final SharedPreferences sharedPerf;
  AuthLocalDataImpl(this.sharedPerf);

  @override
  Future<Unit> cacheUser(UserModel userModel) async {
    print('==================> cacheUser()');
    print('userModel');
    print(userModel);
    await sharedPerf.setString(K.userPrefKey, userModel.toJson());
    return Future.value(unit);
  }
}

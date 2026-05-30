import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

@injectable
class NetworkInfo {
  @factoryMethod
  Future<bool> get isConnected async =>
      // await InternetConnectionChecker().hasConnection;
      await InternetConnectionChecker.instance.hasConnection;
}

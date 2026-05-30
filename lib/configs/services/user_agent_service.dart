import 'package:injectable/injectable.dart';
import 'package:ua_client_hints/ua_client_hints.dart';

@injectable
class UserAgentService {
  static final UserAgentService _instance = UserAgentService._internal();

  factory UserAgentService() => _instance;

  UserAgentService._internal();

  String? _userAgent;

  String? get userAgentForApiHeader => _userAgent;

  Future<void> setUserAgent() async =>
      _userAgent = await _userAgentForApiHeader();

  @factoryMethod
  Future<String?> _userAgentForApiHeader() async {
    try {
      return await userAgent();
    } catch (_) {
      return null;
    }
  }

  @factoryMethod
  Future<String?> appVersion() async {
    // TODO: clean
    try {
      final uaData = await userAgentData();

      print('## User-Agent ##');
      // print('User-Agent: $ua');

      print('## User-Agent Client Hints ##');
      print('platform: ${uaData.platform}');
      print('platformVersion: ${uaData.platformVersion}');
      print('architecture: ${uaData.architecture}');
      print('model: ${uaData.model}');
      print('brand: ${uaData.brand}');
      print('mobile: ${uaData.mobile}');
      print('device: ${uaData.device}');
      print('appName: ${uaData.package.appName}');
      print('appVersion: ${uaData.package.appVersion}');
      print('packageName: ${uaData.package.packageName}');
      print('buildNumber: ${uaData.package.buildNumber}');

      String appVersion = uaData.package.appVersion;

      final version = appVersion.substring(0, appVersion.length - 1);
      final buildNumber = uaData.package.buildNumber;

      print('$version$buildNumber');

      return '$version$buildNumber';
    } catch (_) {
      // print(_);
      return null;
    }
  }

  @factoryMethod
  Future<Map<String, dynamic>> userAgentForFeedback() async {
    try {
      final uaData = await userAgentData();

      final userAgent = {
        'platform': uaData.platform,
        'platformVersion': uaData.platformVersion,
        'architecture': uaData.architecture,
        'model': uaData.model,
        'brand': uaData.brand,
        'mobile': uaData.mobile,
        'device': uaData.device,
        'appName': uaData.package.appName,
        'appVersion': uaData.package.appVersion,
        'packageName': uaData.package.packageName,
        'buildNumber': uaData.package.buildNumber,
      };

      return userAgent;
    } catch (e) {
      return {'erro': e.toString()};
    }
  }
}

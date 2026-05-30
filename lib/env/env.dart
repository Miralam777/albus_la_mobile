import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  //! ==================== Firebase Android ====================
  @EnviedField(varName: 'FIREBASE_ANDROID_API_KEY')
  static const String firebaseAndroidApiKey = _Env.firebaseAndroidApiKey;

  @EnviedField(varName: 'FIREBASE_ANDROID_APP_ID')
  static const String firebaseAndroidAppId = _Env.firebaseAndroidAppId;

  @EnviedField(varName: 'FIREBASE_ANDROID_MESSAGING_SENDER_ID')
  static const String firebaseAndroidMessagingSenderId =
      _Env.firebaseAndroidMessagingSenderId;

  @EnviedField(varName: 'FIREBASE_ANDROID_PROJECT_ID')
  static const String firebaseAndroidProjectId = _Env.firebaseAndroidProjectId;

  @EnviedField(varName: 'FIREBASE_ANDROID_STORAGE_BUCKET')
  static const String firebaseAndroidStorageBucket =
      _Env.firebaseAndroidStorageBucket;

  //! ==================== Firebase iOS ====================
  @EnviedField(varName: 'FIREBASE_IOS_API_KEY')
  static const String firebaseIosApiKey = _Env.firebaseIosApiKey;

  @EnviedField(varName: 'FIREBASE_IOS_APP_ID')
  static const String firebaseIosAppId = _Env.firebaseIosAppId;

  @EnviedField(varName: 'FIREBASE_IOS_MESSAGING_SENDER_ID')
  static const String firebaseIosMessagingSenderId =
      _Env.firebaseIosMessagingSenderId;

  @EnviedField(varName: 'FIREBASE_IOS_PROJECT_ID')
  static const String firebaseIosProjectId = _Env.firebaseIosProjectId;

  @EnviedField(varName: 'FIREBASE_IOS_STORAGE_BUCKET')
  static const String firebaseIosStorageBucket = _Env.firebaseIosStorageBucket;

  @EnviedField(varName: 'FIREBASE_IOS_BUNDLE_ID')
  static const String firebaseIosBundleId = _Env.firebaseIosBundleId;

  //! ==================== Server API ====================

  @EnviedField(varName: 'APP_ID')
  static const String appId = _Env.appId;

  @EnviedField(varName: 'FEEDBACK_BASE_URL')
  static const String feedbackBaseUrl = _Env.feedbackBaseUrl;

  @EnviedField(varName: 'API_URL')
  static const String apiUrl = _Env.apiUrl;

  @EnviedField(varName: 'API_KEY')
  static const String apiKey = _Env.apiKey;
}

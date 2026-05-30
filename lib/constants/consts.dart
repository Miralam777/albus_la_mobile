import 'package:flutter_screenutil/flutter_screenutil.dart';

/// **constants**
class K {
  K._();

// **doubles**
  /// radius small: **'7.0'**
  static const double rs = 7.0;

  /// radius medium: **'12.0'**
  static const double rm = 12.0;

  /// radius large: **'22.0'**
  static const double rl = 22.0;

//! paddings
  /// padding small: **'10.0.w'**
  static final double ps = 10.0.w;

  /// padding medium: **'20.0.w'**
  static final double pm = 20.0.w;

  /// padding large: **'30.0.w'**
  static final double pl = 30.0.w;

  /// padding vertical small x: **'5.0'**
  static const double pvsx = 5.0;

  /// padding vertical small x: **'5.0.h'**
  static final double pvsxH = 5.0.h;

  /// padding vertical small: **'7.5'**
  static const double pvs = 7.5;

  /// padding vertical small: **'7.5.h'**
  static final double pvsH = 7.5.h;

  /// padding vertical medium: **'15.0'**
  static const double pvm = 15.0;

  /// padding vertical medium: **'15.0.h'**
  static final double pvmH = 15.0.h;

  /// padding vertical large: **'20.0'**
  static const double pvl = 20.0;

  /// padding vertical large: **'20.0.h'**
  static final double pvlH = 20.0.h;

  /// padding vertical 2X: **'40.0'**
  static const double pvl2x = 40.0;

  /// padding vertical 2X: **'40.0.h'**
  static final double pvl2xH = 40.0.h;

//! outline with
  /// border with small: **'0.5.r'**
  static final double bs = 0.5.r;

  /// border with mediaum: **'1.0.r'**
  static final double bm = 1.0.r;

  /// border with large: **'2.0.r'**
  static final double bl = 2.0.r;

//! icon
  /// icon small size **'25.0.r'**
  // static final double iss = 25.0.r;

  /// icon big size **'60.0.r'**
  static final double ibs = 60.0.r;

// **ints**
  /// name max length is **'30'**
  static const int nameMaxLength = 30;

// **colors**
  /// yellow primary color **'Color(0xFFE0D101)'**
  // static const Color yellowPrimry = Color(0xFFE0D101);

// **String**
//! env var name**
  /// .env api url var name: **'API_URL'**
  static const String envApiUrlVarName = 'API_URL';

  /// .env api key var name: **'API_KEY'**
  static const String envApiKeyVarName = 'API_KEY';

// TODO: clean
//! push notification types id
  /// push type: **'push'**
  static const String pushType = 'push';

  /// orders push type: **'orders'**
  static const String ordersPushType = 'orders';

  /// news type: **'chat'**
  // static const String chatType = 'chat';

  /// clip type id: **'clip'**
  // static const String clipTypeId = 'clip';

  /// audio type id: **'audio'**
  // static const String audioTypeId = 'audio';

//! payment provider ids
  static const String payProviderPaypal = 'paypal';
  static const String payProviderGoogle = 'google_pay';
  static const String payProviderApple = 'apple_pay';

//! qr code type types
  static const String qrCodePrivateType = 'private';
  static const String qrCodePrimaryType = 'Primary';

//! urls
// TODO: remove this
  /// https://call-my-car-7a910.firebaseapp.com/msg/
  static const String webUrl = 'https://call-my-car-7a910.firebaseapp.com/msg/';

  /// look app base url: **'https://lookapp.me/msg?id='**;
  static const String lookAppMsgBaseUrl = 'https://lookapp.me/msg?id=';

  /// look app base url: **'lookapp.me/msg?id='**;
  static const String lookAppNfcMsgBaseUrl = 'lookapp.me/msg?id=';

//! keys
// TODO
  static const String settingsPrefKey = 'cmc_verwaltung_SETTINGS_PREF_KEY';
  static const String userPrefKey = 'cmc_verwaltung_GLOBAL_USER_PREF_KEY';
  static const String lastViewIndexPrefKey =
      'cmc_verwaltung_LAST_VIEW_INDEX_PREF_KEY';

// TODO: clean unused link parts
  //! auth
  static const String signupLinkPart = 'auth/signup';
  static const String signinLinkPart = 'auth/signin';
  static const String forgetPasswordLinkPart = 'auth/forget-password';
  static const String updateUserLinkPart = 'auth/update-user';
  static const String deleteAccountLinkPart = 'auth/delete-account';
  //! qr code
  // static const String addVehicleLinkPart = 'qrcode/add';
  // static const String updateVehicleLinkPart = 'qrcode/update';
  // static const String updateActiveLinkPart = 'qrcode/active';
  // static const String removeVehicleLinkPart = 'qrcode/remove';
  // static const String existVehicleLinkPart = 'qrcode/exist';
  static const String addProductLinkPart = 'product/addProduct';
  //! chat
  static const String addMessagePart = 'chat/addMessage';
  static const String createChatPart = 'chat/create';
  static const String seenChatPart = 'chat/seenChat';
  static const String seenMessagePart = 'chat/seenMessage';
  //! shopping
  static const String licensePart = 'shopping/license';
  static const String orderPart = 'shopping/order';
}

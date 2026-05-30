class Routes {
  Routes._();

  // TODO: sort
  // TODO: clean all unused pages
  /// extra: Map<String, dynamic>? => {'linkPart': String?, 'title': String?};

  static const String splashPage = '/splashPage';
  static const String signInPage = '/signInPage';
  static const String homePage = '/homePage';

  /// extra: String? => messagesId: String?
  // static const String messagesPage = '/messagesPage';

  static const String rechtlichesPage = '/rechtlichesPage';
  static const String feedbackPage = '/feedbackPage';

  /// extra: String? => email: String?
  static const String forgetPasswordPage = '/forgetPasswordPage';

  /// extra: Product? => product: Product?
  static const String addUpdateProductPage = '/addUpdateProductPage';

  // static const String addUpdateProductPage = '/addUpdateProductPage';

  /// extra: License? => license: License?
  static const String addUpdateLicensePage = '/addUpdateLicensePage';

  /// extra: Product? => product: Product?
  static const String productDetailsPage = '/productDetailsPage';

  /// extra: Map<String, dynamic>? => {'isFromDonePage': bool, 'orders': Orders?};
  static const String ordersDetailsPage = '/ordersDetailsPage';

  static const String doneOrdersPage = '/doneOrdersPage';

  /// extra: Map<String, dynamic>? => {'manufactured': bool, 'genProduct': GenProduct?};
  static const String addProductIdPage = '/addProductIdPage';

  static const String printPdfPage = '/createPdfPage';

  static const String addProductGroupPage = '/addProductGroupPage';

  /// extra: ProductGroupModel? => group: ProductGroupModel?
  static const String productsPage = '/productsPage';

  static const String zebraPinterSettingsPage = '/zebraPinterSettingsPage';

  // ! admin
  static const String adminsPage = '/adminsPage';

  /// extra: Map<String, dynamic>? => {'isFromUser': bool ?? false, 'userInfos': UserInfos?};
  static const String adminManagePage = '/adminManagePage';

  /// extra: UpdateQrCode? => updateQrCode: UpdateQrCode??
  // static const String aurQrCodePage = '/aurQrCodePage';
  // static const String manageAccountPage = '/manageAccountPage';
  // static const String buyLimitPage = '/buyLimitPage';

  /// extra: String? => messagesId: String?
  // static const String messagesPage = '/messagesPage';

  /// extra: String? => qrValue: String?
  // static const String findAndSendMessagePage = '/findAndSendMessagePage';
  // static const String paypalPage = '/paypalPage';

  /// extra: String => tag: String
  // static const String searchPage = '/searchPage';

  /// extra: String? => qrId: String?
  // static const String printQrCodePage = '/printQrCodePage';
  // static const String deleteAccountPage = '/deleteAccountPage';
  // static const String changeNamePage = '/changeNamePage';
  // static const String changePasswordPage = '/changePasswordPage';

  /// extra: Product? => product: Product
  // static const String productDetailsPage = '/productDetailsPage';
}

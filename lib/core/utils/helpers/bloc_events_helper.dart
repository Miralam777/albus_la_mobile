import 'package:albus_la_mobile/features/home/presentation/providers/gen_qrcodes_provider.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/license_provider.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/order_provider.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/product_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../global/settings_cubit.dart';
import '../../global/user_provider.dart';

class BlocEventsHelper {
  BlocEventsHelper._();

  //! settins cubit
  static void setSetting(BuildContext context, SettingsModel settingsModel) {
    context.read<SettingsCubit>().setSettings(settingsModel);
    context.read<SettingsCubit>().saveSettings();
  }

  static SettingsModel getSettings(BuildContext context) =>
      context.read<SettingsCubit>().state;

  static void saveSetting(BuildContext context) =>
      context.read<SettingsCubit>().saveSettings();

  //! user provider
  static UserInfos? getUser(BuildContext context) =>
      context.read<UserProvider>().userInfos;

  //! global admin provider
  static Future<void> initAdminProvider(
    BuildContext context,
    String uId,
  ) async => await context.read<UserProvider>().init(uId);

  static Future<void> logoutAdmin(BuildContext context) async =>
      context.read<UserProvider>().logout();

  static Future<bool> checkBlockAndLogoutTigger({
    required BuildContext context,
    required String uId,
    required String logoutTrigger,
  }) async => await context
      .read<UserProvider>()
      .isBlockedOrLogoutTriggerChanged(uId: uId, logoutTrigger: logoutTrigger);

  static Future<void> initApp(BuildContext context, String uId) async {
    await initAdminProvider(context, uId);
    if (!context.mounted) return;
    await context.read<OrderProvider>().init();
    if (!context.mounted) return;
    await context.read<ProductProvider>().init();
    if (!context.mounted) return;
    await context.read<LicenseProvider>().init();
    if (!context.mounted) return;
    await context.read<GenQrcodesProvider>().init();
    if (!context.mounted) return;
    await context.read<UserProvider>().fetchAdmins();
  }
}

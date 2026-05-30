import 'package:albus_la_mobile/configs/routes/routes.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/global/settings_cubit.dart';
import 'package:albus_la_mobile/core/global/user_provider.dart';
import 'package:albus_la_mobile/core/utils/helpers/bloc_events_helper.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/utils/utility/dialogs_utils.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/core/widgets/switch.dart';
import 'package:albus_la_mobile/features/home/presentation/widgets/home/settings_view/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// TODO: macke ist state less if possoble and clean
class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final isPushActive = userProvider.userInfos?.isPushActive ?? true;

    return Scaffold(
      extendBodyBehindAppBar: true,
      // TODO: text
      appBar: const PrimaryAppBar(title: 'Einstellungen'),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(height: MediaHelper.statusAndAppBarH(context)),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const UserCardWidget(),
                SettingGroup(
                  listTiles: [
                    SettingListTile(
                      icon: I.person,
                      // TODO: text
                      title: 'Konto verwalten',
                      // TODO: text
                      subtitle: 'Verwalte hier dein Konto',
                      isFirst: true,
                      isLast: true,
                      withDivider: false,
                      onTap: () => context.push(
                        Routes.adminManagePage,
                        extra: {
                          'isFromUser': true,
                          'userInfos': userProvider.userInfos,
                        },
                      ),
                      // onTap: () {},
                    ),
                  ],
                ),
                if (userProvider.userInfos?.isAdmin ?? false)
                  SettingGroup(
                    listTiles: [
                      SettingListTile(
                        icon: I.gruop,
                        // TODO: text
                        title: 'Administratoren verwalten',
                        // TODO: text
                        // subtitle: 'Verwalte hier dein Konto',
                        isFirst: true,
                        isLast: true,
                        withDivider: false,
                        onTap: () => context.push(Routes.adminsPage),
                      ),
                    ],
                  ),
                SettingGroup(
                  listTiles: [
                    BlocBuilder<SettingsCubit, SettingsModel>(
                      builder: (context, settings) {
                        return SettingListTile(
                          icon: I.darkMode,
                          // TODO: text
                          title: 'Dark Mode',
                          // TODO: text
                          subtitle: settings.isThemeDark ? 'An' : 'Aus',
                          isFirst: true,
                          withDivider: true,
                          trailing: CustomSwitchWidget(
                            value: settings.isThemeDark,
                            onChanged: (value) => BlocEventsHelper.setSetting(
                              context,
                              settings.copyWith(isThemeDark: value),
                            ),
                          ),
                          onTap: () => BlocEventsHelper.setSetting(
                            context,
                            settings.copyWith(
                              isThemeDark: !settings.isThemeDark,
                            ),
                          ),
                        );
                      },
                    ),
                    SettingListTile(
                      icon: isPushActive
                          ? I.notificationsActive
                          : I.notificationsOff,
                      // ! text
                      title: 'Push-Benachrichtigung',
                      // title: L.of(context).fHomeViewSettingsLtPushNotificationTitle,
                      // ! text
                      subtitle: isPushActive ? 'Aktiv' : 'Inaktiv',
                      // subtitle: L.of(context).fHomeViewSettingsLtPushNotificationSubtitle(settings.isPushActive.toString()),
                      isLast: true,
                      withDivider: false,

                      trailing: CustomSwitchWidget(
                        value: isPushActive,
                        onChanged: (value) => userProvider.updatePush(),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                SettingGroup(
                  listTiles: [
                    SettingListTile(
                      icon: I.printer,
                      // TODO: text
                      title: 'Etikettendrucker',
                      // TODO: text
                      subtitle: 'Nur für Zebra-Drucker',
                      isLast: true,
                      isFirst: true,
                      withDivider: false,
                      onTap: () => context.push(Routes.zebraPinterSettingsPage),
                    ),
                  ],
                ),
                SettingGroup(
                  listTiles: [
                    SettingListTile(
                      icon: I.gavel,
                      // TODO: text
                      title: 'Rechtliches',
                      // TODO: text
                      subtitle: 'Datenschutz, AGB, Impressum',
                      isFirst: true,
                      onTap: () => context.push(Routes.rechtlichesPage),
                    ),
                    SettingListTile(
                      icon: I.feedback,
                      // TODO: text
                      title: 'Feedback senden',
                      // TODO: text
                      subtitle: 'Lass uns wissen',
                      isLast: true,
                      withDivider: false,
                      onTap: () => context.push(Routes.feedbackPage),
                    ),
                  ],
                ),
                K.pvlH.verticalSpace,
                TextButton.icon(
                  icon: Icon(I.logout),
                  //TODO: text
                  label: const Text('Abmelden'),
                  onPressed: () async {
                    await DialogsUtils.showOkCancelDialog(
                      context: context,
                      //TODO: text
                      title: 'Abmelden?',
                      onOk: () async {
                        BlocEventsHelper.setSetting(
                          context,
                          BlocEventsHelper.getSettings(context).copyWith(
                            isLoggedIn: false,
                            uId: '',
                            logoutTrigger: '',
                          ),
                        );
                        await BlocEventsHelper.logoutAdmin(context);
                        if (!context.mounted) return;
                        context.pushReplacement(Routes.signInPage);
                      },
                    );
                  },
                ),
                const AppVersionWidget(),
                SizedBox(
                  height: MediaHelper.androidBtmNavBarH(context) + K.pvmH,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

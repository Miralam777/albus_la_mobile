import 'dart:ui';

import 'package:albus_la_mobile/core/utils/helpers/view_ids_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/features/home/presentation/blocs/selected_view_index_cubit/selected_view_index_cubit.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/product_label_printer_provider.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/shipping_label_printer_provider.dart';
import 'package:albus_la_mobile/configs/services/firebase/messaging_service.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

import 'views/views.dart';

// TODO: clean
class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.viewIds});

  final List<String>? viewIds;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PersistentTabController _viewController;

  final _messagingService = MessagingService();

  bool _isInited = false;

  final List<PersistentTabConfig> _views = [];

  @override
  void initState() {
    _messagingService.init(context);
    _viewController = PersistentTabController();

    // QuickActionsUtils.initQuiActions();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Provider.of<ShippingLabelPrinterProvider>(
        context,
        listen: false,
      ).checkStatus(context: context);
      Provider.of<ProductLabelPrinterProvider>(
        context,
        listen: false,
      ).checkStatus(context: context);

      // QuickActionsUtils.jumpToTab(
      //   context: context,
      //   tabController: _viewController,
      // );

      // TODO
      // context.read<SettingsCubit>().setBtnNavBarUnderColor();
      // _viewController.jumpToTab(context.read<SelectedViewIndexCubit>().state);

      // TODO
      /* if (!BlocEventsHelper.getSettings(context).isWelcompageSeen) {
        context.push(Routes.welcomingPage);
      } */
      // context.push(Routes.welcomingPage);

      FlutterNativeSplash.remove();

      // TODO: there is a bug in ios
      print('=> requestPermission');
      // await FirebaseMessaging.instance.requestPermission();
      // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      // TODO: remove fcm
      // final fcmToken = await getFcm();
      // print('Token: $fcmToken');
    });

    // TODO:
    // setupInteractedMessage();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _views.clear();
    for (var tabId in widget.viewIds ?? [ViewIdsHelper.viewIds[4]]) {
      _views.add(_getViewFromId(tabId));
    }

    if (!_isInited) {
      print('========> didChangeDependencies()');
      // TODO

      /*      final uId = BlocEventsHelper.getGUser(context).uId;
      print('uId: $uId');
      if (uId.isNotEmpty) {
        Provider.of<UserProvider>(context, listen: false)
            .init(BlocEventsHelper.getGUser(context).uId);
      } */
      // context.read<SettingsCubit>().setBtnNavBarUnderColor();
      final lastTabIndex = context.read<SelectedViewIndexCubit>().state;
      if (lastTabIndex < _views.length) {
        _viewController.jumpToTab(lastTabIndex);
      }

      _isInited = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final appBarBgColor =
        Theme.of(context).appBarTheme.backgroundColor ??
        Theme.of(context).scaffoldBackgroundColor.withValues(alpha: 0.8);

    return PopScope(
      // TODO: onPopInvoked
      // onWillPop: _onWillPop,
      // onPopInvoked: (didPop) {},
      child: PersistentTabView(
        controller: _viewController,
        resizeToAvoidBottomInset: false,
        onTabChanged: (int index) =>
            context.read<SelectedViewIndexCubit>().setIndex(index),
        navBarOverlap: NavBarOverlap.full(),
        navBarBuilder: (navBarConfig) => Style1BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: NavBarDecoration(
            color: appBarBgColor,
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            border: Border(
              top: BorderSide(
                color: colorScheme.secondaryContainer,
                width: 0.3.r,
              ),
            ),
          ),
        ),
        tabs: _views,
        /*         tabs: [
          navBarItem(
            // TODO: text
            title: 'Bestellungen',
            icon: I.cubeBox,
            screen: const OrdersView(),
          ),
          navBarItem(
            // TODO: text
            title: 'Lizenzen',
            icon: I.license,
            screen: const LicensesView(),
          ),
          navBarItem(
            // TODO: text
            title: 'Produkt-Qr-Codes',
            icon: I.qrCode,
            screen: const GenQrcodesView(),
          ),
          navBarItem(
            // TODO: text
            title: 'Produkte',
            icon: I.category,
            screen: const ProductsView(),
          ),
          navBarItem(
            // TODO: text
            title: 'Einstellungen',
            icon: I.settings,
            screen: const SettingsView(),
          ),
        ], */
      ),
    );
  }

  PersistentTabConfig navBarItem({
    required String title,
    required IconData icon,
    required Widget screen,
  }) {
    return PersistentTabConfig(
      screen: screen,
      item: ItemConfig(
        title: title,
        icon: Icon(icon),
        // TODO:
        activeForegroundColor: MediaHelper.isBrightnessDark(context)
            ? Colors.white
            : Colors.black,
        activeColorSecondary: Theme.of(
          context,
        ).colorScheme.tertiaryContainer.withValues(alpha: 0.7),

        inactiveForegroundColor: MediaHelper.isBrightnessDark(context)
            ? Colors.white54
            : Colors.black45,
      ),
    );
  }

  PersistentTabConfig primaryNavBarItem({
    required String title,
    required IconData icon,
    required Widget screen,
  }) {
    return PersistentTabConfig(
      screen: screen,
      item: ItemConfig(
        title: title,
        icon: Icon(icon, color: Colors.white),
        activeForegroundColor: Theme.of(context).colorScheme.secondary,
        inactiveForegroundColor: MediaHelper.isBrightnessDark(context)
            ? Colors.white54
            : Colors.black45,
        activeColorSecondary: Colors.red,
        iconSize: 27.0.r,
        // opacity: 0.9,
      ),
    );
  }

  // TODO: remove this thing
  /*   Future<bool> _onWillPop() async {
    if (_viewController.index == 0) {
      showCupertinoModalPopup<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => const OnWillPopDialog(),
      );

      return false;
    } else {
      _viewController.jumpToTab(0);
      return false;
    }
  } */

  PersistentTabConfig _getViewFromId(tabId) {
    switch (tabId) {
      case 'orders':
        return navBarItem(
          // TODO: text
          title: 'Bestellungen',
          icon: I.cubeBox,
          screen: const OrdersView(),
        );
      case 'licenses':
        return navBarItem(
          // TODO: text
          title: 'Lizenzen',
          icon: I.license,
          screen: const LicensesView(),
        );
      /*       case 'genQrcodes':
        return navBarItem(
          // TODO: text
          title: 'Produkt-Qr-Codes',
          icon: I.qrCode,
          screen: const GenQrcodesView(),
        ); */
      // TODO: case in tab
      case 'genQrcodes':
        return navBarItem(
          // TODO: text
          title: 'Produkt-Gruppe',
          icon: I.qrCode,
          screen: const GenGroupsView(),
        );
      case 'products':
        return navBarItem(
          // TODO: text
          title: 'Produkte',
          icon: I.category,
          screen: const ProductsView(),
        );
      case 'settings':
        return navBarItem(
          // TODO: text
          title: 'Einstellungen',
          icon: I.settings,
          screen: const SettingsView(),
        );

      default:
        return navBarItem(
          // TODO: text
          title: 'Einstellungen',
          icon: I.settings,
          screen: const SettingsView(),
        );
    }
  }
}

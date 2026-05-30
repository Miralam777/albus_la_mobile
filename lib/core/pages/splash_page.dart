import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import '../utils/helpers/bloc_events_helper.dart';
import '../widgets/loading_indicator.dart';
import '../global/settings_cubit.dart';
import '../../configs/routes/routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      FlutterNativeSplash.remove();
      final settings = BlocEventsHelper.getSettings(context);
      await Future.delayed(const Duration(milliseconds: 777));
      if (settings.isLoggedIn) {
        if (!mounted) return;
        await BlocEventsHelper.initApp(context, settings.uId);
        if (!mounted) return;
        final isBlocedOrChangedTrigger =
            await BlocEventsHelper.checkBlockAndLogoutTigger(
          context: context,
          uId: settings.uId,
          logoutTrigger: settings.logoutTrigger,
        );
        if (isBlocedOrChangedTrigger) {
          if (!mounted) return;
          BlocEventsHelper.setSetting(
            context,
            settings.copyWith(
              isLoggedIn: false,
              logoutTrigger: '',
              uId: '',
              viewIds: [],
            ),
          );

          await BlocEventsHelper.logoutAdmin(context);

          if (mounted) context.pushReplacement(Routes.signInPage);
        } else {
          if (mounted) {
            context.pushReplacement(Routes.homePage, extra: settings.viewIds);
          }
        }
      } else {
        if (mounted) context.pushReplacement(Routes.signInPage);
      }
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    context.read<SettingsCubit>().setBtnNavBarUnderColor();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LoadingIndicator(),
    );
  }
}

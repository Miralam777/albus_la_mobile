import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../configs/routes/route_generator.dart';
import '../configs/theme/app_themes.dart';
import '../core/global/settings_cubit.dart';
import '../core/global/user_provider.dart';
import '../features/add_product_id/presentation/bloc/add_product_id_bloc.dart';
import '../core/global/nfc_notifier.dart';
import '../features/auth/presentation/blocs/auth/auth_bloc.dart';
import '../features/auth/presentation/blocs/signin/sign_in_bloc.dart';
import '../features/feedback/presentation/blocs/feedback/feedback_bloc.dart';
import '../features/home/presentation/blocs/selected_view_index_cubit/selected_view_index_cubit.dart';
import '../features/home/presentation/providers/gen_qrcodes_provider.dart';
import '../features/home/presentation/providers/license_provider.dart';
import '../features/home/presentation/providers/order_provider.dart';
import '../features/home/presentation/providers/product_label_printer_provider.dart';
import '../features/home/presentation/providers/shipping_label_printer_provider.dart';
import '../features/home/presentation/providers/product_provider.dart';
import '../injection.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // TODO: clean
        //! blocs
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<SignInBloc>()),
        // BlocProvider(create: (_) => getIt<QrCodesBloc>()),
        // BlocProvider(create: (_) => getIt<AurQrCodeBloc>()),
        // BlocProvider(create: (_) => getIt<ExistQrCodeBloc>()),
        // BlocProvider(create: (_) => getIt<ChatsBloc>()),
        // BlocProvider(create: (_) => getIt<MessageBloc>()),
        // BlocProvider(create: (_) => getIt<CreateChatBloc>()),
        // BlocProvider(create: (_) => getIt<MessagesBloc>()),
        // BlocProvider(create: (_) => getIt<SeenBloc>()),
        BlocProvider(create: (_) => getIt<FeedbackBloc>()),
        BlocProvider(create: (_) => getIt<AddProductIdBloc>()),
        // BlocProvider(create: (_) => getIt<LicenseBloc>()),
        // BlocProvider(create: (_) => getIt<ManageAccountBloc>()),
        //! cubits
        // BlocProvider(create: (_) => getIt<GUserCubit>()),
        BlocProvider(create: (_) => getIt<SettingsCubit>()),
        BlocProvider(create: (_) => getIt<SelectedViewIndexCubit>()),
        //! provier
        ChangeNotifierProvider(create: (_) => getIt<UserProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<OrderProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ProductProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<LicenseProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<GenQrcodesProvider>()),
        // ChangeNotifierProvider(create: (_) => getIt<ProductLabelProvider>()),
        ChangeNotifierProvider(
            create: (_) => getIt<ShippingLabelPrinterProvider>()),
        ChangeNotifierProvider(
            create: (_) => getIt<ProductLabelPrinterProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<NfcNotifier>()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(411.4, 820.6),
        minTextAdapt: true,
        splitScreenMode: true,
        fontSizeResolver: (num fontSize, ScreenUtil instance) =>
            FontSizeResolvers.height(fontSize, instance),
        builder: (BuildContext _, Widget? child) {
          return BlocBuilder<SettingsCubit, SettingsModel>(
            builder: (context, settings) {
              return MaterialApp.router(
                // TODO:
                title: 'CMC-Verwaltung',
/*                 onNavigationNotification: (notification) {
                  print('=========> onNavigationNotification');
                  return true;
                }, */
                debugShowCheckedModeBanner: false,
                themeMode:
                    settings.isThemeDark ? ThemeMode.dark : ThemeMode.light,
                theme: AppThemes.lightTheme,
                darkTheme: AppThemes.darkTheme,
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.noScaling,
                      boldText: false,
                      highContrast: false,
                      invertColors: false,
                    ),
                    child: child!,
                  );
                },
                /*
                locale: Locale(settings.appLocalCode),
                supportedLocales: S.supportedLocales,
                localizationsDelegates: S.localizationsDelegates,
                routerConfig: RoutGenerator.router,
                */
                routerConfig: RoutGenerator.router,
              );
            },
          );
        },
      ),
    );
    // TODO: for local
/*     return ScreenUtilInit(
      designSize: const Size(411.4, 820.6),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => getIt<SettingsCubit>()),
          ],
          child: BlocBuilder<SettingsCubit, SettingsModel>(
            builder: (_, settings) {
              return MaterialApp(
                title: 'Berlin Maps',
                debugShowCheckedModeBanner: false,
                theme: settings.isAppThemeDark
                    ? AppThemes.darkTheme
                    : AppThemes.lightTheme,
                home: child,
              );
            },
          ),
        );
      },
      // TODO: locals
      /*
       locale: Locale(settings.appLocalCode),
                supportedLocales: L10n.all,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
       */
      routerConfig: RoutGenerator.router,
    ); */
  }
}

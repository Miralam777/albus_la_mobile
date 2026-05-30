import 'package:albus_la_mobile/app/app.dart';
import 'package:albus_la_mobile/configs/services/flutter_service.dart';
import 'package:albus_la_mobile/configs/services/user_agent_service.dart';
import 'package:albus_la_mobile/core/pages/app_error_page.dart';
import 'package:albus_la_mobile/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'firebase_options.dart';
import 'dart:async';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  FlutterService.setDefaultPreferredOrientations();
  FlutterService.setEnabledSystemUIMode();

  await dotenv.load(fileName: '.env');
  await UserAgentService().setUserAgent();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await configureDependencies();

  await Future.delayed(const Duration(milliseconds: 777));

  ErrorWidget.builder = (FlutterErrorDetails details) =>
      const AppErrorPage(isAppCrached: true);

  runApp(const App());
}

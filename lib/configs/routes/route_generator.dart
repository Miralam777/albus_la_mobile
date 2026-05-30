import 'package:albus_la_mobile/core/global/user_provider.dart';
import 'package:albus_la_mobile/core/pages/splash_page.dart';
import 'package:albus_la_mobile/features/add_product_id/domain/entities/added_id.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/models/product_group_model.dart';
import 'package:albus_la_mobile/features/add_product_id/presentation/pages/add_product_id_page.dart';
import 'package:albus_la_mobile/features/auth/presentation/pages/forget_password_page.dart';
import 'package:albus_la_mobile/features/home/presentation/pages/add_update_license_page.dart';
import 'package:albus_la_mobile/features/home/presentation/pages/orders_details_page.dart';
import 'package:albus_la_mobile/features/home/presentation/pages/product_details_page.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/gen_qrcode/gen_product.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/license/license.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/orders/orders.dart';
import 'package:albus_la_mobile/features/home/presentation/providers/models/product/product.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/pages/app_error_page.dart';

import '../../features/add_product_id/presentation/pages/add_product_group_page.dart';
import '../../features/add_product_id/presentation/pages/print_pdf_page.dart';
import '../../features/add_product_id/presentation/pages/products_page.dart';
import '../../features/admin/presentation/pages/admin_manage_page.dart';
import '../../features/admin/presentation/pages/admins_page.dart';
import '../../features/auth/presentation/pages/sign_in_page.dart';
import '../../features/feedback/presentation/pages/feedback_page.dart';
import '../../features/home/presentation/pages/add_update_product_page.dart';
import '../../features/home/presentation/pages/done_orders_page.dart';
import '../../features/home/presentation/pages/home/home_page.dart';
import '../../features/home/presentation/pages/rechtliches_page.dart';
import '../../features/home/presentation/pages/zebra_printer_settings_page.dart';
import 'routes.dart';

class RoutGenerator {
  RoutGenerator._();

  // TODO: clean
  static GoRouter router = GoRouter(
    // TODO: navigation key
    // navigatorKey: navigatorKey,
    // TODO:
    initialLocation: Routes.splashPage,
    // initialLocation: Routes.signinPage,
    // initialLocation: isSignedin ? Routes.homePage : Routes.signinPage,
    errorBuilder: (context, state) => const AppErrorPage(),
    routes: <RouteBase>[
      /*       GoRoute(
        path: Routes.welcomingPage,
        builder: (_, __) => const WelcomingPage(),
        pageBuilder: (_, __) => _fadeTransitionBuilder(const WelcomingPage()),
      ), */
      GoRoute(path: Routes.splashPage, builder: (_, __) => const SplashPage()),
      GoRoute(path: Routes.signInPage, builder: (_, __) => const SignInPage()),
      GoRoute(
        path: Routes.forgetPasswordPage,
        builder: (_, GoRouterState state) =>
            ForgetPasswordPage(email: state.extra as String?),
      ),
      GoRoute(
        path: Routes.homePage,
        builder: (_, GoRouterState state) =>
            HomePage(viewIds: state.extra as List<String>?),
      ),
      GoRoute(
        path: Routes.rechtlichesPage,
        builder: (_, __) => const RechtlichesPage(),
      ),
      GoRoute(
        path: Routes.feedbackPage,
        builder: (_, __) => const FeedbackPage(),
      ),
      GoRoute(
        path: Routes.addUpdateProductPage,
        builder: (_, GoRouterState state) =>
            AddUpdateProductPage(product: state.extra as Product?),
        pageBuilder: (_, GoRouterState state) {
          return _btmToUpTransition(
            AddUpdateProductPage(product: state.extra as Product?),
          );
        },
      ),
      GoRoute(
        path: Routes.addUpdateLicensePage,
        builder: (_, GoRouterState state) =>
            AddUpdateLicensePage(license: state.extra as License?),
        pageBuilder: (_, GoRouterState state) {
          return _btmToUpTransition(
            AddUpdateLicensePage(license: state.extra as License?),
          );
        },
      ),
      GoRoute(
        path: Routes.productDetailsPage,
        builder: (_, GoRouterState state) =>
            ProductDetailsPage(product: state.extra as Product?),
      ),
      GoRoute(
        path: Routes.ordersDetailsPage,
        builder: (_, GoRouterState state) {
          final map = state.extra as Map<String, dynamic>?;
          return OrdersDetailsPage(
            isFromDonePage: map?['isFromDonePage'] ?? false,
            orders: map?['orders'] as Orders?,
          );
        },
      ),
      GoRoute(
        path: Routes.doneOrdersPage,
        builder: (_, __) => const DoneOrdersPage(),
      ),
      GoRoute(
        path: Routes.addProductIdPage,
        builder: (_, GoRouterState state) {
          final map = state.extra as Map<String, dynamic>?;
          final genProduct = map?['genProduct'] as GenProduct?;
          return AddProductIdPage(
            manufactured: map?['manufactured'] ?? false,
            addedId: genProduct != null
                ? AddedId(
                    createdAt: genProduct.createdAt,
                    creator: genProduct.creator,
                    // dId: genProduct.dId,
                    imageUrl: genProduct.imageUrl,
                    id: genProduct.id,
                    manufactured: genProduct.manufactured,
                    name: genProduct.name,
                    pin: genProduct.pin,
                    productId: genProduct.productId,
                    type: genProduct.type,
                    uId: genProduct.uId,
                  )
                : null,
          );
        },
        pageBuilder: (_, GoRouterState state) {
          final map = state.extra as Map<String, dynamic>?;
          final genProduct = map?['genProduct'] as GenProduct?;
          return _btmToUpTransition(
            AddProductIdPage(
              manufactured: map?['manufactured'] ?? false,
              addedId: genProduct != null
                  ? AddedId(
                      createdAt: genProduct.createdAt,
                      creator: genProduct.creator,
                      // dId: genProduct.dId,
                      imageUrl: genProduct.imageUrl,
                      id: genProduct.id,
                      manufactured: genProduct.manufactured,
                      name: genProduct.name,
                      pin: genProduct.pin,
                      productId: genProduct.productId,
                      type: genProduct.type,
                      uId: genProduct.uId,
                    )
                  : null,
            ),
          );
        },
      ),
      GoRoute(
        path: Routes.printPdfPage,
        builder: (_, GoRouterState state) {
          // final extras = state.extra as Map<String, dynamic>?;
          return PrintPdfPage(
            // group: extras as ProductGroupModel?,
            // genProducts: (extras?['genProduct'] ?? []) as List<GenProduct>,
          );
        },
      ),
      GoRoute(
        path: Routes.addProductGroupPage,
        builder: (_, __) => const AddProductGroupPage(),
        pageBuilder: (_, __) => _btmToUpTransition(const AddProductGroupPage()),
      ),
      GoRoute(
        path: Routes.productsPage,
        builder: (_, GoRouterState state) =>
            ProductsPage(group: state.extra as ProductGroupModel),
      ),
      GoRoute(
        path: Routes.zebraPinterSettingsPage,
        builder: (_, GoRouterState state) => const ZebraPinterSettingsPage(),
      ),
      // ! admin
      GoRoute(path: Routes.adminsPage, builder: (_, __) => const AdminsPage()),
      GoRoute(
        path: Routes.adminManagePage,
        builder: (_, GoRouterState state) {
          final map = state.extra as Map<String, dynamic>?;
          return AdminManagePage(
            isFromUser: map?['isFromUser'] ?? false,
            userInfos: map?['userInfos'] as UserInfos?,
          );
        },
      ),
    ],
  );

  static _btmToUpTransition(Widget page) {
    return CustomTransitionPage(
      child: page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(0.0, 1.0), end: Offset.zero),
          ),
          child: child,
        );
      },
    );
  }

  /*   static CustomTransitionPage _fadeTransitionBuilder<T>(Widget child) {
    return CustomTransitionPage<T>(
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  } */
}

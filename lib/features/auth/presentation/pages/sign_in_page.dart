import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:albus_la_mobile/configs/routes/routes.dart';
import 'package:albus_la_mobile/configs/services/firebase/firebase_auth_service.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/global/user_provider.dart';
import 'package:albus_la_mobile/core/utils/helpers/bloc_events_helper.dart';
import 'package:albus_la_mobile/core/utils/helpers/helpers.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/utils/helpers/view_ids_helper.dart';
import 'package:albus_la_mobile/core/utils/utility/toast_utils.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/core/widgets/pw_text_field.dart';
import 'package:albus_la_mobile/core/widgets/text_field.dart';
import 'package:albus_la_mobile/features/auth/presentation/widgets/auth_main_anim.dart';
import 'package:albus_la_mobile/features/auth/presentation/widgets/widgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _tecEmail, _tecPassword;

  final double _accIconHeightAndWidth = 100.0.h;
  double _accIconTopPadding = K.pvsH;
  bool _animStarted = true;
  bool _animEnded = false;
  bool _checkboxValue = true;

  bool _emailTecError = false;
  bool _passwordTecError = false;

  @override
  void initState() {
    // TODO: remove init data
    // _tecEmail = TextEditingController(text: 'miralammako@gmail.com');
    // _tecPassword = TextEditingController(text: 'miralammako@gmail.com');
    _tecEmail = TextEditingController();
    _tecPassword = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _tecEmail.dispose();
    _tecPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PrimaryAppBar(
        // TODO: text
        title: _animEnded ? 'Anmeldung läuft...' : 'Anmelden',
      ),
      body: AuthMainAnimWidget(
        icon: I.person,
        animEnded: _animEnded,
        accIconHeightAndWidth: _accIconHeightAndWidth,
        accIconTopPadding: _accIconTopPadding,
        onEnd: () => setState(() {
          if (!_animStarted) _animEnded = true;
        }),
        children: [
          TextFieldWidget(
            controller: _tecEmail,
            // TODO: text
            hintText: 'E-Mail-Adresse*',
            // TODO: icon
            suffixIcon: I.email,
            keyType: TextInputType.emailAddress,
            fillColor: colorScheme.secondaryContainer,
            errorText: _emailTecError ? 'Pflichtfeld*' : null,
            onChanged: (val) {
              if (_emailTecError) setState(() => _emailTecError = false);
            },
          ),
          SizedBox(height: K.pvmH),
          PwTextFieldWidget(
            controller: _tecPassword,
            // TODO: text
            hintText: 'Passwort*',
            fillColor: colorScheme.secondaryContainer,
            errorText: _passwordTecError ? 'Pflichtfeld*' : null,
            onChanged: (val) {
              if (_passwordTecError) {
                setState(() => _passwordTecError = false);
              }
            },
          ),
          SizedBox(height: K.pvmH),
          Align(
            alignment: Alignment.centerLeft,
            child: AuthTextBtn(
              // TODO: text
              text: 'Passwort vergessen?',
              onPressed: () => context.push(
                Routes.forgetPasswordPage,
                extra: _tecEmail.text.trim(),
              ),
            ),
          ),
          Row(
            children: [
              Checkbox.adaptive(
                value: _checkboxValue,
                visualDensity: VisualDensity.compact,
                activeColor: Theme.of(context).colorScheme.secondary,
                onChanged: (val) => setState(() => _checkboxValue = val!),
              ),
              Expanded(
                child: Text(
                  // TODO: text
                  'Ich möchte angemeldet bleiben.',
                  overflow: TextOverflow.clip,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          SizedBox(height: K.pvlH * 2),
          AuthElevatedBotton(
            icon: I.login,
            // TODO: text
            title: 'Anmelden',
            onPressed: _signin,
          ),
          // SizedBox(height: K.pvl * 2),
          // TODO: clean
          /*
             Text(
              // TODO: text
              'Sie haben noch kein Nutzerkonto?',
              style: Theme.of(context).textTheme.bodyMedium,
            ), 
            // TODO:
             AuthTextBtn(
              // TODO: text
              text: 'Neu registrieren',
              onPressed: () {
                MediaHelper.closeKeyboard(context);
                // context.push(Routes.signupPage);
              },
            ), */
        ],
      ),
    );
  }

  void _signin() async {
    _onLoading();

    final emailTrimed = _tecEmail.text.trim();
    final passwordTrimed = _tecPassword.text.trim();

    if (emailTrimed.isEmpty) {
      setState(() => _emailTecError = true);
    }

    if (passwordTrimed.isEmpty) {
      setState(() => _passwordTecError = true);
    }

    if (!EmailValidator.validate(emailTrimed)) {
      // TODO: text
      ToastUtils.show(
        msg: 'Bitte geben Sie eine gültige E-Mail-Adresse ein.',
        bgRed: true,
      );
      return;
    }

    await Future.delayed(const Duration(milliseconds: 777));
    try {
      print(emailTrimed);
      print(passwordTrimed);

      UserCredential userCredential =
          await AuthService.signInWithEmailAndPassword(
            email: emailTrimed,
            password: passwordTrimed,
          );

      User? user = userCredential.user;
      print('userCredential.user');
      print(user);

      print(AuthService.getIdToken());

      if (user != null) {
        // Hier krige ich einen Error
        QuerySnapshot<Map<String, dynamic>> userDoc = await _firestore
            .collection('admins')
            .where('email', isEqualTo: emailTrimed)
            .limit(1)
            .get();

        if (userDoc.docs.isEmpty) {
          _showError('UNF');
          return;
        }

        print('userDoc.docs[0]');
        print(userDoc.docs[0].exists);
        print(userDoc.docs[0].data());
        final userData = userDoc.docs[0].data();

        final userInfosModel = UserInfos.fromMap(userData);

        if (userInfosModel.isBlocked ?? true) {
          print('========> user.isBlocked');
          print(userInfosModel.isBlocked);
          _showError('UIB');
          return;
        }

        if (!mounted) return;
        final newLogoutTrigger = Helpers.genRandomString(length: 8);
        print('newLogoutTrigger: $newLogoutTrigger');

        final userProvider = context.read<UserProvider>();
        await userProvider.init(user.uid);

        await userProvider.setFcmAndLogoutTrigger(
          uId: user.uid,
          newLogoutTrigger: newLogoutTrigger,
        );

        final viewIds = (userProvider.userInfos?.viewIds ?? []).isNotEmpty
            ? userProvider.userInfos?.viewIds
            : [ViewIdsHelper.viewIds[4]];
        print('userProvider.userInfos?.viewIds');
        print(viewIds);

        if (!mounted) return;
        BlocEventsHelper.setSetting(
          context,
          BlocEventsHelper.getSettings(context).copyWith(
            isLoggedIn: true,
            uId: user.uid,
            logoutTrigger: newLogoutTrigger,
            viewIds: viewIds,
          ),
        );

        await BlocEventsHelper.initApp(context, user.uid);

        if (!mounted) return;
        context.pushReplacement(Routes.homePage, extra: viewIds);
      } else {
        if (!mounted) return;
        await BlocEventsHelper.logoutAdmin(context);
      }

      ToastUtils.show(
        // TODO: text
        msg: 'Anmeldung erfolgreich.',
      );
    } on FirebaseAuthException catch (e) {
      // Firebase Auth errors
      print('============> FirebaseAuthException:');
      print(e);
      _showError('FAE');
    } on FirebaseException catch (e) {
      // Firestore errors (permission denied, etc.)
      print('============> FirebaseException:');
      print(e.code);
      print(e.message);
      _showError('FE');
    } catch (e) {
      // All other errors
      print('============> General error:');
      print(e);
      _showError('GE');
    }
  }

  void _onLoading() {
    MediaHelper.closeKeyboard(context);

    _accIconTopPadding = _animStarted
        ? MediaHelper.h(context) * 0.5 -
              _accIconHeightAndWidth * 0.5 -
              MediaHelper.appBarH -
              MediaHelper.statusBarH(context)
        : K.pvsH;

    _animStarted = !_animStarted;
    if (_animStarted) _animEnded = false;
    setState(() {});
  }

  void _showError(String errorCode) {
    ToastUtils.show(
      // TODO: text
      msg: 'Email oder Passwort ist falsch ($errorCode).',
      bgRed: true,
    );
    _onLoading();
  }
}

import 'package:albus_la_mobile/configs/services/firebase/messaging_service.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/utils/utility/dialogs_utils.dart';
import 'package:albus_la_mobile/core/utils/utility/toast_utils.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/core/widgets/pw_text_field.dart';
import 'package:albus_la_mobile/core/widgets/text_field.dart';
import 'package:albus_la_mobile/features/auth/helpers/sign_up.dart';
import 'package:albus_la_mobile/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:albus_la_mobile/features/auth/presentation/widgets/auth_main_anim.dart';
import 'package:albus_la_mobile/features/auth/presentation/widgets/widgets.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController _tecUName,
      _tecEmail,
      _tecPassword,
      _tecConfirmPassword;

  final double _accIconHeightAndWidth = 100.0.h;

  double _accIconTopPadding = K.pvsH;
  bool _animStarted = true;
  bool _animEnded = false;

  bool _isFirstNameValid = true;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;

  @override
  void initState() {
    _tecUName = TextEditingController();
    _tecEmail = TextEditingController();
    _tecPassword = TextEditingController();
    _tecConfirmPassword = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _tecUName.dispose();
    _tecEmail.dispose();
    _tecPassword.dispose();
    _tecConfirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PrimaryAppBar(
        // TODO: text
        title: _animEnded ? 'Registrierung läuft...' : 'Registrieren',

        actions: [
          // TODO: remove test widget
          /*           IconButton(
            onPressed: () async {
              // !
              _onLoading();
              await Future.delayed(Duration(seconds: 3));
              _onLoading();
              return;
              // !
            },
            icon: Icon(Icons.animation_outlined),
          ), */
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            _onLoading();
          } else if (state is AuthSuccess) {
            _onLoading();
            context.pop();
            DialogsUtils.showDoneDialog(
              context,
              // TODO: text
              title: 'Erfolgreich registriert',
              // TODO: text
              content:
                  'Vielen Dank für Ihre Registrierung! Sie erhalten in Kürze eine E-Mail mit einem Bestätigungslink. Bitte klicken Sie auf den Link, um Ihre E-Mail-Adresse zu bestätigen. Danach können Sie sich anmelden.',
              svgUnDrawImagePath: Assets.undraws.welcomeCats,
            );
          } else if (state is AuthFailure) {
            _onLoading();
            ToastUtils.show(
              // TODO: failure to text
              msg: state.failure.toString(),
              bgRed: true,
            );
          }
        },
        child: AuthMainAnimWidget(
          // TODO: icon
          icon: I.personAdd,
          animEnded: _animEnded,
          accIconHeightAndWidth: _accIconHeightAndWidth,
          accIconTopPadding: _accIconTopPadding,
          onEnd: () => setState(() {
            if (!_animStarted) _animEnded = true;
          }),
          children: [
            // TODO: text
            _titleWidget('Vor oder Spitzname:*'),
            TextFieldWidget(
              controller: _tecUName,
              // TODO: text
              hintText: 'Name',
              // TODO: text
              errorText: _isFirstNameValid ? null : 'Name ist erforderlich.',
              keyType: TextInputType.name,
              suffixIcon: I.person,
              maxLength: K.nameMaxLength,
              inputFormatters: [
                // TODO: same with change name
                // FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9._ßöÖüÜäÄ]')),
                // FilteringTextInputFormatter.allow(RegExp(r'[ßöÖäÄ]')),
                // TODO: for password
                //  FilteringTextInputFormatter.allow(
                // RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$'),
                // ),
              ],
            ),
            SizedBox(height: K.pvlH),
            // TODO: text
            _titleWidget('E-Mail-Adresse und Passwort:*'),
            TextFieldWidget(
              controller: _tecEmail,
              // TODO: text
              hintText: 'E-Mail-Adresse',
              // TODO: text
              errorText: _tecEmail.text.isEmpty && !_isEmailValid
                  ? 'E-Mail-Addresse ist erforderlich.'
                  : _isEmailValid
                  ? null
                  // TODO: text
                  : 'E-Mail-Adresse ist nicht gültig.',
              keyType: TextInputType.emailAddress,
              suffixIcon: I.email,
              maxLength: 320,
            ),
            SizedBox(height: K.pvmH),
            PwTextFieldWidget(
              controller: _tecPassword,
              // TODO: text
              hintText: 'Passwort',
              errorText: _isPasswordValid
                  ? null
                  // TODO: text
                  : 'Password muss min. 8 Zeichen sein.',
              // TODO: text
              helperText: 'Erlaubte Zeichen: a-zA-Z0-9!@#\$%^&*(),.?":{}|<>',
            ),
            SizedBox(height: K.pvmH),
            PwTextFieldWidget(
              controller: _tecConfirmPassword,
              // TODO: text
              hintText: 'Passwort bestätigen',
              errorText: _isConfirmPasswordValid
                  ? null
                  // TODO: text
                  : 'Passwörter stimmen nicht überein.',
            ),
            SizedBox(height: K.pvlH * 2),
            AuthElevatedBotton(
              icon: I.add,
              // TODO: text
              title: 'Registrieren',
              onPressed: _signup,
            ),

            SizedBox(height: 45.h),
          ],
        ),
      ),
    );
  }

  Column _titleWidget(String title) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 5.0.w),
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        SizedBox(height: K.pvsH * 0.5),
      ],
    );
  }

  void _signup() async {
    // TODO: with trim
    // MediaHelper.closeKeyboard(context);

    if (_tecUName.text.isNotEmpty) {
      _isFirstNameValid = true;
    } else {
      _isFirstNameValid = false;
    }

    if (_tecEmail.text.isNotEmpty &&
        EmailValidator.validate(_tecEmail.text.trim())) {
      _isEmailValid = true;
    } else {
      _isEmailValid = false;
    }

    if (_tecPassword.text.length >= 8) {
      _isPasswordValid = true;
    } else {
      _isPasswordValid = false;
    }

    if (_tecConfirmPassword.text.isNotEmpty &&
        _tecConfirmPassword.text == _tecPassword.text) {
      _isConfirmPasswordValid = true;
    } else {
      _isConfirmPasswordValid = false;
    }

    // TODO:
    // final fcm = await FirebaseApi().getFcm();
    // final fcm = await NotificationApi().getFcm();
    // final fcm = await getFcm();
    final fcm = MessagingService.fcmToken;
    print('=============> fcm');
    print(fcm);
    if (fcm == '') {
      // TODO: show fcm error handel
      print('=======> fcm is null');
    }

    setState(() {});
    if (_isFirstNameValid &&
        _isEmailValid &&
        _isPasswordValid &&
        _isConfirmPasswordValid) {
      print('=============> go');

      final signup = SignUp(
        email: _tecEmail.text.trim(),
        password: _tecPassword.text,
        uName: _tecUName.text.trim(),
        fcm: fcm ?? '',
      );
      print('############# signup');
      print(signup);

      BlocProvider.of<AuthBloc>(context).add(AuthSignupEvent(signup));
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
}

import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/utils/utility/dialogs_utils.dart';
import 'package:albus_la_mobile/core/utils/utility/toast_utils.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:albus_la_mobile/core/widgets/svg_un_draw_image.dart';
import 'package:albus_la_mobile/core/widgets/text_field.dart';
import 'package:albus_la_mobile/features/auth/helpers/auth_helper.dart';
import 'package:albus_la_mobile/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:albus_la_mobile/features/auth/presentation/widgets/auth_main_anim.dart';
import 'package:albus_la_mobile/features/auth/presentation/widgets/widgets.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key, required this.email});
  final String? email;

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late TextEditingController _tecEmail;

  final double _accIconHeightAndWidth = 100.0.h;

  double _accIconTopPadding = K.pvsH;
  bool _animStarted = true;
  bool _animEnded = false;

  bool _emailTecError = false;

  @override
  void initState() {
    _tecEmail = TextEditingController(text: widget.email);
    super.initState();
  }

  @override
  void dispose() {
    _tecEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PrimaryAppBar(
        title:
            // TODO: text
            'Passwort zurücksetzen',
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
              content:
                  'Eine E-Mail zum Zurücksetzen Ihres Passworts wurde an Ihre angegebene Adresse gesendet. Bitte klicken Sie auf den Link in der E-Mail, um Ihr Passwort zurückzusetzen.',
              svgUnDrawImagePath: Assets.undraws.mailSent,
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
          forResetPassword: true,
          icon: I.sync,
          animEnded: _animEnded,
          accIconHeightAndWidth: _accIconHeightAndWidth,
          accIconTopPadding: _accIconTopPadding,
          onEnd: () => setState(() {
            if (!_animStarted) _animEnded = true;
          }),
          children: [
            SvgUnDrawImage(path: Assets.undraws.forgetPassword),
            TextFieldWidget(
              controller: _tecEmail,
              // TODO: text
              hintText: 'E-Mail-Adresse',
              // TODO: text
              errorText: _emailTecError ? 'Pflichtfeld*' : null,
              keyType: TextInputType.emailAddress,
              fillColor: Theme.of(context).colorScheme.secondaryContainer,
              suffixIcon: I.email,
              maxLength: 320,
            ),
            SizedBox(height: K.pvlH * 2),
            AuthElevatedBotton(
              icon: I.sync,
              // TODO: text
              title: 'Passwort zurücksetzen',
              onPressed: () {
                final emailTrimed = _tecEmail.text.trim();

                if (emailTrimed.isEmpty) {
                  setState(() => _emailTecError = true);
                }

                if (!EmailValidator.validate(emailTrimed)) {
                  ToastUtils.show(
                    // TODO: text
                    msg: 'Bitte geben Sie eine gültige E-Mail-Adresse ein.',
                    bgRed: true,
                  );
                  return;
                }

                BlocProvider.of<AuthBloc>(context).add(
                  AuthForgetPasswordEvent(ForgetPassword(email: emailTrimed)),
                );
              },
            ),
          ],
        ),
      ),
    );
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

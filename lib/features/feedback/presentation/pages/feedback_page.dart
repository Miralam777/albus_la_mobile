import 'dart:ui';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/errors/errors.dart';
import '../../../../core/utils/helpers/media_helper.dart';
import '../../../../core/utils/utility/toast_utils.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../../core/widgets/main_scaffold.dart';
import '../../../../core/widgets/text_field.dart';
import '../../../../gen/assets.gen.dart';
import '../../domain/entities/app_feedback.dart';
import '../blocs/feedback/feedback_bloc.dart';
import '../widgets/widgets.dart';

// TODO: clean
class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  // TODO: text
  static const List<String> _dropdownsItems = [
    'Fehler gefunden',
    'Rückmeldung zur App',
    'Wünsche in der App',
    'Sonstiges',
  ];

  late TextEditingController _tecEmail, _tecMessage;
  late String _dropdownVal;

  bool _isFeedbackPosting = false;
  bool _hasMssageTxtFError = false;

  @override
  void initState() {
    _dropdownVal = _dropdownsItems.first;
    _dropdownVal = _dropdownsItems.first;
    _tecEmail = TextEditingController();
    _tecMessage = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _tecMessage.dispose();
    _tecEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MainScaffoldWidget(
          svgImage: Assets.undraws.thingsToSay,
          // TODO: text
          appBarTitle: 'Feedback senden',
          appBarTrailingIcon: I.feedback,
          childern: [
            BlocListener<FeedbackBloc, FeedbackState>(
              listener: (context, state) {
                if (state is FeedbackPosting) {
                  setState(() => _isFeedbackPosting = true);
                } else if (state is FeedbackPosted) {
                  setState(() {
                    _isFeedbackPosting = false;
                    _dropdownVal = _dropdownsItems.first;
                    _tecEmail.clear();
                    _tecMessage.clear();
                  });
                  ToastUtils.show(
                    // TODO: text
                    msg: 'Erfolgreich gesendet',
                  );
                } else if (state is FeedbackFailure) {
                  setState(() => _isFeedbackPosting = false);
                  if (state.failure is OfflineFailure) {
                    ToastUtils.show(
                      // TODO: text
                      msg: 'Offline, Ihr Feedback kann nicht gesendet werden.',
                      bgRed: true,
                    );
                  } else {
                    ToastUtils.show(
                      // TODO: text
                      msg: 'Ihr Feedback konnte nicht gesendet werden.',
                      bgRed: true,
                    );
                  }
                }
              },
              child: Column(
                // mainAxisSize: MainAxisSize.max,
                // mainAxisAlignment: MainAxisAlignment.,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const TopImageWidget(),
                  const TitleWidget(
                    // TODO: text
                    text: 'Thema:*',
                    toPadding: 0.0,
                  ),
                  DropdownBtnWidget(
                    dropdownVal: _dropdownVal,
                    dropdownsItems: _dropdownsItems,
                    onDropdownchange: _onDropdownchange,
                  ),
                  TitleWidget(
                    // TODO: text
                    text: 'E-Mail-Addresse:',
                  ),
                  TextFieldWidget(
                    controller: _tecEmail,
                    // TODO: text
                    hintText: 'E-Mail-Addresse:',
                  ),
                  // !
                  /*                     FeedbackTextFieldWidget(
                        tecController: _tecEmail,
                        isKeyboardTypeEmail: true,
                        // TODO: text
                        title: 'E-Mail-Addresse:',
                        // TODO: text
                        hintText: 'someone@example.com',
                        // TODO: text
                        label: 'E-Mail-Addresse',
                      ), */
                  TitleWidget(
                    // TODO: text
                    text: 'Nachricht:*',
                  ),
                  TextFieldWidget(
                    controller: _tecMessage,
                    maxLines: 10,
                    // TODO: text
                    hintText: 'Nachricht...',
                    // TODO: text
                    errorText: _hasMssageTxtFError
                        ? 'Bitte schreiben Sie etwas in das Textfeld.'
                        : null,
                  ),
                  // !
                  /*                   FeedbackTextFieldWidget(
                        tecController: _tecMessage,
                        maxLines: 10,
                        // TODO: text
                        title: 'Nachricht:*',
                        // TODO: text
                        hintText: 'Schreibe deine Nachricht...',
                        // TODO: text
                        label: 'Nachricht',
                        // TODO: text
                        errorText: _hasMssageTxtFError
                            ? 'Bitte schreiben Sie etwas in das Textfeld.'
                            : null,
                        onChanged: (String val) {
                          if (val.isNotEmpty) {
                            setState(() => _hasMssageTxtFError = false);
                          } else {
                            setState(() => _hasMssageTxtFError = true);
                          }
                        },
                      ), */
                  SizedBox(height: 25.0.h),
                  SendBtnWidget(onPressed: _onSendBtn),
                  // TODO: botton
                  SizedBox(height: MediaHelper.viewListBtmPadding),
                ],
              ),
            ),
          ],
        ),
        Visibility(
          visible: _isFeedbackPosting,
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                height: MediaHelper.h(context),
                width: MediaHelper.w(context),
                color: Colors.black.withValues(alpha: 0.1),
                child: const LoadingIndicator(withBackgound: false),
              ),
            ),
          ),
        ),
      ],
    );

    // TODO: clean
    // TODO: orginal
    /*     return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        //TODO: TEXT
        title: const Text('Feedback'),
      ),
      body: BlocListener<FeedbackBloc, FeedbackState>(
        listener: (context, state) {
          if (state is FeedbackPosting) {
            setState(() => _isFeedbackPosting = true);
          } else if (state is FeedbackPosted) {
            setState(() {
              _isFeedbackPosting = false;
              _dropdownVal = _dropdownsItems.first;
              _tecEmail.clear();
              _tecMessage.clear();
            });
            MessagesHepler.successSnackBar(
              context,
              // TODO: text
              message: 'Ihr Feedback wurde erfolgreich gesendet.',
            );
          } else if (state is FeedbackFailure) {
            setState(() => _isFeedbackPosting = false);
            if (state.failure is OfflineFailure) {
              MessagesHepler.errorSnackBar(
                context,
                // TODO: text
                message:
                    'Sie sind offline, Ihr Feedback kann nicht gesendet werden.',
              );
            } else {
              MessagesHepler.errorSnackBar(
                context,
                // TODO: text
                message: 'Ihr Feedback konnte nicht gesendet werden.',
              );
            }
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 15.0.w),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const TopImageWidget(),
                  DropdownBtnWidget(
                    dropdownVal: _dropdownVal,
                    dropdownsItems: _dropdownsItems,
                    onDropdownchange: _onDropdownchange,
                  ),
                  FeedbackTextFieldWidget(
                    tecController: _tecEmail,
                    isKeyboardTypeEmail: true,
                    // TODO: text
                    title: 'E-Mail-Addresse:',
                    // TODO: text
                    hintText: 'someone@example.com',
                    // TODO: text
                    label: 'E-Mail-Addresse',
                  ),
                  FeedbackTextFieldWidget(
                    tecController: _tecMessage,
                    maxLines: 10,
                    // TODO: text
                    title: 'Nachricht:*',
                    // TODO: text
                    hintText: 'Schreibe deine Nachricht...',
                    // TODO: text
                    label: 'Nachricht',
                    // TODO: text
                    errorText: _hasMssageTxtFError
                        ? 'Bitte schreiben Sie etwas in das Textfeld.'
                        : null,
                    onChanged: (String val) {
                      if (val.isNotEmpty) {
                        setState(() => _hasMssageTxtFError = false);
                      } else {
                        setState(() => _hasMssageTxtFError = true);
                      }
                    },
                  ),
                  SendBtnWidget(onPressed: _onSendBtn),
                  SizedBox(height: 300.h),
                ],
              ),
            ),
            Visibility(
              visible: _isFeedbackPosting,
              child: ClipRRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child: Container(
                    height: MediaHelper.h(context),
                    width: MediaHelper.w(context),
                    color: Colors.black.withValue(alpha:0.1),
                    // TODO: costum loading indecator
                    child: const CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ); */
  }

  void _onDropdownchange(String? val) => setState(() => _dropdownVal = val!);

  void _onSendBtn() {
    // TODO:
    MediaHelper.closeKeyboard(context);
    if (_tecMessage.text.isEmpty) {
      setState(() => _hasMssageTxtFError = true);
      ToastUtils.show(
        // TODO: text
        msg: 'Bitte schreiben Sie etwas in das Textfeld.',
        bgRed: true,
      );
    } else {
      final feedback = AppFeedback(
        email: _tecEmail.text.trim(),
        subject: _dropdownVal,
        feedback: _tecMessage.text.trim(),
      );

      BlocProvider.of<FeedbackBloc>(context).add(PostFeedbackEvent(feedback));
    }
  }
}

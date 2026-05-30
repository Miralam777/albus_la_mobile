import 'dart:ui';

import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/constants/icons.dart';
import 'package:albus_la_mobile/core/global/user_provider.dart';
import 'package:albus_la_mobile/core/utils/helpers/helpers.dart';
import 'package:albus_la_mobile/core/utils/helpers/media_helper.dart';
import 'package:albus_la_mobile/core/utils/utility/dialogs_utils.dart';
import 'package:albus_la_mobile/core/widgets/firebase_image_widget.dart';
import 'package:albus_la_mobile/core/widgets/switch.dart';
import 'package:albus_la_mobile/core/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../widgets/admin_manage_page/widgets.dart';
import '../widgets/widgets.dart';

class AdminManagePage extends StatefulWidget {
  const AdminManagePage({
    super.key,
    required this.userInfos,
    required this.isFromUser,
  });

  final bool isFromUser;
  final UserInfos? userInfos;

  @override
  State<AdminManagePage> createState() => _AdminMangePageTodoState();
}

class _AdminMangePageTodoState extends State<AdminManagePage> {
  late TextEditingController _tecTelNr, _tecRole, _tecLocation;

  UserInfos? _userInfos;
  late bool _isBlocked;

  @override
  void initState() {
    _userInfos = widget.userInfos;
    _isBlocked = _userInfos?.isBlocked ?? true;

    _tecTelNr = TextEditingController(text: _userInfos?.telNr);
    _tecRole = TextEditingController(text: _userInfos?.role);
    _tecLocation = TextEditingController(text: _userInfos?.location);

    super.initState();
  }

  @override
  void dispose() {
    _tecTelNr.dispose();
    _tecRole.dispose();
    _tecLocation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(
          context,
        ).appBarTheme.backgroundColor?.withValues(alpha: 0.01),
        notificationPredicate: (_) => false,
      ),
      body: Stack(
        children: [
          // ! ********************* content container
          Container(
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.fromLTRB(
              K.pm,
              K.pvmH + (100.0.h * 0.5) + MediaHelper.statusAndAppBarH(context),
              K.pm,
              0,
            ),
            decoration: BoxDecoration(
              color: colorScheme.tertiaryContainer,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(K.rl),
              ),
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaHelper.androidBtmNavBarH(context) + K.pvmH,
              ),
              child: Column(
                children: [
                  K.pvl.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: K.pm),
                    child: Column(
                      children: [
                        (K.pvm + (100.0 * 0.5)).verticalSpace,
                        Text(
                          '${_userInfos?.firstname} ${_userInfos?.surname}',
                          maxLines: 2,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        /* 
                        K.pvs.verticalSpace,
                        Text(
                          '${_userInfos?.email}',
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ), */
                        K.pvm.verticalSpace,
                        const Divider(),
                        AdminTitleAndTextWidget(
                          // TODO: text
                          title: 'Email: ',
                          text: _userInfos?.email,
                        ),
                        const Divider(),
                        AdminTitleAndTextWidget(
                          // TODO: text
                          title: 'Tel. Nr: ',
                          text: _userInfos?.telNr,
                        ),
                        const Divider(),
                        AdminTitleAndTextWidget(
                          // TODO: text
                          title: 'Rolle: ',
                          text: _userInfos?.role,
                        ),
                        const Divider(),
                        AdminTitleAndTextWidget(
                          // TODO: text
                          title: 'Standort: ',
                          text: _userInfos?.location,
                        ),
                        const Divider(),
                        AdminTitleAndTextWidget(
                          // TODO: text
                          title: 'Status: ',
                          // TODO: text
                          text: _isBlocked ? 'Gesperrt' : 'Aktiv',
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  K.pvl.verticalSpace,

                  if (!widget.isFromUser)
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: K.pm),
                          child: Column(
                            children: [
                              // ! ********************* text fields
                              _ignorPointerAndOpacity(
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: K.ps,
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: colorScheme.tertiaryContainer,
                                    borderRadius: BorderRadius.circular(K.rm),
                                    border: Border.all(
                                      color: colorScheme.outline,
                                      width: K.bm,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          // TODO: text
                                          'Sperren?',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleMedium,
                                        ),
                                      ),
                                      CustomSwitchWidget(
                                        value: _isBlocked,
                                        onChanged: (val) {
                                          MediaHelper.closeKeyboard(context);
                                          setState(() => _isBlocked = val);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              K.pvl.verticalSpace,

                              // ! ********************* text fields
                              TextFieldWidget(
                                controller: _tecTelNr,
                                fillColor: colorScheme.secondaryContainer,
                                // TODO: text
                                hintText: 'Telefonnummer',
                                onChanged: (text) => setState(
                                  () => _userInfos = _userInfos?.copyWith(
                                    telNr: text,
                                  ),
                                ),
                              ),
                              K.pvl.verticalSpace,
                              TextFieldWidget(
                                controller: _tecRole,
                                fillColor: colorScheme.secondaryContainer,
                                // TODO: text
                                hintText: 'Rolle',
                                onChanged: (text) => setState(
                                  () => _userInfos = _userInfos?.copyWith(
                                    role: text,
                                  ),
                                ),
                              ),
                              K.pvl.verticalSpace,
                              TextFieldWidget(
                                controller: _tecLocation,
                                fillColor: colorScheme.secondaryContainer,
                                // TODO: text
                                hintText: 'Standort',
                                onChanged: (text) => setState(
                                  () => _userInfos = _userInfos?.copyWith(
                                    location: text,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        K.pvl.verticalSpace,

                        // ! ********************* choose views
                        ChooseViewsWidget(
                          viewIds: _userInfos?.viewIds ?? [],
                          selectedCatsVoidCallback: (viewIds) => setState(
                            () => _userInfos = _userInfos?.copyWith(
                              viewIds: viewIds,
                            ),
                          ),
                        ),
                        K.pvl2x.verticalSpace,

                        // ! ********************* save btn
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: K.pm),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: Icon(I.save),
                              // TODO: text
                              label: const Text('Speichern'),
                              onPressed: () async {
                                await DialogsUtils.showOkCancelDialog(
                                  // TODO: text
                                  title: 'Änderungen speichern?',
                                  showLoadingIndacator: true,
                                  context: context,
                                  onOk: () async {
                                    await userProvider.updateAdmins(
                                      _userInfos?.copyWith(
                                        isBlocked: _isBlocked,
                                        logoutTrigger: Helpers.genRandomString(
                                          length: 8,
                                        ),
                                      ),
                                    );
                                    if (context.mounted) context.pop();
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        // ! ************************
                      ],
                    ),
                  // ! ************************
                ],
              ),
            ),
          ),

          // ! ********************* user avatar background
          SlideAnimationBuilder(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: 120.0.h + MediaHelper.statusAndAppBarH(context),
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Color.lerp(
                    colorScheme.tertiaryContainer,
                    colorScheme.primary,
                    0.5,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(100.0.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10.0.r,
                      color: _isBlocked
                          ? colorScheme.errorContainer
                          : colorScheme.shadow,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    SizedBox.expand(
                      child: FirebaseImageWidget(
                        image: widget.userInfos?.avatar,
                        errorWidget: const SizedBox.shrink(),
                        showLoadingIndicator: false,
                        fit: BoxFit.cover,
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: const SizedBox.expand(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ! ********************* user avatar
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: K.pvmH + MediaHelper.statusAndAppBarH(context),
              ),
              child: AvatarHero(
                heroTag: widget.userInfos?.uId ?? '',
                avatar: widget.userInfos?.avatar,
                height: 120.0.h,
                redShadow: _isBlocked,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _ignorPointerAndOpacity(Widget child) {
    return IgnorePointer(
      ignoring: (_userInfos?.isAdmin ?? false),
      child: Opacity(
        opacity: (_userInfos?.isAdmin ?? false) ? 0.5 : 1.0,
        child: child,
      ),
    );
  }
}

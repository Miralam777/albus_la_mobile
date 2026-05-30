import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/core/global/settings_cubit.dart';
import 'package:albus_la_mobile/core/global/user_provider.dart';
import 'package:albus_la_mobile/core/utils/helpers/platform_helper.dart';
import 'package:albus_la_mobile/core/widgets/firebase_image_widget.dart';
import 'package:albus_la_mobile/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class UserCardWidget extends StatelessWidget {
  const UserCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isIos = PlatformHelper.isIos();
    // final FirebaseFirestore fireStore = FirebaseFirestore.instance;

    final userInfo = Provider.of<UserProvider>(context).userInfos;

    return Container(
      height: 130.0.h,
      margin: EdgeInsets.symmetric(
        horizontal: isIos ? K.pm : 0.0,
        vertical: K.pm,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: isIos ? BorderRadius.circular(K.rl + 5) : null,
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.topCenter,
          colors: [
            colorScheme.primary.withValues(alpha: 0.7),
            colorScheme.primary.withValues(alpha: 0.2),
            colorScheme.primary.withValues(alpha: 0.4),
          ],
        ),
      ),
      child: BlocBuilder<SettingsCubit, SettingsModel>(
        builder: (context, settings) {
          // final uId = BlocEventsHelper.getGUser(context).uId;
          final isSignedin = settings.isLoggedIn;
          return Row(
            children: [
              Container(
                width: 100.h,
                margin: EdgeInsets.only(left: K.pm),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(blurRadius: 10.0.r, color: colorScheme.secondary),
                  ],
                ),
                // TODO: user avatar
                child: isSignedin
                    /*                     ? SizedBox(
                        height: double.infinity,
                        child: Icon(
                          I.person,
                          size: 60.0.r,
                        ),
                      ) */
                    // TODO:
                    ? FirebaseImageWidget(image: userInfo?.avatar)
                    :
                      // TODO:
                      Image.asset(
                        Assets.icons.app.launchIcon.path,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0.w, right: 3.0.w),
                  child: settings.isLoggedIn
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              // TODO: text
                              'Hallo,',
                              maxLines: 2,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              // TODO: text
                              '${userInfo?.firstname} ${userInfo?.surname}',
                              // 'Max Mustermann dfsad fdfdsf d',
                              maxLines: 2,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            // TODO: this Stream as user provider
                            /*                             StreamBuilder(
                                stream: fireStore
                                    .collection('users')
                                    .doc(uId)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  print('====================> asfasdfsadfsad');
                                  print('====================> sfasdfsadfsad');
                                  print('====================> fasdfsadfsad');
                                  if (snapshot.hasData) {
                                    var uName =
                                        snapshot.data!.get('uName') ?? '';
                                    return Text(
                                      // TODO: text
                                      uName,
                                      // 'Max Mustermann dfsad fdfdsf d',
                                      maxLines: 2,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    );
                                  } else if (snapshot.hasError) {
                                    // TODO: error widget
                                    // return Center(child: Text('error'));
                                    return const SizedBox.shrink();
                                  } else {
                                    // TODO: test ui and select the widget
                                    // return const LoadingIndicator();
                                    return const SizedBox.shrink();
                                  }
                                }), */
                          ],
                        )
                      : Text(
                          // TODO: text
                          'Call my car',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(fontSize: 30.0.sp),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

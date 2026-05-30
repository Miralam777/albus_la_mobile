import 'package:albus_la_mobile/configs/routes/routes.dart';
import 'package:albus_la_mobile/constants/consts.dart';
import 'package:albus_la_mobile/core/global/user_provider.dart';
import 'package:albus_la_mobile/core/utils/helpers/platform_helper.dart';
import 'package:albus_la_mobile/core/widgets/empty_list_widget.dart';
import 'package:albus_la_mobile/core/widgets/primary_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';

class AdminsPage extends StatefulWidget {
  const AdminsPage({super.key});

  @override
  State<AdminsPage> createState() => _AdminManagePageState();
}

class _AdminManagePageState extends State<AdminsPage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: const PrimaryAppBar(
        // TODO: text
        title: 'Administratoren',
      ),
      body: (userProvider.getAdmins ?? []).isEmpty
          ? const EmptyListWidget()
          : ListView.builder(
              itemCount: userProvider.getAdmins?.length,
              itemBuilder: (_, index) {
                return _buildUserCar(userProvider.getAdmins?[index]);
              },
            ),
    );
  }

  Widget _buildUserCar(UserInfos? userInfos) {
    final colorScheme = Theme.of(context).colorScheme;
    final isBlocked = userInfos?.isBlocked ?? true;
    final isIos = PlatformHelper.isIos();

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: K.pvmH,
        horizontal: isIos ? K.pm : 0.0,
      ),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: isIos ? BorderRadius.circular(K.rm) : null,
          boxShadow: [BoxShadow(blurRadius: 10.0.r, color: colorScheme.shadow)],
        ),
        child: Material(
          color: colorScheme.tertiaryContainer,
          clipBehavior: Clip.antiAlias,
          borderRadius: isIos ? BorderRadius.circular(K.rm) : null,
          child: InkWell(
            onTap: () => context.push(
              Routes.adminManagePage,
              extra: {'userInfos': userInfos},
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: K.pvmH, horizontal: K.pm),
              child: Column(
                children: [
                  AvatarHero(
                    heroTag: userInfos?.uId ?? '',
                    height: 100.0.h,
                    avatar: userInfos?.avatar,
                    redShadow: isBlocked,
                  ),
                  K.pvm.verticalSpace,
                  Text(
                    '${userInfos?.firstname} ${userInfos?.surname}',
                    maxLines: 2,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  K.pvm.verticalSpace,
                  const Divider(),
                  AdminTitleAndTextWidget(
                    // TODO: text
                    title: 'Rolle: ',
                    text: userInfos?.role,
                  ),
                  const Divider(),
                  AdminTitleAndTextWidget(
                    // TODO: text
                    title: 'Status: ',
                    text: isBlocked ? 'Gesperrt' : 'Aktiv',
                  ),
                  const Divider(),
                  AdminTitleAndTextWidget(
                    // TODO: text
                    title: 'Standort: ',
                    text: userInfos?.location,
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:albus_la_mobile/configs/services/user_agent_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppVersionWidget extends StatefulWidget {
  const AppVersionWidget({super.key});

  @override
  State<AppVersionWidget> createState() => _AppVersionWidgetState();
}

class _AppVersionWidgetState extends State<AppVersionWidget> {
  String? _appVersion;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async => _getAppVersion(),
    );
    super.initState();
  }

  Future<void> _getAppVersion() async {
    final userAgnet = UserAgentService();
    final appVersion = await userAgnet.appVersion();
    setState(() => _appVersion = appVersion);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _appVersion != null,
      child: Padding(
        padding: EdgeInsets.only(top: 30.0.h, bottom: 10.0.h),
        child: Text(
          // TODO: text
          // '${S.of(context).homePageSettingsViewVersion} ${_appVersion ?? ''}',
          'Version: ${_appVersion ?? ''}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
    );
  }
}

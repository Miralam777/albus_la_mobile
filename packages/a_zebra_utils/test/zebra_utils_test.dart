/* import 'package:flutter_test/flutter_test.dart';
import 'package:zebra_utils/zebra_utils.dart';
import 'package:zebra_utils/zebra_utils_platform_interface.dart';
import 'package:zebra_utils/zebra_utils_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockZebraUtilsPlatform
    with MockPlatformInterfaceMixin
    implements ZebraUtilsPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final ZebraUtilsPlatform initialPlatform = ZebraUtilsPlatform.instance;

  test('$MethodChannelZebraUtils is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelZebraUtils>());
  });

  test('getPlatformVersion', () async {
    ZebraUtils zebraUtilsPlugin = ZebraUtils();
    MockZebraUtilsPlatform fakePlatform = MockZebraUtilsPlatform();
    ZebraUtilsPlatform.instance = fakePlatform;

    expect(await zebraUtilsPlugin.getPlatformVersion(), '42');
  });
}
 */

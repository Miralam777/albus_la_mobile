// TODO:
/* import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:quick_actions/quick_actions.dart';

//! 1. in folder \android\app\src\main\res\drawable Create new file quick_actions.xml
/*
<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">

  <item android:drawable="@drawable/ic_myicon" /> <!-- here your icon name-->

</layer-list>
*/

//! 2. In \android\app\src\main\res\values Create new file styles.xml if not already exist
/*
 <?xml version="1.0" encoding="utf-8"?>
 <resources>
    ...
    <!-- ! for quick_actions -->
    <style name="QuickActions">
      <item name="android:windowBackground">@drawable/quick_actions</item>
    </style>
 </resources>
 */

class QuickActionsUtils {
  QuickActionsUtils._();

  static const String _qrCodeScanner = 'qr_code_scanner';
  static const String _chats = 'chats';
  static const String _qrCodes = 'qr_codes';
  static const String _settings = 'settings';

  static late QuickActions _quickActions;

// * unten
  /// use this method in **initState()** in home
  static void initQuiActions() => _quickActions = const QuickActions();
// * unten
  ///  use this method in **initState() addPostFrameCallback()** in home
  static void jumpToTab({
    required BuildContext context,
    required PersistentTabController tabController,
  }) {
    _quickActions.setShortcutItems(_shortcutItems(context));
    _quickActions.initialize((String type) {
      switch (type) {
        case _qrCodeScanner:
          return tabController.jumpToTab(2);
        case _chats:
          return tabController.jumpToTab(3);
        case _qrCodes:
          return tabController.jumpToTab(1);
        case _settings:
          return tabController.jumpToTab(4);
        default:
          return tabController.jumpToTab(0);
      }
    });
  }

  static List<ShortcutItem> _shortcutItems(BuildContext context) =>
      <ShortcutItem>[
        const ShortcutItem(
          type: _qrCodeScanner,
          // TODO: text
          localizedTitle: 'Scannen',
          // localizedTitle: S.of(context).homePageBtmNavBarKoran,
          icon: _qrCodeScanner,
        ),
        const ShortcutItem(
          type: _chats,
          // TODO: text
          // localizedTitle: S.of(context).homePageBtmNavBarSearch,
          localizedTitle: 'Chats',
          icon: _chats,
        ),
        const ShortcutItem(
          type: _qrCodes,
          // TODO: text
          // localizedTitle: S.of(context).homePageBtmNavBarAudio,
          localizedTitle: 'Meine Qr-Codes',
          icon: _qrCodes,
        ),
        const ShortcutItem(
          type: _settings,
          // TODO: text
          // localizedTitle: S.of(context).homePageBtmNavBarSetting,
          localizedTitle: 'Einstellungen',
          icon: _settings,
        ),
      ];
}
 */

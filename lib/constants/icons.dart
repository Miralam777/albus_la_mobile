import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;

/// **Icons**
class I {
  I._();

  static final bool _isIOS = Platform.isIOS;
  // static final bool _isIOS = true;

  static const IconData videoLibrary = Icons.video_library_outlined;
  static const IconData cast = Icons.cast_rounded;
  static const IconData castConnected = Icons.cast_connected_rounded;
  static const IconData recordVoiceOver = Icons.record_voice_over_outlined;
  static const IconData imageNotSupported = Icons.image_not_supported_outlined;
  static const IconData musicOff = Icons.music_off_outlined;
  static const IconData audioFile = Icons.audio_file_outlined;
  static const IconData sync = Icons.sync_rounded;
  static const IconData videocamOff = Icons.videocam_off_outlined;
  static const IconData gavel = Icons.gavel_rounded;
  static const IconData liveTv = Icons.live_tv_rounded;
  static const IconData badge = Icons.badge_outlined;
  static const IconData videoFile = Icons.video_file_outlined;
  static const IconData cropFree = Icons.crop_free;
  static const IconData sortByAlpha = Icons.sort_by_alpha;
  static const IconData doneAll = Icons.done_all_rounded;
  static const IconData paragraph = CupertinoIcons.paragraph;
  static const IconData unsubscribe = Icons.unsubscribe_outlined;
  static const IconData signpost = Icons.signpost_outlined;
  static const IconData equal = CupertinoIcons.equal;
  static const IconData factory = Icons.factory_outlined;
  static const IconData nfc = Icons.nfc_rounded;
  static const IconData contactless = Icons.contactless_rounded;
  static const IconData passsword = Icons.password_rounded;
  static const IconData usb = Icons.usb_rounded;
  static const IconData cubeBox = CupertinoIcons.cube_box;
  static const IconData size = Icons.straighten_rounded;
  static const IconData scale = Icons.scale_outlined;

  static final IconData save = _isIOS
      ? CupertinoIcons.floppy_disk
      : Icons.save_rounded;

  static final IconData error = _isIOS
      ? CupertinoIcons.exclamationmark_circle
      : Icons.error_outline_rounded;

  static final IconData search = _isIOS
      ? CupertinoIcons.search
      : Icons.search_rounded;

  static final IconData movie = _isIOS
      ? CupertinoIcons.film
      : Icons.movie_creation_outlined;

  static final IconData newspaper = _isIOS
      ? CupertinoIcons.news_solid
      : Icons.newspaper_rounded;

  static final IconData musicNote = _isIOS
      ? CupertinoIcons.music_note
      : Icons.music_note_rounded;

  static final IconData close = _isIOS
      ? CupertinoIcons.clear
      : Icons.close_rounded;

  static final IconData fullscreenExit = _isIOS
      ? CupertinoIcons.fullscreen_exit
      : Icons.fullscreen_exit_outlined;

  static final IconData pauseCircleFill = _isIOS
      ? CupertinoIcons.pause_circle_fill
      : Icons.pause_circle_filled_rounded;

  static final IconData warningAmber = _isIOS
      ? CupertinoIcons.exclamationmark_triangle
      : Icons.warning_amber_rounded;

  static final IconData add = _isIOS ? CupertinoIcons.add : Icons.add_rounded;

  static final IconData check = _isIOS
      ? CupertinoIcons.checkmark
      : Icons.check_rounded;

  static final IconData checkCircle = _isIOS
      ? CupertinoIcons.checkmark_circle
      : Icons.check_circle_outline_outlined;

  static final IconData replay = _isIOS
      ? CupertinoIcons.refresh
      : Icons.replay_rounded;

  static final IconData playArrow = _isIOS
      ? CupertinoIcons.play_arrow_solid
      : Icons.play_arrow_rounded;

  static final IconData playCircleFill = _isIOS
      ? CupertinoIcons.play_circle_fill
      : Icons.play_circle_fill_rounded;

  static final IconData pause = _isIOS
      ? CupertinoIcons.pause_solid
      : Icons.pause_rounded;

  static final IconData notification = _isIOS
      ? CupertinoIcons.bell
      : Icons.notifications_outlined;

  static final IconData notificationAdd = _isIOS
      ? CupertinoIcons.bell_circle
      : Icons.notification_add_outlined;

  static final IconData notificationsActive = _isIOS
      ? CupertinoIcons.bell
      : Icons.notifications_active_outlined;

  static final IconData notificationsOff = _isIOS
      ? CupertinoIcons.bell_slash
      : Icons.notifications_off_outlined;

  static final IconData delete = _isIOS
      ? CupertinoIcons.delete
      : Icons.delete_outline_rounded;

  static final IconData deleteForever = _isIOS
      ? CupertinoIcons.delete_solid
      : Icons.delete_forever_outlined;

  static final IconData visibility = _isIOS
      ? CupertinoIcons.eye
      : Icons.visibility_outlined;

  static final IconData visibilityOff = _isIOS
      ? CupertinoIcons.eye_slash
      : Icons.visibility_off_outlined;

  static final IconData edit = _isIOS
      ? CupertinoIcons.pencil
      : Icons.edit_outlined;

  static final IconData copy = _isIOS
      ? CupertinoIcons.doc_on_doc
      : Icons.copy_rounded;

  static final IconData publish = _isIOS
      ? CupertinoIcons.share_up
      : Icons.publish_rounded;

  static final IconData update = _isIOS
      ? CupertinoIcons.refresh
      : Icons.update_rounded;

  static final IconData mic = _isIOS ? CupertinoIcons.mic : Icons.mic_none;

  static final IconData micOff = _isIOS
      ? CupertinoIcons.mic_off
      : Icons.mic_off_outlined;

  static final IconData photo = _isIOS
      ? CupertinoIcons.photo
      : Icons.photo_outlined;

  static final IconData addPhoto = _isIOS
      ? CupertinoIcons.photo_on_rectangle
      : Icons.add_photo_alternate_outlined;

  static final IconData dateRange = _isIOS
      ? CupertinoIcons.calendar
      : Icons.date_range_rounded;

  static final IconData time = _isIOS
      ? CupertinoIcons.time
      : Icons.schedule_rounded;

  static final IconData flashOn = _isIOS
      ? CupertinoIcons.bolt_fill
      : Icons.flash_on_rounded;

  static final IconData flashOff = _isIOS
      ? CupertinoIcons.bolt_slash_fill
      : Icons.flash_off_rounded;

  static final IconData camera = _isIOS
      ? CupertinoIcons.camera
      : Icons.camera_alt_outlined;

  static final IconData cameraswitch = _isIOS
      ? CupertinoIcons.switch_camera_solid
      : Icons.cameraswitch_rounded;

  static final IconData cameraRear = _isIOS
      ? CupertinoIcons.camera_rotate
      : Icons.camera_rear;

  static final IconData cameraFront = _isIOS
      ? CupertinoIcons.camera_rotate
      : Icons.camera_front_rounded;

  static final IconData person = _isIOS
      ? CupertinoIcons.person
      : Icons.person_outline_rounded;

  static final IconData personAdd = _isIOS
      ? CupertinoIcons.person_add
      : Icons.person_add_alt_1_outlined;

  static final IconData email = _isIOS
      ? CupertinoIcons.mail
      : Icons.email_outlined;

  static final IconData send = _isIOS
      ? CupertinoIcons.paperplane
      : Icons.send_rounded;

  static final IconData arrowBack = _isIOS
      ? CupertinoIcons.back
      : Icons.arrow_back_rounded;

  static final IconData home = _isIOS
      ? CupertinoIcons.home
      : Icons.home_rounded;

  static final IconData cellTower = _isIOS
      ? CupertinoIcons.antenna_radiowaves_left_right
      : Icons.cell_tower_rounded;

  static final IconData calendarMonth = _isIOS
      ? CupertinoIcons.calendar
      : Icons.calendar_month_rounded;

  static final IconData settings = _isIOS
      ? CupertinoIcons.settings
      : Icons.settings_outlined;

  static final IconData arrowForwardIos = _isIOS
      ? CupertinoIcons.right_chevron
      : Icons.arrow_forward_ios_rounded;

  static final IconData darkMode = _isIOS
      ? CupertinoIcons.moon
      : Icons.dark_mode_outlined;

  static final IconData lock = _isIOS
      ? CupertinoIcons.lock
      : Icons.lock_outline_rounded;

  static final IconData help = _isIOS
      ? CupertinoIcons.question_circle
      : Icons.help_outline;

  static final IconData info = _isIOS
      ? CupertinoIcons.info
      : Icons.info_outline_rounded;

  static final IconData domain = _isIOS
      ? CupertinoIcons.building_2_fill
      : Icons.domain_rounded;

  static final IconData feedback = _isIOS
      ? CupertinoIcons.exclamationmark_bubble
      : Icons.feedback_outlined;

  static final IconData phoneDevice = _isIOS
      ? CupertinoIcons.device_phone_portrait
      : Icons.phone_android_rounded;

  static final IconData viewList = _isIOS
      ? CupertinoIcons.list_bullet
      : Icons.view_list_rounded;

  static final IconData gridView = _isIOS
      ? CupertinoIcons.square_grid_2x2
      : Icons.grid_view_rounded;

  static final IconData login = _isIOS
      ? CupertinoIcons.square_arrow_right
      : Icons.login_rounded;

  static final IconData logout = _isIOS
      ? CupertinoIcons.square_arrow_left
      : Icons.logout_rounded;

  static final IconData favoriteBorder = _isIOS
      ? CupertinoIcons.heart
      : Icons.favorite_border_rounded;

  static final IconData verified = _isIOS
      ? CupertinoIcons.checkmark_seal_fill
      : Icons.verified_rounded;

  static final IconData filterAlt = _isIOS
      ? CupertinoIcons.line_horizontal_3_decrease_circle
      : Icons.filter_alt_outlined;

  static final IconData printer = _isIOS
      ? CupertinoIcons.printer
      : Icons.print_outlined;

  static final IconData done = _isIOS
      ? CupertinoIcons.checkmark
      : Icons.done_rounded;

  static final IconData shoppingCart = _isIOS
      ? CupertinoIcons.cart
      : Icons.shopping_cart_outlined;

  static final IconData shoppingCartAdd = _isIOS
      ? CupertinoIcons.cart_badge_plus
      : Icons.add_shopping_cart_rounded;

  static final IconData shoppingBag = _isIOS
      ? CupertinoIcons.bag
      : Icons.shopping_bag_outlined;

  static final IconData qrCode = _isIOS
      ? CupertinoIcons.qrcode
      : Icons.qr_code_rounded;

  static final IconData qrCodeScanner = _isIOS
      ? CupertinoIcons.qrcode_viewfinder
      : Icons.qr_code_scanner_rounded;

  static final IconData chat = _isIOS
      ? CupertinoIcons.chat_bubble_text
      : Icons.chat_outlined;

  static final IconData keyboard = _isIOS
      ? CupertinoIcons.keyboard
      : Icons.keyboard_outlined;

  static final IconData locationOn = _isIOS
      ? CupertinoIcons.map_pin_ellipse
      : Icons.location_on_rounded;

  static final IconData payments = _isIOS
      ? CupertinoIcons.creditcard
      : Icons.payments_rounded;

  static final IconData phone = _isIOS
      ? CupertinoIcons.phone
      : Icons.phone_rounded;

  static final IconData lightMode = _isIOS
      ? CupertinoIcons.brightness
      : Icons.light_mode_outlined;

  static final IconData euro = _isIOS
      ? CupertinoIcons.money_euro
      : Icons.euro_rounded;

  static final IconData archive = _isIOS
      ? CupertinoIcons.archivebox
      : Icons.archive_outlined;

  static final IconData category = _isIOS
      ? CupertinoIcons.square_grid_2x2_fill
      : Icons.category_outlined;

  static final IconData videoCall = _isIOS
      ? CupertinoIcons.video_camera
      : Icons.video_call_rounded;

  static final IconData more = _isIOS
      ? CupertinoIcons.ellipsis_vertical_circle
      : Icons.more_horiz_rounded;

  static final IconData tag = _isIOS ? CupertinoIcons.tag : Icons.sell_outlined;

  static final IconData description = _isIOS
      ? CupertinoIcons.doc_text
      : Icons.description_outlined;

  static final IconData numbers = _isIOS
      ? CupertinoIcons.number
      : Icons.numbers_rounded;

  static final IconData wifi = _isIOS
      ? CupertinoIcons.wifi
      : Icons.wifi_rounded;

  static final IconData bluetooth = _isIOS
      ? CupertinoIcons.bluetooth
      : Icons.bluetooth_rounded;

  static final IconData percent = _isIOS
      ? CupertinoIcons.percent
      : Icons.percent_rounded;

  static final IconData receipt = _isIOS
      ? CupertinoIcons.doc_plaintext
      : Icons.receipt_long_rounded;

  static final IconData generate = _isIOS
      ? CupertinoIcons.refresh
      : Icons.settings_backup_restore_rounded;

  static final IconData number = _isIOS
      ? CupertinoIcons.number
      : Icons.numbers_rounded;

  static final IconData arrowRight = _isIOS
      ? CupertinoIcons.arrow_right
      : Icons.east_rounded;

  static final IconData remove = _isIOS
      ? CupertinoIcons.minus
      : Icons.remove_rounded;

  static final IconData license = _isIOS
      ? CupertinoIcons.doc_plaintext
      : Icons.receipt_outlined;

  static final IconData text = _isIOS
      ? CupertinoIcons.doc_text
      : Icons.article_outlined;

  static final IconData inventory = _isIOS
      ? CupertinoIcons.archivebox
      : Icons.inventory_2_outlined;

  static final IconData color = _isIOS
      ? CupertinoIcons.paintbrush
      : Icons.palette_outlined;

  static final IconData cancel = _isIOS
      ? CupertinoIcons.clear_circled_solid
      : Icons.cancel_rounded;

  static final IconData cancelOutlined = _isIOS
      ? CupertinoIcons.clear_circled
      : Icons.cancel_outlined;

  static final IconData gruop = _isIOS
      ? CupertinoIcons.group
      : Icons.groups_outlined;

  static final IconData block = _isIOS
      ? CupertinoIcons.circle
      : Icons.block_rounded;

  static final IconData voiceCall = _isIOS
      ? CupertinoIcons.phone
      : Icons.call_rounded;

  static final IconData callEnd = _isIOS
      ? CupertinoIcons.phone_down_fill
      : Icons.call_end_rounded;

  static final IconData callReceived = _isIOS
      ? CupertinoIcons.phone_fill_arrow_down_left
      : Icons.phone_callback_rounded;

  static final IconData callMade = _isIOS
      ? CupertinoIcons.phone_fill_arrow_up_right
      : Icons.phone_forwarded_rounded;

  static final IconData volumeUp = _isIOS
      ? CupertinoIcons.speaker_2_fill
      : Icons.volume_up_rounded;

  static final IconData volumeOff = _isIOS
      ? CupertinoIcons.speaker_slash_fill
      : Icons.volume_off_rounded;

  static final IconData videocam = _isIOS
      ? CupertinoIcons.videocam
      : Icons.videocam_outlined;

  static final IconData videocamFill = _isIOS
      ? CupertinoIcons.videocam_fill
      : Icons.videocam_rounded;

  static final IconData language = _isIOS
      ? CupertinoIcons.globe
      : Icons.language_rounded;

  static final IconData web = _isIOS ? CupertinoIcons.link : Icons.web_rounded;

  static final IconData car = _isIOS
      ? CupertinoIcons.car_detailed
      : Icons.directions_car;

  // TODO: icon
  static final IconData key =
      // _isIOS ? CupertinoIcons.car_detailed : Icons.directions_car;
      _isIOS ? Icons.key_rounded : Icons.key_rounded;

  // TODO: icon
  static final IconData wallet =
      // _isIOS ? CupertinoIcons.car_detailed : Icons.directions_car;
      _isIOS ? Icons.wallet_rounded : Icons.wallet_rounded;

  static final IconData creditcard = _isIOS
      ? CupertinoIcons.creditcard
      : Icons.credit_card_rounded;
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';

/* 
! Android
  1. Add UCropActivity into your AndroidManifest.xml in application
  <!-- ! image_cropper -->
  <activity
    android:name="com.yalantis.ucrop.UCropActivity"
    android:screenOrientation="portrait"
    android:theme="@style/Ucrop.CropTheme"/>

  2. Add in ...\android\app\src\main\res\values\styles.xml in resources
  <!-- ! image_cropper -->
  <style name="Ucrop.CropTheme" parent="Theme.AppCompat.Light.NoActionBar">
    <item name="android:statusBarColor">#000000</item> <!-- oder gleiche Farbe wie Toolbar -->
    <item name="android:windowLightStatusBar">false</item> <!-- weiße Icons verhindern -->
  </style>


! IOS No configuration required
*/
class ImageCropperUtils {
  ImageCropperUtils._();

  static Future<String?> cropImage({
    required BuildContext context,
    required String imagePath,
    CropAspectRatio? aspectRatio,
    CropStyle cropStyle = CropStyle.circle,
  }) async {
    final appBarTheme = Theme.of(context).appBarTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      // maxHeight: 540,
      // maxWidth: 960,
      compressQuality: 90,
      compressFormat: ImageCompressFormat.jpg,
      // cropStyle: CropStyle.rectangle,
      aspectRatio: aspectRatio ?? const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          //! text
          // toolbarTitle: L.of(context).gwImageCropperToolbarTitle,
          toolbarTitle: 'Bildbeschneider',
          cropStyle: cropStyle,
          toolbarColor: appBarTheme.backgroundColor,
          statusBarColor: appBarTheme.backgroundColor,
          toolbarWidgetColor: appBarTheme.titleTextStyle?.color,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          activeControlsWidgetColor: colorScheme.secondary,
          cropGridColor: colorScheme.secondary,
          cropFrameColor: colorScheme.secondary,
          initAspectRatio: CropAspectRatioPreset.ratio16x9,
          cropFrameStrokeWidth: 7.r.toInt(),
          cropGridStrokeWidth: 3.r.toInt(),
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          //! text
          // title: L.of(context).gwImageCropperIosTitle,
          // cancelButtonTitle: L.of(context).gwImageCropperIosCancelBtn,
          // doneButtonTitle: L.of(context).gwImageCropperIosDoneBtn,
          title: 'Bildbeschneider',
          cancelButtonTitle: 'Abbrechen',
          doneButtonTitle: 'Fertig',
          cropStyle: CropStyle.circle,
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );

    return croppedFile?.path;
  }
}

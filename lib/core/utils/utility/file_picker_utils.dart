// import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

/* 
! Android No configuration required

! IOS add to info.plist

		<!--! file_picker -->
		<key>NSPhotoLibraryUsageDescription</key>
		<string>Explain why your app uses photo library</string>
    <key>NSCameraUsageDescription</key>
		<string>Need camera now I listen to your voice.</string>
		<!--! --> 

*/

class FilePickerUtils {
  FilePickerUtils._();

  static Future<String?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    return image?.path;
  }

  static Future<String?> pickImageFromCamera() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.camera);
    return image?.path;
  }

/*   static Future<String?> pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'PCM',
        'WAV',
        'AIFF',
        'FLAC',
        'ALAC',
        'WMA Lossless',
        'MP3',
        'AAC',
      ],
    );

    return result?.files.first.path;
  } */

/*   static Future<String?> pickVideoFromGallery() async {
    final picker = ImagePicker();
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    return pickedVideo?.path;
  } */
}

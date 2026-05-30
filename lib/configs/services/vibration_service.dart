import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';

class VibrationService {
  VibrationService._();

  static final AudioPlayer _audioPlayer = AudioPlayer();

  // Singleton-Pattern (optional)
/*   static final VibrationService _instance = VibrationService._internal();
  factory VibrationService() => _instance;
  VibrationService._internal(); */

  /// Prüft, ob das Gerät Vibration unterstützt.
  static Future<bool> _canVibrate() async {
    return await Vibration.hasVibrator() ?? false;
  }

  /// Vibrieren bei erfolgreichem QR-Code-Scan.
  static Future<void> successVibration() async {
    if (await _canVibrate()) {
      _playSuccessSound();
      // Vibration.vibrate(duration: 200); // Kurze Vibration
      Vibration.vibrate(pattern: [0, 300, 200, 300]);
    }
  }

  /// Vibrieren bei nicht übereinstimmenden QR-Codes.
  static Future<void> mismatchVibration() async {
    if (await _canVibrate()) {
      _playErrorSound();
      // Vibration.vibrate(pattern: [0, 300, 200, 300]); // Muster: kurz-lang-kurz
      Vibration.vibrate(pattern: [0, 500, 10, 500, 10, 500]);
    }
  }

  /// Vibrieren bei allgemeinen Fehlern.
  static Future<void> errorVibration() async {
    if (await _canVibrate()) {
      _playErrorSound();
      Vibration.vibrate(
          pattern: [0, 500, 200, 500, 200, 500]); // Muster: lang-lang-lang
    }
  }

  /// Sound abspielen, wenn QR-Code übereinstimmt
  static Future<void> _playSuccessSound() async {
    await _audioPlayer.play(AssetSource('sounds/success.mp3'));
  }

  /// Sound abspielen, wenn QR-Code nicht übereinstimmt
  static Future<void> _playErrorSound() async {
    await _audioPlayer.play(AssetSource('sounds/warning.mp3'));
  }
}

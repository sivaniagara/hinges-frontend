import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  final AudioPlayer _player = AudioPlayer();

  Future<void> playSound(String assetPath) async {
    try {
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void dispose() {
    _player.dispose();
  }
}

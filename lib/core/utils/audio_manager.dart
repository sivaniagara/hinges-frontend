import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  final AudioPlayer _player = AudioPlayer();

  AudioManager() {
    _player.setPlayerMode(PlayerMode.lowLatency);
    _player.setReleaseMode(ReleaseMode.stop);
  }

  /// 🔥 Warmup to remove first delay
  Future<void> warmUp(String assetPath) async {
    try {
      await _player.setVolume(0); // mute
      await _player.play(AssetSource(assetPath));
      await Future.delayed(const Duration(milliseconds: 100));
      await _player.stop();
      await _player.setVolume(1); // restore
    } catch (e) {
      print("Warmup error: $e");
    }
  }

  Future<void> playSound(String assetPath) async {
    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  void dispose() {
    _player.dispose();
  }
}
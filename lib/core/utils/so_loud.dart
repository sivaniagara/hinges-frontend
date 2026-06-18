import 'package:flutter_soloud/flutter_soloud.dart';
import 'app_sounds.dart';

final soloud = SoLoud.instance;
AudioSource? tapSound;
AudioSource? welcome;

Future<void> initSoLoud() async {
  await soloud.init();
  tapSound = await soloud.loadAsset(
    AppSounds.clickSound,
    mode: LoadMode.memory,
  );
  welcome = await soloud.loadAsset(
    AppSounds.welcome,
    mode: LoadMode.memory,
  );
}

void playTap() {
  if (tapSound == null) return;
  soloud.play(
    tapSound!,
    volume: 1.0,
    paused: false,    // ✅ starts immediately, not paused
  );
}

void playWelcome(){
  if (welcome == null) return;
  soloud.play(
    welcome!,
    volume: 1.0,
    paused: false,    // ✅ starts immediately, not paused
  );
}
import 'package:flutter_soloud/flutter_soloud.dart';
import 'app_sounds.dart';

final soloud = SoLoud.instance;
AudioSource? tapSound;
AudioSource? welcome;

// Pre-loaded instruction audio sources (instruction_1.mp3 → instruction_11.mp3)
final List<AudioSource?> instructionSources = List.filled(11, null);

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

  // Pre-load all 11 instruction clips
  for (int i = 0; i < 11; i++) {
    instructionSources[i] = await soloud.loadAsset(
      'assets/audio/instruction_${i + 1}.mp3',
      mode: LoadMode.memory,
    );
  }
}

void playTap() {
  if (tapSound == null) return;
  soloud.play(tapSound!, volume: 1.0, paused: false);
}

void playWelcome() {
  if (welcome == null) return;
  soloud.play(welcome!, volume: 1.0, paused: false);
}

/// Plays instruction_[index+1].mp3 (0-based index).
/// Calls [onComplete] when playback finishes.
Future<void> playInstruction(
    int index, {
      required void Function() onComplete,
    }) async {
  final source = instructionSources[index];
  if (source == null) {
    onComplete();
    return;
  }

  // Listen BEFORE play so the event is never missed
  source.allInstancesFinished.first.then((_) => onComplete());

  soloud.play(source, volume: 1.0, paused: false);
}
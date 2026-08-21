import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'app_sounds.dart';

final soloud = SoLoud.instance;
AudioSource? tapSound;
AudioSource? welcome;
AudioSource? playSold;
AudioSource? playUnSold;

bool _isSoundEnabled = true;
bool _isVibrationEnabled = true;

// Pre-loaded instruction audio sources (instruction_1.mp3 → instruction_11.mp3)
final List<AudioSource?> instructionSources = List.filled(11, null);
final List<AudioSource?> soundList = List.filled(9, null);

Future<void> initSoLoud() async {
  await soloud.init();

  final prefs = await SharedPreferences.getInstance();
  _isSoundEnabled = prefs.getBool('isSoundOn') ?? true;
  _isVibrationEnabled = prefs.getBool('isVibrateOn') ?? true;

  tapSound = await soloud.loadAsset(
    AppSounds.clickSound,
    mode: LoadMode.memory,
  );
  welcome = await soloud.loadAsset(
    AppSounds.welcome,
    mode: LoadMode.memory,
  );
  playSold = await soloud.loadAsset(
    AppSounds.sold,
    mode: LoadMode.memory,
  );
  playUnSold = await soloud.loadAsset(
    AppSounds.unSold,
    mode: LoadMode.memory,
  );

  // Pre-load all 11 instruction clips
  for (int i = 0; i < 11; i++) {
    instructionSources[i] = await soloud.loadAsset(
      'assets/audio/instruction_${i + 1}.mp3',
      mode: LoadMode.memory,
    );
  }

  for (int i = 0; i < 9; i++) {
    soundList[i] = await soloud.loadAsset(
      'assets/audio/${i + 1}.mp3',
      mode: LoadMode.memory,
    );
  }
}

/// Updates the local cache of sound and vibration settings.
/// Call this whenever settings are changed in the UI.
///
///
///
void updateFeedbackSettings({bool? sound, bool? vibration}) {
  if (sound != null) _isSoundEnabled = sound;
  if (vibration != null) _isVibrationEnabled = vibration;
}

void playTap() {
  if (_isVibrationEnabled) {
    Vibration.vibrate(duration: 50);
  }
  
  if (!_isSoundEnabled) return;
  
  if (tapSound == null) return;
  soloud.play(tapSound!, volume: 1.0, paused: false);
}

void playVibrateOnly({int duration = 50}){
  if (_isVibrationEnabled) {
    Vibration.vibrate(duration: duration);
  }
}


void playWelcome() {
  if (!_isSoundEnabled) return;
  if (welcome == null) return;
  soloud.play(welcome!, volume: 1.0, paused: false);
}

void playSoldAudio() {
  if (playSold == null) return;
  soloud.play(playSold!, volume: 1.0, paused: false);
}

void playUnSoldAudio() {
  if (playUnSold == null) return;
  soloud.play(playUnSold!, volume: 1.0, paused: false);
}

/// Plays instruction_[index+1].mp3 (0-based index).
/// Calls [onComplete] when playback finishes.
Future<void> playInstruction(
    int index, {
      required void Function() onComplete,
    }) async {
  // if (!_isSoundEnabled) {
  //   onComplete();
  //   return;
  // }
  
  final source = instructionSources[index];
  if (source == null) {
    onComplete();
    return;
  }

  // Listen BEFORE play so the event is never missed
  source.allInstancesFinished.first.then((_) => onComplete());

  soloud.play(source, volume: 1.0, paused: false);
}

void playSoundFromList(int num) async {
  final source = soundList[num - 1];
  if (source == null) {
    return;
  }
  soloud.play(source, volume: 1.0, paused: false);
}
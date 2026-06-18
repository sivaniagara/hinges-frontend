import '../di/dependency_injection.dart';
import 'app_sounds.dart';
import 'audio_manager.dart';

void warmUpSound() async{
  final audio = sl<AudioManager>();
  await audio.warmUp(AppSounds.clickSound);
}
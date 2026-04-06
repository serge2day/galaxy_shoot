import 'audio_service.dart';

class NoopAudioService implements AudioService {
  @override
  Future<void> initialize() async {}

  @override
  void playBgm(String track) {}

  @override
  void stopBgm() {}

  @override
  void playSfx(String effect) {}

  @override
  void dispose() {}
}

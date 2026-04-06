abstract class AudioService {
  Future<void> initialize();
  void playBgm(String track);
  void stopBgm();
  void playSfx(String effect);
  void dispose();
}

import 'flame_audio_service.dart';

/// Global audio singleton for easy access from both Flutter UI and Flame.
class GameAudio {
  GameAudio._();

  static final FlameAudioService _service = FlameAudioService();
  static FlameAudioService get instance => _service;

  static Future<void> initialize() => _service.initialize();

  // SFX triggers
  static void playerFire() => _service.playSfx('player_fire.mp3');
  static void enemyHit() => _service.playSfx('enemy_hit.mp3');
  static void enemyDeath() => _service.playSfx('enemy_death.mp3');
  static void playerDamage() => _service.playSfx('player_damage.mp3');
  static void playerDeath() => _service.playSfx('player_death.mp3');
  static void pickupCollect() => _service.playSfx('pickup_collect.mp3');
  static void evolutionUp() => _service.playSfx('evolution_up.mp3');
  static void bossEnter() => _service.playSfx('boss_enter.mp3');
  static void bossPhase() => _service.playSfx('boss_phase.mp3');
  static void bossDeath() => _service.playSfx('boss_death.mp3');
  static void victory() => _service.playSfx('victory.mp3');
  static void gameOver() => _service.playSfx('game_over.mp3');
  static void menuClick() => _service.playSfx('pickup_collect.mp3');

  // BGM
  static void playMenuMusic() => _service.playBgm('bgm_menu.mp3');
  static void playBattleMusic() => _service.playBgm('bgm_battle.mp3');
  static void playBossMusic() => _service.playBgm('bgm_boss.mp3');
  static void stopMusic() => _service.stopBgm();
}

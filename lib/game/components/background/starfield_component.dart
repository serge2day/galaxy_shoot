import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../core/config/game_balance.dart';

class StarfieldComponent extends Component with HasGameReference {
  final List<_StarLayer> _layers = [];

  @override
  Future<void> onLoad() async {
    final rng = Random();
    final w = game.size.x;
    final h = game.size.y;

    for (int i = 0; i < GameBalance.starfieldLayerCount; i++) {
      final speed = 20.0 + i * 30.0;
      final starSize = 0.5 + i * 0.6;
      final opacity = 0.3 + i * 0.25;
      final stars = <_Star>[];

      for (int j = 0; j < GameBalance.starsPerLayer; j++) {
        stars.add(
          _Star(
            x: rng.nextDouble() * w,
            y: rng.nextDouble() * h,
            size: starSize + rng.nextDouble() * 0.5,
          ),
        );
      }
      _layers.add(
        _StarLayer(
          stars: stars,
          speed: speed,
          opacity: opacity.clamp(0.0, 1.0),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    final h = game.size.y;
    final w = game.size.x;
    for (final layer in _layers) {
      for (final star in layer.stars) {
        star.y += layer.speed * dt;
        if (star.y > h) {
          star.y = -2;
          star.x = Random().nextDouble() * w;
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    for (final layer in _layers) {
      final paint = Paint()
        ..color = Color.fromRGBO(255, 255, 255, layer.opacity);
      for (final star in layer.stars) {
        canvas.drawCircle(Offset(star.x, star.y), star.size, paint);
      }
    }
  }
}

class _StarLayer {
  final List<_Star> stars;
  final double speed;
  final double opacity;

  _StarLayer({required this.stars, required this.speed, required this.opacity});
}

class _Star {
  double x;
  double y;
  final double size;

  _Star({required this.x, required this.y, required this.size});
}

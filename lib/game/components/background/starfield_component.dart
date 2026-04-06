import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../../core/config/game_balance.dart';

class StarfieldComponent extends Component with HasGameReference {
  final Color? tint;
  final double speedMultiplier;
  final List<_StarLayer> _layers = [];

  StarfieldComponent({this.tint, this.speedMultiplier = 1.0});

  @override
  Future<void> onLoad() async {
    final rng = Random();
    final w = game.size.x;
    final h = game.size.y;

    for (int i = 0; i < GameBalance.starfieldLayerCount; i++) {
      final speed = (20.0 + i * 30.0) * speedMultiplier;
      final starSize = 0.5 + i * 0.6;
      final opacity = (0.3 + i * 0.25).clamp(0.0, 1.0);
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
      _layers.add(_StarLayer(stars: stars, speed: speed, opacity: opacity));
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
      Color starColor;
      if (tint != null) {
        // Blend white toward the tint color
        final t = tint!;
        final r = ((255 + (t.r * 255.0).round().clamp(0, 255)) ~/ 2);
        final g = ((255 + (t.g * 255.0).round().clamp(0, 255)) ~/ 2);
        final b = ((255 + (t.b * 255.0).round().clamp(0, 255)) ~/ 2);
        starColor = Color.fromRGBO(r, g, b, layer.opacity);
      } else {
        starColor = Color.fromRGBO(255, 255, 255, layer.opacity);
      }
      final paint = Paint()..color = starColor;
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

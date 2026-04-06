import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../../galaxy_game.dart';

/// Rich space background with nebulae, planets, and bright stars.
/// Different visual theme per sector.
class SpaceBackground extends Component with HasGameReference<GalaxyGame> {
  final int stageIndex;
  final List<_Nebula> _nebulae = [];
  final List<_Planet> _planets = [];
  final List<_BrightStar> _brightStars = [];
  late final Random _rng;

  SpaceBackground({required this.stageIndex});

  @override
  Future<void> onLoad() async {
    _rng = Random(stageIndex * 42 + 7);
    final w = game.size.x;
    final h = game.size.y;

    // Sector colors
    final List<Color> nebulaColors;
    final List<Color> planetColors;
    if (stageIndex < 3) {
      nebulaColors = [
        const Color(0x15004D9F),
        const Color(0x100D47A1),
        const Color(0x1200BCD4),
      ];
      planetColors = [const Color(0xFF37474F), const Color(0xFF546E7A)];
    } else if (stageIndex < 6) {
      nebulaColors = [
        const Color(0x184A148C),
        const Color(0x15880E4F),
        const Color(0x12CE93D8),
      ];
      planetColors = [
        const Color(0xFF4A148C),
        const Color(0xFF6A1B9A),
        const Color(0xFF880E4F),
      ];
    } else {
      nebulaColors = [
        const Color(0x18B71C1C),
        const Color(0x15DD2C00),
        const Color(0x12FF6D00),
      ];
      planetColors = [const Color(0xFF4E342E), const Color(0xFFBF360C)];
    }

    // Create 2-3 nebula clouds
    final nebulaCount = 2 + _rng.nextInt(2);
    for (int i = 0; i < nebulaCount; i++) {
      _nebulae.add(
        _Nebula(
          x: _rng.nextDouble() * w,
          y: _rng.nextDouble() * h,
          radius: 80 + _rng.nextDouble() * 120,
          color: nebulaColors[_rng.nextInt(nebulaColors.length)],
          speed: 3 + _rng.nextDouble() * 5,
        ),
      );
    }

    // Create 1-2 planets
    final planetCount = 1 + _rng.nextInt(2);
    for (int i = 0; i < planetCount; i++) {
      final hasRing = stageIndex >= 3 && _rng.nextBool();
      _planets.add(
        _Planet(
          x: 30 + _rng.nextDouble() * (w - 60),
          y: _rng.nextDouble() * h,
          radius: 20 + _rng.nextDouble() * 40 + stageIndex * 3,
          color: planetColors[_rng.nextInt(planetColors.length)],
          speed: 5 + _rng.nextDouble() * 8,
          hasRing: hasRing,
        ),
      );
    }

    // Create bright twinkling stars
    for (int i = 0; i < 8 + stageIndex; i++) {
      _brightStars.add(
        _BrightStar(
          x: _rng.nextDouble() * w,
          y: _rng.nextDouble() * h,
          size: 1.0 + _rng.nextDouble() * 2.0,
          twinkleSpeed: 2 + _rng.nextDouble() * 4,
          speed: 1 + _rng.nextDouble() * 3,
        ),
      );
    }
  }

  @override
  void update(double dt) {
    final h = game.size.y;
    final w = game.size.x;

    for (final n in _nebulae) {
      n.y += n.speed * dt;
      if (n.y - n.radius > h) {
        n.y = -n.radius;
        n.x = _rng.nextDouble() * w;
      }
    }
    for (final p in _planets) {
      p.y += p.speed * dt;
      if (p.y - p.radius > h) {
        p.y = -p.radius - 20;
        p.x = 30 + _rng.nextDouble() * (w - 60);
      }
    }
    for (final s in _brightStars) {
      s.y += s.speed * dt;
      s.elapsed += dt;
      if (s.y > h) {
        s.y = -2;
        s.x = _rng.nextDouble() * w;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Nebulae (large blurred circles)
    for (final n in _nebulae) {
      final paint = Paint()
        ..color = n.color
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, n.radius * 0.6);
      canvas.drawCircle(Offset(n.x, n.y), n.radius, paint);
    }

    // Planets
    for (final p in _planets) {
      // Planet body
      final bodyPaint = Paint()..color = p.color;
      canvas.drawCircle(Offset(p.x, p.y), p.radius, bodyPaint);

      // Highlight
      final highlightPaint = Paint()..color = const Color(0x15FFFFFF);
      canvas.drawCircle(
        Offset(p.x - p.radius * 0.3, p.y - p.radius * 0.3),
        p.radius * 0.5,
        highlightPaint,
      );

      // Ring
      if (p.hasRing) {
        final ringPaint = Paint()
          ..color = p.color.withValues(alpha: 0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(p.x, p.y),
            width: p.radius * 2.8,
            height: p.radius * 0.6,
          ),
          ringPaint,
        );
      }
    }

    // Bright stars with twinkle
    for (final s in _brightStars) {
      final twinkle = (sin(s.elapsed * s.twinkleSpeed) + 1) / 2;
      final alpha = 0.3 + twinkle * 0.7;
      final starPaint = Paint()..color = Color.fromRGBO(255, 255, 255, alpha);
      canvas.drawCircle(
        Offset(s.x, s.y),
        s.size * (0.5 + twinkle * 0.5),
        starPaint,
      );

      // Cross-spike on brightest stars
      if (s.size > 1.5 && twinkle > 0.6) {
        final spikePaint = Paint()
          ..color = Color.fromRGBO(255, 255, 255, alpha * 0.4)
          ..strokeWidth = 0.5;
        canvas.drawLine(
          Offset(s.x - s.size * 3, s.y),
          Offset(s.x + s.size * 3, s.y),
          spikePaint,
        );
        canvas.drawLine(
          Offset(s.x, s.y - s.size * 3),
          Offset(s.x, s.y + s.size * 3),
          spikePaint,
        );
      }
    }
  }
}

class _Nebula {
  double x, y;
  final double radius;
  final Color color;
  final double speed;
  _Nebula({
    required this.x,
    required this.y,
    required this.radius,
    required this.color,
    required this.speed,
  });
}

class _Planet {
  double x, y;
  final double radius;
  final Color color;
  final double speed;
  final bool hasRing;
  _Planet({
    required this.x,
    required this.y,
    required this.radius,
    required this.color,
    required this.speed,
    this.hasRing = false,
  });
}

class _BrightStar {
  double x, y;
  final double size;
  final double twinkleSpeed;
  final double speed;
  double elapsed = 0;
  _BrightStar({
    required this.x,
    required this.y,
    required this.size,
    required this.twinkleSpeed,
    required this.speed,
  });
}

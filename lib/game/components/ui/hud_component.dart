import 'dart:ui';

import 'package:flame/components.dart';

import '../../galaxy_game.dart';

class HudComponent extends PositionComponent with HasGameReference<GalaxyGame> {
  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(0, 0);
    this.size = size;
  }

  @override
  void render(Canvas canvas) {
    final screenW = size.x;
    final topY = 48.0;

    // Score
    _drawText(
      canvas,
      'SCORE: ${game.score}',
      16,
      topY,
      16,
      const Color(0xFFE0E0E0),
    );

    // HP bar
    _drawHpBar(canvas, screenW - 120, topY, 100, 8);

    // Lives
    _drawText(
      canvas,
      'LIVES: ${game.lives}',
      screenW - 120,
      topY + 14,
      11,
      const Color(0xFF69F0AE),
    );

    // Evolution level
    final evoLevel = game.evolution.level;
    final evoColor = game.evolution.isOverdriveActive
        ? const Color(0xFFFF6D00)
        : const Color(0xFFFFD600);
    _drawText(canvas, 'EVO: $evoLevel', 16, topY + 22, 12, evoColor);

    // Overdrive bar (show when at max evo)
    if (evoLevel >= 5) {
      if (game.evolution.isOverdriveActive) {
        _drawText(
          canvas,
          'OVERDRIVE!',
          16,
          topY + 38,
          11,
          const Color(0xFFFF6D00),
        );
      } else {
        final progress = game.evolution.overdriveProgress;
        _drawBar(
          canvas,
          16,
          topY + 40,
          80,
          5,
          progress,
          const Color(0xFFFF6D00),
        );
      }
    }

    // Bomb count
    if (game.bomb.charges > 0) {
      _drawText(
        canvas,
        'BOMB: ${game.bomb.charges}',
        16,
        topY + 52,
        11,
        const Color(0xFFFF6D00),
      );
    }
  }

  void _drawHpBar(Canvas canvas, double x, double y, double w, double h) {
    final bgPaint = Paint()..color = const Color(0x40FFFFFF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, w, h),
        const Radius.circular(4),
      ),
      bgPaint,
    );

    final hpRatio = (game.hp / game.shipStats.maxHp).clamp(0.0, 1.0);
    final fillColor = hpRatio > 0.5
        ? const Color(0xFF69F0AE)
        : hpRatio > 0.25
        ? const Color(0xFFFF9100)
        : const Color(0xFFFF5252);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, w * hpRatio, h),
        const Radius.circular(4),
      ),
      Paint()..color = fillColor,
    );
  }

  void _drawBar(
    Canvas canvas,
    double x,
    double y,
    double w,
    double h,
    double ratio,
    Color color,
  ) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, w, h),
        const Radius.circular(3),
      ),
      Paint()..color = const Color(0x30FFFFFF),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, w * ratio.clamp(0.0, 1.0), h),
        const Radius.circular(3),
      ),
      Paint()..color = color,
    );
  }

  void _drawText(
    Canvas canvas,
    String text,
    double x,
    double y,
    double fontSize,
    Color color,
  ) {
    final builder = ParagraphBuilder(ParagraphStyle(fontSize: fontSize))
      ..pushStyle(
        TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      )
      ..addText(text);
    final paragraph = builder.build();
    paragraph.layout(const ParagraphConstraints(width: 200));
    canvas.drawParagraph(paragraph, Offset(x, y));
  }
}

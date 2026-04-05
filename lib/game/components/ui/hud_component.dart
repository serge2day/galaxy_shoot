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

    // Score
    _drawText(
      canvas,
      'SCORE: ${game.score}',
      16,
      48,
      16,
      const Color(0xFFE0E0E0),
    );

    // HP
    _drawHpBar(canvas, screenW - 120, 48, 100, 8);

    // Lives
    _drawText(
      canvas,
      'LIVES: ${game.lives}',
      screenW - 120,
      62,
      12,
      const Color(0xFF69F0AE),
    );
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
    final fillPaint = Paint()..color = fillColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, w * hpRatio, h),
        const Radius.circular(4),
      ),
      fillPaint,
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

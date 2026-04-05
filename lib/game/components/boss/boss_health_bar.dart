import 'dart:ui';

import 'package:flame/components.dart';

import 'boss_ship.dart';

class BossHealthBar extends PositionComponent with HasGameReference {
  final BossShip boss;

  BossHealthBar({required this.boss})
    : super(size: Vector2(200, 12), anchor: Anchor.topCenter);

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(game.size.x / 2, 16);
    this.size.x = game.size.x * 0.6;
  }

  @override
  void render(Canvas canvas) {
    if (!boss.isMounted) return;

    final w = size.x;
    final h = size.y;
    final hpRatio = (boss.hp / boss.maxHp).clamp(0.0, 1.0);

    // Background
    final bgRect = Rect.fromLTWH(0, 0, w, h);
    final bgPaint = Paint()..color = const Color(0x40FFFFFF);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(6)),
      bgPaint,
    );

    // Health fill
    final fillRect = Rect.fromLTWH(0, 0, w * hpRatio, h);
    final fillColor = hpRatio > 0.5
        ? const Color(0xFF7C4DFF)
        : hpRatio > 0.25
        ? const Color(0xFFFF9100)
        : const Color(0xFFFF1744);
    final fillPaint = Paint()..color = fillColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(fillRect, const Radius.circular(6)),
      fillPaint,
    );

    // Glow
    final glowPaint = Paint()
      ..color = fillColor.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawRRect(
      RRect.fromRectAndRadius(fillRect, const Radius.circular(6)),
      glowPaint,
    );

    // Label
    final labelParagraph = _buildText('BOSS', 10, const Color(0xFFFFFFFF));
    canvas.drawParagraph(
      labelParagraph,
      Offset((w - labelParagraph.width) / 2, (h - labelParagraph.height) / 2),
    );
  }

  Paragraph _buildText(String text, double fontSize, Color color) {
    final builder =
        ParagraphBuilder(
            ParagraphStyle(textAlign: TextAlign.center, fontSize: fontSize),
          )
          ..pushStyle(
            TextStyle(
              color: color,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          )
          ..addText(text);
    final paragraph = builder.build();
    paragraph.layout(const ParagraphConstraints(width: 100));
    return paragraph;
  }
}

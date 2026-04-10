import 'dart:ui';

import 'package:flame/components.dart';

import 'boss_ship.dart';

class BossHealthBar extends PositionComponent with HasGameReference {
  final BossShip boss;

  BossHealthBar({required this.boss})
    : super(size: Vector2(200, 18), anchor: Anchor.topCenter);

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(game.size.x / 2, 20);
    this.size.x = game.size.x * 0.7;
  }

  @override
  void render(Canvas canvas) {
    if (!boss.isMounted) {
      removeFromParent();
      return;
    }

    final w = size.x;
    final h = size.y;
    final hpRatio = (boss.hp / boss.maxHp).clamp(0.0, 1.0);

    // Background with border
    final bgRect = Rect.fromLTWH(0, 0, w, h);
    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(9)),
      Paint()..color = const Color(0x60000000),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(bgRect, const Radius.circular(9)),
      Paint()
        ..color = const Color(0x50FFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // Health fill
    final fillRect = Rect.fromLTWH(2, 2, (w - 4) * hpRatio, h - 4);
    final fillColor = hpRatio > 0.5
        ? const Color(0xFFFF1744)
        : hpRatio > 0.25
        ? const Color(0xFFFF9100)
        : const Color(0xFFFFD600);
    canvas.drawRRect(
      RRect.fromRectAndRadius(fillRect, const Radius.circular(7)),
      Paint()..color = fillColor,
    );

    // Glow on fill
    canvas.drawRRect(
      RRect.fromRectAndRadius(fillRect, const Radius.circular(7)),
      Paint()
        ..color = fillColor.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );

    // Label
    final hpText = '${boss.hp} / ${boss.maxHp}';
    final paragraph = _buildText('BOSS  $hpText', 10, const Color(0xFFFFFFFF));
    canvas.drawParagraph(
      paragraph,
      Offset((w - paragraph.width) / 2, (h - paragraph.height) / 2),
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
    paragraph.layout(ParagraphConstraints(width: size.x));
    return paragraph;
  }
}

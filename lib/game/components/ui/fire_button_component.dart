import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../../galaxy_game.dart';
import '../player/player_ship.dart';

class FireButtonComponent extends PositionComponent
    with TapCallbacks, HasGameReference<GalaxyGame> {
  final PlayerShip player;
  bool _pressed = false;

  FireButtonComponent({required this.player})
    : super(size: Vector2(72, 72), anchor: Anchor.center);

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    position = Vector2(game.size.x - 60, game.size.y - 80);
  }

  @override
  bool onTapDown(TapDownEvent event) {
    _pressed = true;
    return true;
  }

  @override
  bool onTapUp(TapUpEvent event) {
    _pressed = false;
    return true;
  }

  @override
  bool onTapCancel(TapCancelEvent event) {
    _pressed = false;
    return true;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_pressed) {
      player.weapon.fire();
    }
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    // Outer ring
    final ringPaint = Paint()
      ..color = _pressed ? const Color(0xCC00E5FF) : const Color(0x6600E5FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, ringPaint);

    // Inner fill
    final fillPaint = Paint()
      ..color = _pressed ? const Color(0x4000E5FF) : const Color(0x2000E5FF);
    canvas.drawCircle(center, radius - 4, fillPaint);

    // Crosshair
    final crossPaint = Paint()
      ..color = const Color(0xAA00E5FF)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(center.dx, center.dy - 12),
      Offset(center.dx, center.dy + 12),
      crossPaint,
    );
    canvas.drawLine(
      Offset(center.dx - 12, center.dy),
      Offset(center.dx + 12, center.dy),
      crossPaint,
    );
  }
}

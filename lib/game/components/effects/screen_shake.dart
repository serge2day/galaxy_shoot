import 'dart:math';

import 'package:flame/components.dart';

/// Applies a temporary random position offset to its parent component.
/// Duration ~0.15s, magnitude ~4px. Add to galaxyWorld on big hits.
class ScreenShake extends Component with ParentIsA<PositionComponent> {
  double _elapsed = 0;
  final double duration;
  final double magnitude;
  final Random _rng = Random();
  Vector2 _originalPosition = Vector2.zero();
  bool _captured = false;

  ScreenShake({this.duration = 0.15, this.magnitude = 4.0});

  @override
  void update(double dt) {
    super.update(dt);

    if (!_captured) {
      _originalPosition = parent.position.clone();
      _captured = true;
    }

    _elapsed += dt;

    if (_elapsed >= duration) {
      // Restore original position
      parent.position.setFrom(_originalPosition);
      removeFromParent();
      return;
    }

    final progress = _elapsed / duration;
    final decay = 1.0 - progress; // decays over time
    final offsetX = (_rng.nextDouble() * 2 - 1) * magnitude * decay;
    final offsetY = (_rng.nextDouble() * 2 - 1) * magnitude * decay;

    parent.position.setFrom(_originalPosition);
    parent.position.x += offsetX;
    parent.position.y += offsetY;
  }

  @override
  void onRemove() {
    if (_captured) {
      parent.position.setFrom(_originalPosition);
    }
    super.onRemove();
  }
}

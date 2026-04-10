import 'package:flutter/services.dart';

import 'haptics_service.dart';

/// Haptics via native Android Vibrator through dedicated MethodChannel.
/// Same pattern as Blockfall/Tetris.
class FlutterHapticsService implements HapticsService {
  static const _channel =
      MethodChannel('com.twodaycom.starvane/vibration');
  bool _enabled = true;

  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  @override
  void lightImpact() {
    if (!_enabled) return;
    try {
      _channel.invokeMethod('vibrate', {'duration': 15, 'amplitude': 60});
    } catch (_) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  void mediumImpact() {
    if (!_enabled) return;
    try {
      _channel.invokeMethod('vibrate', {'duration': 25, 'amplitude': 120});
    } catch (_) {
      HapticFeedback.mediumImpact();
    }
  }

  @override
  void heavyImpact() {
    if (!_enabled) return;
    try {
      _channel.invokeMethod('vibrate', {'duration': 50, 'amplitude': 200});
    } catch (_) {
      HapticFeedback.heavyImpact();
    }
  }
}

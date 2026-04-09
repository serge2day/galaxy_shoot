import 'package:flutter/services.dart';

import 'haptics_service.dart';

/// Haptics via native Android Vibrator through MethodChannel.
class FlutterHapticsService implements HapticsService {
  static const _channel = MethodChannel('com.starvane/sfx');
  bool _enabled = true;

  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  @override
  void lightImpact() {
    if (!_enabled) return;
    try {
      _channel.invokeMethod('vibrate', {'duration': 20, 'amplitude': 60});
    } catch (e) {
      // ignore
    }
  }

  @override
  void mediumImpact() {
    if (!_enabled) return;
    try {
      _channel.invokeMethod('vibrate', {'duration': 40, 'amplitude': 128});
    } catch (e) {
      // ignore
    }
  }

  @override
  void heavyImpact() {
    if (!_enabled) return;
    try {
      _channel.invokeMethod('vibrate', {'duration': 80, 'amplitude': 255});
    } catch (e) {
      // ignore
    }
  }
}

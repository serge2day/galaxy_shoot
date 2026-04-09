import 'package:flutter/services.dart';

import 'haptics_service.dart';

class FlutterHapticsService implements HapticsService {
  bool _enabled = true;

  void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  @override
  void lightImpact() {
    if (!_enabled) return;
    try {
      HapticFeedback.lightImpact();
    } catch (e) {
      // Fallback
      try {
        HapticFeedback.vibrate();
      } catch (_) {}
    }
  }

  @override
  void mediumImpact() {
    if (!_enabled) return;
    try {
      HapticFeedback.mediumImpact();
    } catch (e) {
      try {
        HapticFeedback.vibrate();
      } catch (_) {}
    }
  }

  @override
  void heavyImpact() {
    if (!_enabled) return;
    try {
      HapticFeedback.heavyImpact();
    } catch (e) {
      try {
        HapticFeedback.vibrate();
      } catch (_) {}
    }
  }
}

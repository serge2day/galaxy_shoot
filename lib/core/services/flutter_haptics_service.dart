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
    HapticFeedback.lightImpact();
  }

  @override
  void mediumImpact() {
    if (!_enabled) return;
    HapticFeedback.mediumImpact();
  }

  @override
  void heavyImpact() {
    if (!_enabled) return;
    HapticFeedback.heavyImpact();
  }
}

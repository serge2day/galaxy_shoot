import 'haptics_service.dart';

class NoopHapticsService implements HapticsService {
  @override
  void lightImpact() {}

  @override
  void mediumImpact() {}

  @override
  void heavyImpact() {}
}

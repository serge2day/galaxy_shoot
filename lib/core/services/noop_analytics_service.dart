import 'analytics_service.dart';

class NoopAnalyticsService implements AnalyticsService {
  @override
  void logEvent(String name, [Map<String, dynamic>? params]) {}

  @override
  void setUserProperty(String name, String value) {}
}

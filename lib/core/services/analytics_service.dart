abstract class AnalyticsService {
  void logEvent(String name, [Map<String, dynamic>? params]);
  void setUserProperty(String name, String value);
}

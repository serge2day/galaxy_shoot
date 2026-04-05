enum FireMode {
  auto,
  manual;

  static FireMode fromString(String value) {
    return FireMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => FireMode.auto,
    );
  }
}

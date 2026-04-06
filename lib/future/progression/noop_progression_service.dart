import 'progression_service.dart';

class NoopProgressionService implements ProgressionService {
  @override
  int getCurrentLevel() => 1;

  @override
  bool isLevelUnlocked(int level) => level == 1;

  @override
  Future<void> completeLevel(int level, int stars) async {}
}

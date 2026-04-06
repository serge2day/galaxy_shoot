import '../../../features/campaign/domain/stage_id.dart';
import 'stage_01.dart';
import 'stage_02.dart';
import 'stage_03.dart';
import 'stage_definition.dart';

class StageRegistry {
  const StageRegistry._();

  static StageDefinition get(StageId id) {
    switch (id) {
      case StageId.stage1:
        return stage01;
      case StageId.stage2:
        return stage02;
      case StageId.stage3:
        return stage03;
    }
  }
}

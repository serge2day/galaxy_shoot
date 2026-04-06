import '../../../features/campaign/domain/stage_id.dart';
import 'stage_01.dart';
import 'stage_02.dart';
import 'stage_03.dart';
import 'stage_04.dart';
import 'stage_05.dart';
import 'stage_06.dart';
import 'stage_07.dart';
import 'stage_08.dart';
import 'stage_09.dart';
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
      case StageId.stage4:
        return stage04;
      case StageId.stage5:
        return stage05;
      case StageId.stage6:
        return stage06;
      case StageId.stage7:
        return stage07;
      case StageId.stage8:
        return stage08;
      case StageId.stage9:
        return stage09;
    }
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:galaxy_shoot/features/session/domain/run_result.dart';

void main() {
  test('RunResult stores score and outcome', () {
    const result = RunResult(score: 1500, outcome: RunOutcome.victory);
    expect(result.score, 1500);
    expect(result.outcome, RunOutcome.victory);
  });

  test('RunOutcome has gameOver variant', () {
    const result = RunResult(score: 200, outcome: RunOutcome.gameOver);
    expect(result.outcome, RunOutcome.gameOver);
  });
}

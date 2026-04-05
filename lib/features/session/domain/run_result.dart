enum RunOutcome { victory, gameOver }

class RunResult {
  final int score;
  final RunOutcome outcome;

  const RunResult({required this.score, required this.outcome});
}

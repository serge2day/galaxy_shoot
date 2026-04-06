enum RunOutcome { victory, gameOver }

class RunResult {
  final int score;
  final RunOutcome outcome;
  final int enemyKills;
  final bool bossDefeated;
  final int peakEvolutionLevel;

  const RunResult({
    required this.score,
    required this.outcome,
    this.enemyKills = 0,
    this.bossDefeated = false,
    this.peakEvolutionLevel = 1,
  });
}

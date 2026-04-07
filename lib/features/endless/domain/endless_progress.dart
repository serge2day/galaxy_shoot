class EndlessProgress {
  final bool unlocked;
  final int highestSector;
  final int bestScore;
  final Map<String, int> perShipBestSector;

  const EndlessProgress({
    this.unlocked = false,
    this.highestSector = 0,
    this.bestScore = 0,
    this.perShipBestSector = const {},
  });

  EndlessProgress copyWith({
    bool? unlocked,
    int? highestSector,
    int? bestScore,
    Map<String, int>? perShipBestSector,
  }) {
    return EndlessProgress(
      unlocked: unlocked ?? this.unlocked,
      highestSector: highestSector ?? this.highestSector,
      bestScore: bestScore ?? this.bestScore,
      perShipBestSector: perShipBestSector ?? this.perShipBestSector,
    );
  }

  EndlessProgress withSectorCleared(int sector, int score, String shipId) {
    final newHighest = sector > highestSector ? sector : highestSector;
    final newBest = score > bestScore ? score : bestScore;
    final shipBest = perShipBestSector[shipId] ?? 0;
    final newShipBests = {
      ...perShipBestSector,
      shipId: sector > shipBest ? sector : shipBest,
    };
    return EndlessProgress(
      unlocked: unlocked,
      highestSector: newHighest,
      bestScore: newBest,
      perShipBestSector: newShipBests,
    );
  }
}

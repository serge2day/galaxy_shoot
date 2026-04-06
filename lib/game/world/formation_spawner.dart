import 'dart:math';

import 'package:flame/components.dart';

import '../components/enemies/enemy_ship.dart';
import '../components/enemies/enemy_type.dart';
import 'stages/stage_definition.dart';

enum FormationType { grid, vShape, diamond, line, arc, staggeredRows }

class FormationSpawner {
  static final Random _rng = Random();

  /// Spawns enemies in a formation. Returns list of EnemyShip to add.
  static List<EnemyShip> spawn({
    required int count,
    required EnemyType enemyType,
    required EnemyMovementType movement,
    required double gameWidth,
    bool isElite = false,
  }) {
    // Pick formation based on count
    FormationType formation;
    if (count >= 12) {
      formation = [
        FormationType.grid,
        FormationType.staggeredRows,
        FormationType.arc,
      ][_rng.nextInt(3)];
    } else if (count >= 6) {
      formation = [
        FormationType.vShape,
        FormationType.diamond,
        FormationType.grid,
        FormationType.line,
      ][_rng.nextInt(4)];
    } else {
      formation = [
        FormationType.line,
        FormationType.vShape,
        FormationType.diamond,
      ][_rng.nextInt(3)];
    }

    switch (formation) {
      case FormationType.grid:
        return _spawnGrid(count, enemyType, movement, gameWidth, isElite);
      case FormationType.vShape:
        return _spawnVShape(count, enemyType, movement, gameWidth, isElite);
      case FormationType.diamond:
        return _spawnDiamond(count, enemyType, movement, gameWidth, isElite);
      case FormationType.line:
        return _spawnLine(count, enemyType, movement, gameWidth, isElite);
      case FormationType.arc:
        return _spawnArc(count, enemyType, movement, gameWidth, isElite);
      case FormationType.staggeredRows:
        return _spawnStaggeredRows(
          count,
          enemyType,
          movement,
          gameWidth,
          isElite,
        );
    }
  }

  /// Grid: rows of enemies evenly spaced (4x3, 5x4, etc.)
  static List<EnemyShip> _spawnGrid(
    int count,
    EnemyType enemyType,
    EnemyMovementType movement,
    double gameWidth,
    bool isElite,
  ) {
    final ships = <EnemyShip>[];
    final ew = enemyType.width * (isElite ? 1.3 : 1.0);
    final eh = enemyType.height * (isElite ? 1.3 : 1.0);
    final hGap = ew * 0.6;
    final vGap = eh * 0.5;

    // Determine columns: fit as many as possible with margins
    final margin = 30.0;
    final usableWidth = gameWidth - margin * 2;
    int cols = (usableWidth / (ew + hGap)).floor().clamp(2, count);
    int rows = (count / cols).ceil();

    final totalW = cols * ew + (cols - 1) * hGap;
    final startX = (gameWidth - totalW) / 2 + ew / 2;

    int spawned = 0;
    for (int row = 0; row < rows && spawned < count; row++) {
      for (int col = 0; col < cols && spawned < count; col++) {
        final x = startX + col * (ew + hGap);
        final y = -30.0 - row * (eh + vGap);
        ships.add(
          EnemyShip(
            startPosition: Vector2(x, y),
            movement: movement,
            enemyType: enemyType,
            isElite: isElite,
          ),
        );
        spawned++;
      }
    }
    return ships;
  }

  /// V-Shape: enemies in a V pointing downward
  static List<EnemyShip> _spawnVShape(
    int count,
    EnemyType enemyType,
    EnemyMovementType movement,
    double gameWidth,
    bool isElite,
  ) {
    final ships = <EnemyShip>[];
    final ew = enemyType.width * (isElite ? 1.3 : 1.0);
    final eh = enemyType.height * (isElite ? 1.3 : 1.0);
    final spacing = ew * 1.2;

    final centerX = gameWidth / 2;
    // Split count into left and right arms, with tip at bottom-center
    final halfCount = count ~/ 2;
    final hasCenter = count % 2 == 1;

    int spawned = 0;

    // V-tip at the bottom (closest to screen), arms go up and outward
    if (hasCenter) {
      ships.add(
        EnemyShip(
          startPosition: Vector2(centerX, -30.0),
          movement: movement,
          enemyType: enemyType,
          isElite: isElite,
        ),
      );
      spawned++;
    }

    for (int i = 1; i <= halfCount && spawned < count; i++) {
      final xOffset = i * spacing;
      final yOffset = -30.0 - i * (eh * 0.8);

      // Left arm
      if (spawned < count) {
        ships.add(
          EnemyShip(
            startPosition: Vector2(centerX - xOffset, yOffset),
            movement: movement,
            enemyType: enemyType,
            isElite: isElite,
          ),
        );
        spawned++;
      }
      // Right arm
      if (spawned < count) {
        ships.add(
          EnemyShip(
            startPosition: Vector2(centerX + xOffset, yOffset),
            movement: movement,
            enemyType: enemyType,
            isElite: isElite,
          ),
        );
        spawned++;
      }
    }
    return ships;
  }

  /// Diamond: enemies in diamond/rhombus pattern
  static List<EnemyShip> _spawnDiamond(
    int count,
    EnemyType enemyType,
    EnemyMovementType movement,
    double gameWidth,
    bool isElite,
  ) {
    final ships = <EnemyShip>[];
    final ew = enemyType.width * (isElite ? 1.3 : 1.0);
    final eh = enemyType.height * (isElite ? 1.3 : 1.0);
    final spacingX = ew * 1.1;
    final spacingY = eh * 0.9;

    final centerX = gameWidth / 2;

    // Build diamond rows: 1, 2, 3, ..., maxRow, ..., 3, 2, 1
    // Determine how many rows we need to fit `count` enemies
    List<int> rowCounts = [];
    int remaining = count;
    int width = 1;
    bool expanding = true;

    while (remaining > 0) {
      final rowSize = min(width, remaining);
      rowCounts.add(rowSize);
      remaining -= rowSize;
      if (expanding) {
        width++;
        if (width > 5) expanding = false;
      }
      if (!expanding) {
        width = max(1, width - 1);
      }
    }

    int spawned = 0;
    for (int row = 0; row < rowCounts.length && spawned < count; row++) {
      final rowCount = rowCounts[row];
      final rowWidth = rowCount * spacingX;
      final rowStartX = centerX - rowWidth / 2 + spacingX / 2;

      for (int col = 0; col < rowCount && spawned < count; col++) {
        final x = rowStartX + col * spacingX;
        final y = -30.0 - row * spacingY;
        ships.add(
          EnemyShip(
            startPosition: Vector2(x, y),
            movement: movement,
            enemyType: enemyType,
            isElite: isElite,
          ),
        );
        spawned++;
      }
    }
    return ships;
  }

  /// Line: horizontal line of enemies
  static List<EnemyShip> _spawnLine(
    int count,
    EnemyType enemyType,
    EnemyMovementType movement,
    double gameWidth,
    bool isElite,
  ) {
    final ships = <EnemyShip>[];
    final ew = enemyType.width * (isElite ? 1.3 : 1.0);
    final margin = 30.0;
    final usableWidth = gameWidth - margin * 2;

    // Space enemies evenly across the usable width
    final spacing = count > 1 ? min(ew * 1.4, usableWidth / (count - 1)) : 0.0;
    final totalW = spacing * (count - 1);
    final startX = (gameWidth - totalW) / 2;

    for (int i = 0; i < count; i++) {
      final x = count > 1 ? startX + i * spacing : gameWidth / 2;
      ships.add(
        EnemyShip(
          startPosition: Vector2(x, -40.0),
          movement: movement,
          enemyType: enemyType,
          isElite: isElite,
        ),
      );
    }
    return ships;
  }

  /// Arc: enemies in a curved arc
  static List<EnemyShip> _spawnArc(
    int count,
    EnemyType enemyType,
    EnemyMovementType movement,
    double gameWidth,
    bool isElite,
  ) {
    final ships = <EnemyShip>[];
    final centerX = gameWidth / 2;
    final arcRadius = gameWidth * 0.35;

    // Arc spans from ~30 degrees to ~150 degrees (downward-facing arc)
    const startAngle = 0.52; // ~30 degrees in radians
    const endAngle = 2.62; // ~150 degrees in radians
    final angleStep = count > 1 ? (endAngle - startAngle) / (count - 1) : 0.0;

    for (int i = 0; i < count; i++) {
      final angle = count > 1 ? startAngle + i * angleStep : pi / 2;
      final x = centerX + cos(angle) * arcRadius;
      final y = -60.0 - sin(angle) * arcRadius * 0.6;
      ships.add(
        EnemyShip(
          startPosition: Vector2(x, y),
          movement: movement,
          enemyType: enemyType,
          isElite: isElite,
        ),
      );
    }
    return ships;
  }

  /// StaggeredRows: alternating offset rows (brick pattern)
  static List<EnemyShip> _spawnStaggeredRows(
    int count,
    EnemyType enemyType,
    EnemyMovementType movement,
    double gameWidth,
    bool isElite,
  ) {
    final ships = <EnemyShip>[];
    final ew = enemyType.width * (isElite ? 1.3 : 1.0);
    final eh = enemyType.height * (isElite ? 1.3 : 1.0);
    final hGap = ew * 0.5;
    final vGap = eh * 0.4;

    final margin = 30.0;
    final usableWidth = gameWidth - margin * 2;
    int cols = (usableWidth / (ew + hGap)).floor().clamp(2, count);
    int rows = (count / cols).ceil();

    final totalW = cols * ew + (cols - 1) * hGap;
    final baseStartX = (gameWidth - totalW) / 2 + ew / 2;

    int spawned = 0;
    for (int row = 0; row < rows && spawned < count; row++) {
      // Offset every other row by half a spacing
      final isOffset = row % 2 == 1;
      final offsetX = isOffset ? (ew + hGap) / 2 : 0.0;
      final rowCols = isOffset ? max(1, cols - 1) : cols;

      for (int col = 0; col < rowCols && spawned < count; col++) {
        final x = (baseStartX + offsetX + col * (ew + hGap)).clamp(
          margin,
          gameWidth - margin,
        );
        final y = -30.0 - row * (eh + vGap);
        ships.add(
          EnemyShip(
            startPosition: Vector2(x, y),
            movement: movement,
            enemyType: enemyType,
            isElite: isElite,
          ),
        );
        spawned++;
      }
    }
    return ships;
  }
}

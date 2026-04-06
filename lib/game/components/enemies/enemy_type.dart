import 'dart:ui';

enum EnemyType {
  drone,
  interceptor,
  gunship;

  double get baseHp {
    switch (this) {
      case EnemyType.drone:
        return 2;
      case EnemyType.interceptor:
        return 3;
      case EnemyType.gunship:
        return 6;
    }
  }

  double get baseSpeed {
    switch (this) {
      case EnemyType.drone:
        return 120;
      case EnemyType.interceptor:
        return 180;
      case EnemyType.gunship:
        return 70;
    }
  }

  double get baseFireCooldown {
    switch (this) {
      case EnemyType.drone:
        return 1.8;
      case EnemyType.interceptor:
        return 1.2;
      case EnemyType.gunship:
        return 0.9;
    }
  }

  int get scoreReward {
    switch (this) {
      case EnemyType.drone:
        return 100;
      case EnemyType.interceptor:
        return 150;
      case EnemyType.gunship:
        return 250;
    }
  }

  double get width {
    switch (this) {
      case EnemyType.drone:
        return 36;
      case EnemyType.interceptor:
        return 32;
      case EnemyType.gunship:
        return 46;
    }
  }

  double get height {
    switch (this) {
      case EnemyType.drone:
        return 36;
      case EnemyType.interceptor:
        return 38;
      case EnemyType.gunship:
        return 44;
    }
  }

  Color get bodyColor {
    switch (this) {
      case EnemyType.drone:
        return const Color(0xFFD32F2F);
      case EnemyType.interceptor:
        return const Color(0xFFFF6F00);
      case EnemyType.gunship:
        return const Color(0xFF6A1B9A);
    }
  }

  Color get glowColor {
    switch (this) {
      case EnemyType.drone:
        return const Color(0xFFFF5252);
      case EnemyType.interceptor:
        return const Color(0xFFFFAB40);
      case EnemyType.gunship:
        return const Color(0xFFCE93D8);
    }
  }
}

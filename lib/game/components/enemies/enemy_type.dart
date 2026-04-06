import 'dart:ui';

enum EnemyType {
  drone,
  interceptor,
  gunship,
  swarmer,
  carrier;

  double get baseHp {
    switch (this) {
      case EnemyType.drone:
        return 2;
      case EnemyType.interceptor:
        return 3;
      case EnemyType.gunship:
        return 6;
      case EnemyType.swarmer:
        return 1;
      case EnemyType.carrier:
        return 8;
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
      case EnemyType.swarmer:
        return 150;
      case EnemyType.carrier:
        return 60;
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
      case EnemyType.swarmer:
        return 2.5;
      case EnemyType.carrier:
        return 0.7;
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
      case EnemyType.swarmer:
        return 50;
      case EnemyType.carrier:
        return 400;
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
      case EnemyType.swarmer:
        return 24;
      case EnemyType.carrier:
        return 52;
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
      case EnemyType.swarmer:
        return 24;
      case EnemyType.carrier:
        return 50;
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
      case EnemyType.swarmer:
        return const Color(0xFF00C853);
      case EnemyType.carrier:
        return const Color(0xFF004D40);
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
      case EnemyType.swarmer:
        return const Color(0xFF69F0AE);
      case EnemyType.carrier:
        return const Color(0xFF26A69A);
    }
  }
}

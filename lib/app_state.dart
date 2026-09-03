import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import 'models.dart';

class AppState extends ChangeNotifier {
  static const seedMoney = 100.0;
  static const seasonLength = Duration(minutes: 5);
  static const winThreshold = 200.0;
  static const fineThreshold = 80.0;
  static const fineAmount = 200.0;
  static const cowReward = 50.0;

  double money = seedMoney;
  double nitrogen = 0;
  int cowCount = 0;
  Duration seasonRemaining = seasonLength;
  List<Spawn> spawns = [];
  Position? playerPosition;

  bool get seasonOver => seasonRemaining <= Duration.zero;
  bool get won => money >= winThreshold;

  void catchCow(Spawn s) {
    money += cowReward;
    cowCount++;
    nitrogen = (nitrogen + 5).clamp(0, 100);
    spawns.remove(s);
    notifyListeners();
  }

  void missCow(Spawn s) {
    spawns.remove(s);
    notifyListeners();
  }

  void clearCloud(Spawn s) {
    nitrogen = (nitrogen - 10).clamp(0, 100);
    spawns.remove(s);
    notifyListeners();
  }

  void failCloud(Spawn s) {
    nitrogen = (nitrogen + 15).clamp(0, 100);
    spawns.remove(s);
    notifyListeners();
  }

  void tickSecond() {
    if (seasonOver) return;
    nitrogen = (nitrogen + 0.5 + cowCount * 0.05).clamp(0, 100);
    seasonRemaining -= const Duration(seconds: 1);
    if (seasonRemaining < Duration.zero) seasonRemaining = Duration.zero;
    notifyListeners();
  }

  /// Government fine for letting nitrogen stay above [fineThreshold] — paid
  /// either by choice ("ignore it and pay") or automatically once the
  /// warning countdown in FineWarningScreen runs out.
  void applyFine() {
    money -= fineAmount;
    nitrogen = (nitrogen - 20).clamp(0, 100); // partial relief so it isn't a death spiral
    notifyListeners();
  }

  void reset() {
    money = seedMoney;
    nitrogen = 0;
    cowCount = 0;
    seasonRemaining = seasonLength;
    spawns = [];
    playerPosition = null;
    notifyListeners();
  }
}

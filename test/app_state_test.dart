import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:cow_game/app_state.dart';
import 'package:cow_game/models.dart';

void main() {
  Spawn cow() => Spawn(id: '1', type: SpawnType.cow, position: const LatLng(0, 0));
  Spawn cloud() => Spawn(id: '2', type: SpawnType.cloud, position: const LatLng(0, 0));

  test('catchCow adds money, increments cowCount, removes spawn', () {
    final state = AppState();
    final s = cow();
    state.spawns = [s];
    state.catchCow(s);
    expect(state.money, AppState.seedMoney + AppState.cowReward);
    expect(state.cowCount, 1);
    expect(state.spawns, isEmpty);
  });

  test('clearCloud lowers nitrogen and removes spawn', () {
    final state = AppState()..nitrogen = 50;
    final s = cloud();
    state.spawns = [s];
    state.clearCloud(s);
    expect(state.nitrogen, 40);
    expect(state.spawns, isEmpty);
  });

  test('failCloud raises nitrogen and removes spawn', () {
    final state = AppState()..nitrogen = 50;
    final s = cloud();
    state.spawns = [s];
    state.failCloud(s);
    expect(state.nitrogen, 65);
    expect(state.spawns, isEmpty);
  });

  test('tickSecond raises nitrogen and lowers seasonRemaining', () {
    final state = AppState();
    state.tickSecond();
    expect(state.nitrogen, greaterThan(0));
    expect(state.seasonRemaining, AppState.seasonLength - const Duration(seconds: 1));
  });

  test('applyFine deducts money and gives partial nitrogen relief', () {
    final state = AppState()..nitrogen = 90;
    final moneyBefore = state.money;
    state.applyFine();
    expect(state.money, moneyBefore - AppState.fineAmount);
    expect(state.nitrogen, 70);
  });

  test('tickSecond no longer fines automatically', () {
    final state = AppState()..nitrogen = AppState.fineThreshold;
    final moneyBefore = state.money;
    state.tickSecond();
    expect(state.money, moneyBefore);
  });

  test('won flips true at winThreshold', () {
    final state = AppState();
    expect(state.won, isFalse);
    state.money = AppState.winThreshold;
    expect(state.won, isTrue);
  });

  test('seasonOver true once seasonRemaining hits zero', () {
    final state = AppState()..seasonRemaining = Duration.zero;
    expect(state.seasonOver, isTrue);
  });
}

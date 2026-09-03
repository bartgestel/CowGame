import 'package:flutter_test/flutter_test.dart';
import 'package:cow_game/shake_detector.dart';

void main() {
  test('isShake is false at rest (gravity only)', () {
    expect(isShake(0, 0, 9.8), isFalse);
  });

  test('isShake is true for a hard jolt', () {
    expect(isShake(30, 0, 9.8), isTrue);
  });

  test('ShakeCounter debounces rapid repeats', () async {
    final counter = ShakeCounter(debounce: const Duration(milliseconds: 300));
    expect(counter.onSample(30, 0, 9.8), isTrue);
    // immediate repeat within debounce window is ignored
    expect(counter.onSample(30, 0, 9.8), isFalse);
    expect(counter.count, 1);
  });

  test('ShakeCounter counts a shake after the debounce window elapses', () async {
    final counter = ShakeCounter(debounce: const Duration(milliseconds: 10));
    expect(counter.onSample(30, 0, 9.8), isTrue);
    await Future.delayed(const Duration(milliseconds: 20));
    expect(counter.onSample(30, 0, 9.8), isTrue);
    expect(counter.count, 2);
  });
}

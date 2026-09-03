import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:cow_game/geo_utils.dart';

void main() {
  const utrecht = LatLng(52.0907, 5.1214);

  test('isWithin is true for points a few meters apart', () {
    // ~11m north
    final near = LatLng(utrecht.latitude + 0.0001, utrecht.longitude);
    expect(isWithin(utrecht, near, 20), isTrue);
  });

  test('isWithin is false for points far apart', () {
    final far = LatLng(utrecht.latitude + 1, utrecht.longitude);
    expect(isWithin(utrecht, far, 20), isFalse);
  });

  test('randomOffset stays within [minM, maxM] over many trials', () {
    for (var i = 0; i < 200; i++) {
      final p = randomOffset(utrecht, 20, 80);
      expect(isWithin(utrecht, p, 80), isTrue);
      expect(isWithin(utrecht, p, 19.9), isFalse);
    }
  });
}

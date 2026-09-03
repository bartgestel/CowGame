import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

const _metersPerDegreeLat = 111320.0;
final _random = Random();

/// True if [player] is within [thresholdM] meters of [target].
bool isWithin(LatLng player, LatLng target, double thresholdM) {
  final meters = Geolocator.distanceBetween(
    player.latitude,
    player.longitude,
    target.latitude,
    target.longitude,
  );
  return meters <= thresholdM;
}

/// A point at a random bearing and a random distance between [minM] and
/// [maxM] meters from [center]. Flat-earth approximation — fine at this
/// scale (tens of meters), no need for a full geodesic library.
LatLng randomOffset(LatLng center, double minM, double maxM) {
  final distance = minM + _random.nextDouble() * (maxM - minM);
  final bearing = _random.nextDouble() * 2 * pi;
  final dLat = (distance * cos(bearing)) / _metersPerDegreeLat;
  final metersPerDegreeLng = _metersPerDegreeLat * cos(center.latitude * pi / 180);
  final dLng = (distance * sin(bearing)) / metersPerDegreeLng;
  return LatLng(center.latitude + dLat, center.longitude + dLng);
}

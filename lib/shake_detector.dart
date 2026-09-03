import 'dart:math';

const gravity = 9.8;

/// True if the raw accelerometer sample (x, y, z, m/s^2) looks like a shake:
/// magnitude minus gravity exceeds [threshold].
/// ponytail: fixed threshold, no per-device calibration — retune this
/// constant on a real phone, accelerometers vary.
bool isShake(double x, double y, double z, {double threshold = 15.0}) {
  final magnitude = sqrt(x * x + y * y + z * z);
  return (magnitude - gravity).abs() > threshold;
}

/// Counts debounced shakes: repeated shake events within [debounce] of each
/// other only count once, so one physical shake doesn't register 20 times.
class ShakeCounter {
  final Duration debounce;
  DateTime? _lastShakeAt;
  int count = 0;

  ShakeCounter({this.debounce = const Duration(milliseconds: 300)});

  /// Feed one accelerometer sample; returns true if it counted as a new shake.
  bool onSample(double x, double y, double z, {double threshold = 15.0}) {
    if (!isShake(x, y, z, threshold: threshold)) return false;
    final now = DateTime.now();
    if (_lastShakeAt != null && now.difference(_lastShakeAt!) < debounce) {
      return false;
    }
    _lastShakeAt = now;
    count++;
    return true;
  }
}

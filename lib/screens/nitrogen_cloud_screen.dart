import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../app_state.dart';
import '../models.dart';
import '../shake_detector.dart';
import 'nitrogen_failed_screen.dart';
import 'nitrogen_passed_screen.dart';

const _countdown = Duration(seconds: 10);
const _shakesToClear = 4;

class NitrogenCloudScreen extends StatefulWidget {
  final Spawn spawn;
  const NitrogenCloudScreen({super.key, required this.spawn});

  @override
  State<NitrogenCloudScreen> createState() => _NitrogenCloudScreenState();
}

class _NitrogenCloudScreenState extends State<NitrogenCloudScreen> {
  final _shakeCounter = ShakeCounter();
  StreamSubscription<AccelerometerEvent>? _accelSub;
  Timer? _timer;
  int _secondsLeft = _countdown.inSeconds;
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    _accelSub = accelerometerEventStream().listen(_onAccel);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _onAccel(AccelerometerEvent event) {
    if (_resolved) return;
    if (_shakeCounter.onSample(event.x, event.y, event.z)) {
      setState(() {});
      if (_shakeCounter.count >= _shakesToClear) _finish(passed: true);
    }
  }

  // ponytail: manual fallback for platforms where real shake doesn't reach us
  // (iOS Safari has no Generic Sensor API support) — same effect as a shake.
  void _manualShake() {
    if (_resolved) return;
    setState(() => _shakeCounter.count++);
    if (_shakeCounter.count >= _shakesToClear) _finish(passed: true);
  }

  void _tick() {
    if (_resolved) return;
    setState(() => _secondsLeft--);
    if (_secondsLeft <= 0) _finish(passed: false);
  }

  void _finish({required bool passed}) {
    if (_resolved) return;
    _resolved = true;
    _timer?.cancel();
    _accelSub?.cancel();
    final appState = context.read<AppState>();
    if (passed) {
      appState.clearCloud(widget.spawn);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const NitrogenPassedScreen()),
      );
    } else {
      appState.failCloud(widget.spawn);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const NitrogenFailedScreen()),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _accelSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressPercent = ((_shakeCounter.count / _shakesToClear) * 100).clamp(0, 100).round();
    return Scaffold(
      backgroundColor: const Color(0xFFF4A15D),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFF3E2C1E), borderRadius: BorderRadius.circular(20)),
              child: Text('0:${_secondsLeft.toString().padLeft(2, '0')}',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.cloud, size: 110, color: Colors.brown.shade700),
                    const SizedBox(height: 32),
                    const Text('SHAKE your phone!',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white)),
                    const SizedBox(height: 6),
                    const Text('Blow the nitrogen cloud away',
                        style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 32),
                    const Icon(Icons.phone_iphone, size: 40, color: Colors.white),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: 240,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progressPercent / 100,
                          minHeight: 14,
                          backgroundColor: const Color(0xFFF7C99A),
                          color: const Color(0xFFFFF4E4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('$progressPercent% cleared',
                        style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: _manualShake,
                      child: const Text('Shake not working? Tap here',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

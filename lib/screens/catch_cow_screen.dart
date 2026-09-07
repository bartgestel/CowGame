import 'dart:async';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../models.dart';
import 'catch_miss_screen.dart';
import 'catch_success_screen.dart';
import 'shared_widgets.dart';

const _countdown = Duration(seconds: 3);
// ponytail: cosmetic only, picked once per encounter — matches the
// Pokémon-GO-style name tag in the concept art.
const _cowNames = ['Bertha', 'Daisy', 'Mabel', 'Clover', 'Hazel', 'Ginny'];

class CatchCowScreen extends StatefulWidget {
  final Spawn spawn;
  const CatchCowScreen({super.key, required this.spawn});

  @override
  State<CatchCowScreen> createState() => _CatchCowScreenState();
}

class _CatchCowScreenState extends State<CatchCowScreen> {
  CameraController? _cameraController;
  late final String _cowName = _cowNames[Random().nextInt(_cowNames.length)];
  Timer? _timer;
  int _secondsLeft = _countdown.inSeconds;
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (_resolved) return;
    setState(() => _secondsLeft--);
    if (_secondsLeft <= 0) _resolve(caught: false);
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;
      final controller = CameraController(cameras.first, ResolutionPreset.medium);
      await controller.initialize();
      if (!mounted) return;
      setState(() => _cameraController = controller);
    } catch (_) {
      // ponytail: camera unavailable/denied/hosting-specific quirk (known
      // issue on the deployed build, see git history) — falls back to the
      // plain background below rather than blocking the game.
    }
  }

  void _catchIt() => _resolve(caught: true);

  void _resolve({required bool caught}) {
    if (_resolved) return;
    _resolved = true;
    _timer?.cancel();
    final appState = context.read<AppState>();
    if (caught) {
      appState.catchCow(widget.spawn);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CatchSuccessScreen()),
      );
    } else {
      appState.missCow(widget.spawn);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CatchMissScreen()),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final camera = _cameraController;
    final appState = context.watch<AppState>();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (camera != null && camera.value.isInitialized)
            CameraPreview(camera)
          else
            const Image(
              image: AssetImage('assets/images/fallback_field.jpeg'),
              fit: BoxFit.cover,
            ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: 0.25),
                  ),
                ),
              ],
            ),
          ),
          const Center(
            child: Image(image: AssetImage('assets/images/cow_photo.png'), width: 200),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NitrogenHud(nitrogen: appState.nitrogen),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text('$_cowName  ·  wild cow',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3FA34D),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('0:0$_secondsLeft',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3FA34D),
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(28),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: _catchIt,
                  child: const Text('CATCH\nIT', textAlign: TextAlign.center),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

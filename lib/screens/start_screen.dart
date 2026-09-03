import 'package:flutter/material.dart';

import 'how_to_play_screen.dart';
import 'shared_widgets.dart';

const _orange = Color(0xFFE8720B);
const _green = Color(0xFF1E8A56);
const _cream = Color(0xFFFBF3D9);
const _sky = Color(0xFF4FC3E8);

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _sky,
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          // Sun tucked into the top-right corner, clear of the title.
          const Positioned(top: -90, right: -90, child: _Sun()),
          const Positioned(top: 150, left: 20, child: _Cloud(size: 100)),
          const Positioned(top: 320, right: 24, child: _Cloud(size: 80)),
          const Hill(color: _green, height: 440),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  // Extra bottom padding absorbs the rotated box's visual
                  // overflow so it doesn't bleed into the subtitle below.
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Transform.rotate(
                      angle: -0.08,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        decoration: BoxDecoration(color: _cream, borderRadius: BorderRadius.circular(10)),
                        child: const Text(
                          'MOO-VE IT!',
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: _orange),
                        ),
                      ),
                    ),
                  ),
                  const Text('Keep your farm alive. Mind your nitrogen.',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  const Spacer(flex: 2),
                  const Image(image: AssetImage('assets/images/cow_logo.png'), width: 260),
                  const Spacer(flex: 3),
                  TextButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const HowToPlayScreen()),
                    ),
                    child: const Text('PLAY',
                        style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Sun extends StatelessWidget {
  const _Sun();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (var i = 0; i < 8; i++)
            Transform.rotate(
              angle: i * 3.14159 / 4,
              child: Container(
                margin: const EdgeInsets.only(bottom: 150),
                width: 16,
                height: 34,
                decoration: BoxDecoration(color: const Color(0xFFF4A15D), borderRadius: BorderRadius.circular(4)),
              ),
            ),
          Container(
            width: 110,
            height: 110,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFD93B)),
          ),
        ],
      ),
    );
  }
}

class _Cloud extends StatelessWidget {
  final double size;
  const _Cloud({required this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.cloud, size: size, color: Colors.white);
  }
}

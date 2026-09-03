import 'dart:math';

import 'package:flutter/material.dart';

import 'shared_widgets.dart';

const _confettiColors = [Colors.white, Color(0xFFF6D745), Color(0xFF49B8E0)];

class CatchSuccessScreen extends StatelessWidget {
  const CatchSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random(1);
    return Scaffold(
      backgroundColor: const Color(0xFF1E8A56),
      body: Stack(
        fit: StackFit.expand,
        children: [
          for (var i = 0; i < 8; i++)
            Positioned(
              left: random.nextDouble() * 340,
              top: 80 + random.nextDouble() * 420,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _confettiColors[i % _confettiColors.length],
                ),
              ),
            ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Cow caught!',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 16),
                  const Image(image: AssetImage('assets/images/cow_photo.png'), width: 140),
                  const SizedBox(height: 24),
                  const Pill(
                    text: '+50 coins',
                    background: Color(0xFFF2A93B),
                    icon: CircleAvatar(radius: 8, backgroundColor: Colors.deepOrange),
                  ),
                  const SizedBox(height: 8),
                  const Text('Herd +1 · Nitrogen +5', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 40),
                  RoundButton(
                    label: 'Back to the map',
                    textColor: const Color(0xFF1E8A56),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

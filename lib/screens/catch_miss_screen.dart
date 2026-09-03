import 'package:flutter/material.dart';

import 'shared_widgets.dart';

class CatchMissScreen extends StatelessWidget {
  const CatchMissScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF3F5),
      body: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          // Big green hill covering the bottom ~45% of the screen.
          Positioned(
            left: -60,
            right: -60,
            bottom: -260,
            child: Container(
              height: 600,
              decoration: const BoxDecoration(color: Color(0xFF1E8A56), borderRadius: BorderRadius.all(Radius.circular(300))),
            ),
          ),
          // Cow straddling the hill's crest, cropped off the right edge.
          const Positioned(
            right: -30,
            bottom: 230,
            child: Image(image: AssetImage('assets/images/cow_photo.png'), width: 220),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  const Text('The cow got away!',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 6),
                  const Text('Moo-ve faster next time.', style: TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: RoundButton(
                  label: 'Back to map',
                  textColor: const Color(0xFF1E8A56),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

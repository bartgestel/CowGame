import 'package:flutter/material.dart';

import 'shared_widgets.dart';

class NitrogenPassedScreen extends StatelessWidget {
  const NitrogenPassedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF57C3EA),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Hill(color: Color(0xFF1E8A56), height: 160),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wb_sunny, size: 90, color: Color(0xFFF6EF6B)),
                  const SizedBox(height: 24),
                  const Text('Cloud cleared!',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 6),
                  const Text('The sky says thank you.', style: TextStyle(color: Colors.black54)),
                  const SizedBox(height: 28),
                  const Pill(text: 'Nitrogen −10', background: Color(0xFF1E8A56)),
                  const SizedBox(height: 64),
                  RoundButton(
                    label: 'Back to the map',
                    textColor: const Color(0xFF1E8A56),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

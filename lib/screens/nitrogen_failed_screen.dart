import 'package:flutter/material.dart';

import 'shared_widgets.dart';

class NitrogenFailedScreen extends StatelessWidget {
  const NitrogenFailedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9691E),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud, size: 90, color: Color(0xFF7A3E12)),
              const SizedBox(height: 24),
              const Text('The cloud grew bigger...',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "It's drifting toward the village. The neighbors are not amused.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 28),
              const Pill(text: 'Nitrogen +15', background: Color(0xFF3B2A1D)),
              const SizedBox(height: 40),
              RoundButton(
                label: 'Back to the map',
                textColor: const Color(0xFFD9691E),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

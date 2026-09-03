import 'package:flutter/material.dart';

import '../app_state.dart';
import 'shared_widgets.dart';

/// Shown once nitrogen crosses [AppState.fineThreshold] — the fine is
/// already applied by the time this screen appears (see map_screen.dart),
/// this just tells the player what happened.
class FineWarningScreen extends StatelessWidget {
  const FineWarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fine = AppState.fineAmount.round();
    return Scaffold(
      backgroundColor: const Color(0xFFE8720B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: const Icon(Icons.priority_high, color: Color(0xFFE8720B), size: 32),
              ),
              const SizedBox(height: 24),
              const Text('MINISTRY OF NITROGEN AFFAIRS',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 0.5)),
              const SizedBox(height: 16),
              const Text('You got fined!',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 12),
              const Text(
                'Your farm let nitrogen climb too high. The government came knocking.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 24),
              Pill(text: '-$fine coins', background: const Color(0xFF3B2A1D)),
              const SizedBox(height: 40),
              RoundButton(
                label: 'Back to farming',
                textColor: const Color(0xFFE8720B),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

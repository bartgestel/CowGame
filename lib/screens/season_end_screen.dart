import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import 'start_screen.dart';

class SeasonEndScreen extends StatelessWidget {
  const SeasonEndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final won = appState.won;
    return Scaffold(
      backgroundColor: won ? const Color(0xFF3FA34D) : const Color(0xFFF2924A),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(won ? '🎉' : '🚜', style: const TextStyle(fontSize: 90)),
              const SizedBox(height: 16),
              Text(
                won ? 'The farm survives the season!' : 'The farm couldn\'t keep up.',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text('Final savings: €${appState.money.round()}',
                  style: const TextStyle(color: Colors.white70)),
              Text('Cows caught: ${appState.cowCount}',
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black87),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const StartScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Play again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import 'map_screen.dart';

const _steps = [
  (
    number: '1',
    color: Color(0xFF1E8A56),
    title: 'Catch cows',
    body: 'Walk around the real world to find cows. Each cow you catch earns coins for your farm.',
  ),
  (
    number: '2',
    color: Color(0xFF49B8E0),
    title: 'Clear nitrogen',
    body: 'More cows means more nitrogen. Shake your phone to blow the clouds away before they pile up.',
  ),
  (
    number: '3',
    color: Color(0xFFE8720B),
    title: "Don't get fined",
    body: 'Let nitrogen climb too high and the government comes knocking. Save enough coins to survive the season.',
  ),
];

class HowToPlayScreen extends StatelessWidget {
  const HowToPlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF3F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              const Text('How to play',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 24),
              for (final step in _steps) _StepCard(step: step),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E8A56),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    context.read<AppState>().reset();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const MapScreen()),
                    );
                  },
                  child: const Text("Got it, let's farm!",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

typedef _Step = ({String number, Color color, String title, String body});

class _StepCard extends StatelessWidget {
  final _Step step;
  const _StepCard({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: step.color,
            child: Text(step.number, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(step.body, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

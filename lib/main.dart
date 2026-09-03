import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'screens/start_screen.dart';

void main() {
  runApp(const CowGameApp());
}

class CowGameApp extends StatelessWidget {
  const CowGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: 'MOO-VE IT!',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: const Color(0xFF3FA34D), useMaterial3: true),
        home: const StartScreen(),
      ),
    );
  }
}

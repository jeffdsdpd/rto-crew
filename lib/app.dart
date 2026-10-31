import 'package:flutter/material.dart';

import 'data/crew_store.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_theme.dart';

class RtoCrewApp extends StatefulWidget {
  const RtoCrewApp({super.key});
  @override
  State<RtoCrewApp> createState() => _RtoCrewAppState();
}

class _RtoCrewAppState extends State<RtoCrewApp> {
  final store = CrewStore();
  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'RTO Crew',
    debugShowCheckedModeBanner: false,
    theme: buildTheme(),
    home: WelcomeScreen(store: store),
  );
}

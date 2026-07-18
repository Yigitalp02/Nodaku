import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const NodakuApp());
}

class NodakuApp extends StatelessWidget {
  const NodakuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nodaku',
      theme: AppTheme.theme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

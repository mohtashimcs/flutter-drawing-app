import 'package:drawing_app/features/draw/draw_screen.dart';
import 'package:drawing_app/features/draw/models/custom_offset.dart';
import 'package:drawing_app/features/draw/models/stroke_model.dart';
import 'package:drawing_app/features/home/home_screen.dart';
import 'package:drawing_app/features/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  //Register Hive Adapters
  Hive.registerAdapter(CustomOffsetAdapter());
  Hive.registerAdapter(StrokeAdapter());

  await Hive.openBox<List<Stroke>>('drawings');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Draw your dreams',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/draw': (context) => const DrawScreen(),
      },
    );
  }
}

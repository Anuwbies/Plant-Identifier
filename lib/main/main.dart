import 'package:flutter/material.dart';
import '../color/app_colors.dart';
import '../pages/welcome/welcome_page.dart';
import 'package:flutter/services.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Identifier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.surfaceA0,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryA0,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryDark10,
            foregroundColor: AppColors.surfaceA80,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: const StadiumBorder(),
            textStyle: const TextStyle(fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      home: const WelcomePage(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whats_new/features/add/add_whats_new_screen.dart';
import 'features/list/whats_new_screen.dart';
import 'features/splash/splash_screen.dart';

void main() {
  runApp(const WhatsNewApp());
}


class WhatsNewApp extends StatelessWidget {
  const WhatsNewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "What's New",

      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.indigo,
          titleTextStyle: GoogleFonts.quicksand(
            color: Colors.white,
            fontSize: 22,
          ),
          // foregroundColor: Colors.white,
        ),
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      initialRoute: SplashScreen.route,
      routes: {
        SplashScreen.route: (_) => const SplashScreen(),
        WhatsNewScreen.route: (_) => const WhatsNewScreen(),
        AddWhatsNewScreen.route: (_) => const AddWhatsNewScreen(),
      },
    );
  }
}

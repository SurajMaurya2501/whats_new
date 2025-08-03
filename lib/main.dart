import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:whats_new/core/utils/notification_service.dart';
import 'package:whats_new/features/add/add_whats_new_screen.dart';
import 'features/list/whats_new_screen.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  final notificationService = NotificationService();

  WidgetsFlutterBinding.ensureInitialized();
  await notificationService.initializeNotifications();
  notificationService.scheduleDailyNotification(
    title: "What's New?",
    description: "Don't forget to log your day's highlight!",
    timeOfDay: TimeOfDay(hour: 23, minute: 06),
  );
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

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {}
}

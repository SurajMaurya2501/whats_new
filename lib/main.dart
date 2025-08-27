import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:whats_new/core/constants/app_typography.dart';
import 'package:whats_new/core/providers/theme_provider.dart';
import 'package:whats_new/core/utils/notification_service.dart';
import 'package:whats_new/features/add/add_whats_new_screen.dart';
import 'features/list/whats_new_screen.dart';
import 'features/splash/splash_screen.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  final notificationService = NotificationService();

  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

  await notificationService.initializeNotifications();
  notificationService.scheduleDailyNotifications(
    title: "What's New?",
    description: "Don't forget to log your day's highlight!",
    times: [
      const TimeOfDay(hour: 9, minute: 0),
      const TimeOfDay(hour: 15, minute: 0),
      const TimeOfDay(hour: 21, minute: 0),
    ],
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const WhatsNewApp(),
    ),
  );
}

class WhatsNewApp extends StatelessWidget {
  const WhatsNewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "What's New",
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
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
      darkTheme: darkTheme,
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

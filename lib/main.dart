import 'package:aquatrack/auth/forgot_password.dart';
import 'package:aquatrack/auth/login.dart';
import 'package:aquatrack/auth/signup.dart';
import 'package:aquatrack/dashboard/current_hydartion.dart';
import 'package:aquatrack/dashboard/dashboard.dart';
import 'package:aquatrack/dashboard/history.dart';
import 'package:aquatrack/dashboard/home.dart';
import 'package:aquatrack/dashboard/settings/pages/notifications.dart';
import 'package:aquatrack/dashboard/settings/settings.dart';
import 'package:aquatrack/firebase_options.dart';
import 'package:aquatrack/onboarding/landing.dart';
import 'package:aquatrack/onboarding/splash_screen.dart';
import 'package:aquatrack/user_info/profile_setup.dart';
import 'package:aquatrack/user_info/water_intake_info.dart';
import 'package:aquatrack/user_info/sleep_schedule.dart';
import 'package:aquatrack/user_info/personal_info.dart';
import 'package:aquatrack/utils/routes.dart';
import 'package:aquatrack/widgets/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class ThemeModel extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;

  ThemeModel() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _mode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void toggleTheme() async {
    _mode = _mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _mode == ThemeMode.dark);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: Consumer<ThemeModel>(builder: (context, themeModel, child) {
          return MaterialApp(
            theme: MyTheme.lightTheme(context), // Use custom light theme
            darkTheme: MyTheme.darkTheme(context), // Use custom dark theme

            themeMode: Provider.of<ThemeModel>(context).mode,
            debugShowCheckedModeBanner: false,
            initialRoute: MyRoutes.splashRoute,
            routes: {
              '/': (context) => SplashScreen(),
              MyRoutes.splashRoute: (context) => const SplashScreen(),
              MyRoutes.landingRoute: (context) => const LandingPage(),
              MyRoutes.signupRoute: (context) => const SignupPage(),
              MyRoutes.loginRoute: (context) => const LoginPage(),
              MyRoutes.dashboardRoute: (context) => DashboardPage(),
              MyRoutes.personalInfoRoute: (context) =>
                  PersonalInfoPage(formKey: GlobalKey<FormState>()),
              MyRoutes.sleepScheduleRoute: (context) =>
                  SleepSchedulePage(formKey: GlobalKey<FormState>()),
              MyRoutes.waterIntakeInfoRoute: (context) =>
                  WaterIntakeInfoPage(formKey: GlobalKey<FormState>()),
              MyRoutes.dashboardRoute: (context) => DashboardPage(),
              MyRoutes.profileSetupRoute: (context) => const ProfileSetupPage(),
              MyRoutes.forgotPasswordRoute: (context) =>
                  const ForgotPasswordPage(),
              MyRoutes.homeRoute: (context) => const HomePage(),
              MyRoutes.settingsRoute: (context) => const SettingsPage(),
              MyRoutes.historyRoute: (context) => const HistoryPage(),
              MyRoutes.currentHydartionRoute: (context) =>
                  const CurrentHydrationPage(),
              MyRoutes.notificationRoute: (context) => const NotificationPage(),
            },
          );
        }));
  }
}

import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/localizations/language_helper.dart';
import 'package:publrealty/localizations/localization_provider.dart';
import 'package:publrealty/providers/authentication_provider.dart';
import 'package:publrealty/providers/liked_properties_provider.dart';
import 'package:publrealty/screens/home_screen.dart';
import 'package:publrealty/screens/map_screen.dart';
import 'package:publrealty/screens/root_screen.dart';
import 'package:publrealty/themes/app_themes.dart';
import 'package:publrealty/themes/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MyApp();
  }
}

ThemeMode defaultThemeMode = ThemeMode.system;
Locale defaultLocale = const Locale('en', 'EN');

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var loadedApp = false;
  var isConnected = true;
  
  @override
  void initState() {
    prepareApp();
    _initConnectivity();
    super.initState();
  }

  Future<void> _initConnectivity() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      isConnected = (connectivityResult != ConnectivityResult.none);
    });

    // Show snackbar if not connected
  if (isConnected) {
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No internet connection'),
      ),
    );
  }
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  void prepareApp() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 10));
    if (prefs.containsKey("appTheme")) {
      final appThemeName = prefs.getString("appTheme") ?? "";
      defaultThemeMode = ThemeMode.values
          .firstWhere((element) => element.name == appThemeName);
    }
    if (prefs.containsKey("appLocale")) {
      final appLocale = prefs.getString("appLocale") ?? "";
      defaultLocale = LanguageHelper().convertLangNameToLocale(appLocale);
    }

    setState(() {
      loadedApp = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!loadedApp || !isConnected) { // Check if app is loaded or not connected
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: 200,
                ),
                const SizedBox(height: 20),
                const Text('Loading...'),
                const SizedBox(height: 20),
                const CircularProgressIndicator.adaptive(),
                const SizedBox(height: 20),
                const Text(
                'Checking network...',
                  style: TextStyle(fontSize: 20),
                  ), // Progress bar
              ],
            ),
          ),
        ),
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider()),
        ChangeNotifierProvider<LocalizationProvider>(
            create: (context) => LocalizationProvider()),
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider<LikedPropertiesProvider>(
            create: (context) => LikedPropertiesProvider())
      ],
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final localizationProvider = Provider.of<LocalizationProvider>(context);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates(),
          supportedLocales: AppLocalizations.supportedLocales(),
          locale: localizationProvider.locale,
          themeMode: themeProvider.themeMode,
          theme: AppThemes.customTheme,
          darkTheme: AppThemes.lightTheme,
          home: RootScreen(),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}

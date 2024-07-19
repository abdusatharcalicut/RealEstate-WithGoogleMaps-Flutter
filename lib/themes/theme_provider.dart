import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publrealty/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static ThemeProvider of(BuildContext context) =>
      Provider.of<ThemeProvider>(context, listen: false);

  ThemeMode themeMode = defaultThemeMode;

  //bool get isDarkMode => themeMode == ThemeMode.dark;

  Future<void> changeTheme(ThemeMode themeMode) async {
    this.themeMode = themeMode;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString("appTheme", themeMode.name);

    notifyListeners();
    return Future.value();
  }
}

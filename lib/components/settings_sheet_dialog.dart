import 'package:flutter/material.dart';
import 'package:publrealty/extensions/global_extensions.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/localizations/localization_provider.dart';
import 'package:publrealty/themes/app_themes.dart';
import 'package:publrealty/themes/theme_provider.dart';

class SettingsSheetDialog extends StatefulWidget {
  const SettingsSheetDialog({Key? key}) : super(key: key);

  @override
  State<SettingsSheetDialog> createState() => _SettingsSheetDialogState();
}

class _SettingsSheetDialogState extends State<SettingsSheetDialog> {
  final languages = ["English", "Arabic", "Turkish"];

  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.of(context);
    final localization = AppLocalizations.of(context);
    final localizationProvider = LocalizationProvider.of(context);
    final themeProvider = ThemeProvider.of(context);

    return Container(
      height: 300,
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              localization.theme,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            LayoutBuilder(
              builder: (context, constraints) {
                return ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) async {
                    try {
                      themeProvider.changeTheme(index == 0
                          ? ThemeMode.system
                          : index == 1
                              ? ThemeMode.dark
                              : ThemeMode.light);
                      setState(() {});
                    } catch (e) {
                      handleException(e);
                    }
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  selectedColor: Colors.white,
                  borderWidth: 0,
                  fillColor: theme.primaryColor,
                  color: theme.customBlackColor,
                  isSelected: [
                    themeProvider.themeMode == ThemeMode.system,
                    themeProvider.themeMode == ThemeMode.dark,
                    themeProvider.themeMode == ThemeMode.light,
                  ],
                  constraints:
                      BoxConstraints.expand(width: constraints.maxWidth / 3),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Text(localization.system),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Text(localization.light),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Text(localization.dark),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              localization.locale,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            LayoutBuilder(
              builder: (context, constraints) {
                return ToggleButtons(
                  direction: Axis.horizontal,
                  onPressed: (int index) {
                    final selectedLanguage = languages[index];
                    localizationProvider.changeLocale(selectedLanguage);
                    setState(() {});
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderWidth: 0,
                  selectedColor: Colors.white,
                  fillColor: theme.primaryColor,
                  color: theme.customBlackColor,
                  isSelected: [
                    localizationProvider.defineCurrentLanguage(context) ==
                        languages[0],
                    localizationProvider.defineCurrentLanguage(context) ==
                        languages[1],
                    localizationProvider.defineCurrentLanguage(context) ==
                        languages[2],
                  ],
                  constraints:
                      BoxConstraints.expand(width: constraints.maxWidth / 3),
                  children: languages
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Text(e),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:publrealty/components/property_item_row_view.dart';
import 'package:publrealty/components/publ_app_bar.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/providers/liked_properties_provider.dart';
import 'package:publrealty/screens/property_detail_screen.dart';
import 'package:publrealty/themes/app_themes.dart';

class LikedPropertiesScreen extends StatefulWidget {
  const LikedPropertiesScreen({Key? key}) : super(key: key);

  @override
  State<LikedPropertiesScreen> createState() => _LikedPropertiesScreenState();

  static void navigate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LikedPropertiesScreen(),
      ),
    );
  }
}

class _LikedPropertiesScreenState extends State<LikedPropertiesScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.of(context);
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: PublAppBar(
        title: localization.favoriteProperties,
        theme: theme,
      ),
      body: Consumer<LikedPropertiesProvider>(
        builder: (context, value, child) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final item = value.properties[index];

              return PropertyItemRowView(
                model: item,
                isLiked: true,
                onItemClick: (model) {
                  PropertyDetailScreen.navigate(context, model);
                },
              );
            },
            itemCount: value.properties.length,
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:publrealty/components/publ_app_bar.dart';
import 'package:publrealty/themes/app_themes.dart';

class WebViewInformationScreenScreen extends StatelessWidget {
  static void navigate(
    BuildContext context, {
    required String title,
    required String htmlContent,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebViewInformationScreenScreen(
            title: title, htmlContent: htmlContent),
      ),
    );
  }

  const WebViewInformationScreenScreen({
    Key? key,
    required this.title,
    required this.htmlContent,
  }) : super(key: key);

  final String title;
  final String htmlContent;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.of(context);
    return Scaffold(
      appBar: PublAppBar(
        title: title,
        theme: theme,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Html(data: htmlContent),
      ),
    );
  }
}

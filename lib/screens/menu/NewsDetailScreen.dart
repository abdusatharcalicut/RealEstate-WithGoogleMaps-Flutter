import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:publrealty/components/publ_app_bar.dart';
import 'package:publrealty/constants/application_constants.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/models/news_model.dart';
import 'package:publrealty/service/ApiService.dart';
import 'package:publrealty/themes/app_themes.dart';

class NewsDetailScreen extends StatefulWidget {
  const NewsDetailScreen({Key? key, required this.model}) : super(key: key);

  final NewsModel model;

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();

  static void navigate(BuildContext context, {required NewsModel model}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewsDetailScreen(model: model),
      ),
    );
  }
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.of(context);
    final localization = AppLocalizations.of(context);

    var date = "";
    if (widget.model.createdAt != null) {
      date = DateFormat(ApplicationConstants.viewDateFormat)
          .format(widget.model.createdAt!);
    }

    return Scaffold(
      appBar: PublAppBar(
        title: localization.newsDetail,
        theme: theme,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
                      imageUrl:
              "${ApiService.imagesUrl}${widget.model.imageName ?? ""}",
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                date,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: theme.primaryColor),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.model.title ?? "",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Html(data: widget.model.content ?? ""),
            )
          ],
        ),
      ),
    );
  }
}

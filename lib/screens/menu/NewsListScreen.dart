import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:publrealty/components/publ_app_bar.dart';
import 'package:publrealty/constants/application_constants.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/models/news_model.dart';
import 'package:publrealty/screens/menu/NewsDetailScreen.dart';
import 'package:publrealty/service/ApiService.dart';
import 'package:publrealty/themes/app_themes.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({Key? key}) : super(key: key);

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();

  static void navigate(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NewsListScreen(),
      ),
    );
  }
}

class _NewsListScreenState extends State<NewsListScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.of(context);
    final localization = AppLocalizations.of(context);

    return Scaffold(
      appBar: PublAppBar(
        title: localization.news,
        theme: theme,
      ),
      body: FutureBuilder<List<NewsModel>>(
        future: ApiService.getNews(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemBuilder: (context, index) {
                final item = snapshot.data?[index];
                var date = "";
                if (item != null && item.createdAt != null) {
                  date = DateFormat(ApplicationConstants.viewDateFormat)
                      .format(item.createdAt!);
                }

                return GestureDetector(
                  onTap: () {
                    if (item != null) {
                      NewsDetailScreen.navigate(context, model: item);
                    }
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          boxShadow: const [BoxShadow()],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              height: 200,
                              child: CachedNetworkImage(
                                imageUrl:
                                "${ApiService.imagesUrl}${item?.imageName ?? ""}",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    date,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: theme.primaryColor),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item?.title ?? "",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              itemCount: snapshot.data?.length ?? 0,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

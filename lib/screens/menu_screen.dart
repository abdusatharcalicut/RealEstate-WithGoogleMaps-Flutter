import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:publrealty/components/publ_app_bar.dart';
import 'package:publrealty/components/settings_sheet_dialog.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/models/app_settings_model.dart';
import 'package:publrealty/providers/authentication_provider.dart';
import 'package:publrealty/screens/menu/NewsListScreen.dart';
import 'package:publrealty/screens/menu/WebViewInformationScreenScreen.dart';
import 'package:publrealty/service/ApiService.dart';
import 'package:publrealty/themes/app_themes.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.of(context);
    final localization = AppLocalizations.of(context);
    final authentication = AuthenticationProvider.of(context, listen: true);

    return Scaffold(
      // appBar: PublAppBar(title: localization.menu, theme: theme),
      appBar: AppBar(
        // leading: Icon(Icons.menu),
        leading: Padding(
            padding: const EdgeInsets.all(8.0), // Adjust padding as needed
            child: Image.asset(
              'assets/images/logo.png', // Path to your logo image
              width: 40, // Adjust the width as needed
              height: 40, // Adjust the height as needed
            ),
          ),
          title: Text('Menu'),
        ),
      body: Center(child:FutureBuilder<AppSettingsModel>(
        future: ApiService.getAppSettings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator.adaptive(); // Show a platform-adaptive loading indicator while waiting for data
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          final model = snapshot.data;
          return ListView(
              children: [
                buildListTile(
                  title: localization.news,
                  iconData: FontAwesomeIcons.newspaper,
                  onTap: () {
                    NewsListScreen.navigate(context);
                  },
                ),
                const Divider(height: 1),
                buildListTile(
                  title: localization.facebook,
                  iconData: FontAwesomeIcons.facebookSquare,
                  onTap: () => _launchUrl(model?.facebookUrl),
                ),
                const Divider(height: 1),
                buildListTile(
                  title: localization.twitter,
                  iconData: FontAwesomeIcons.twitter,
                  onTap: () => _launchUrl(model?.twitterUrl),
                ),
                const Divider(height: 1),
                buildListTile(
                  title: localization.youtube,
                  iconData: FontAwesomeIcons.youtube,
                  onTap: () => _launchUrl(model?.youtubeUrl),
                ),
                const Divider(height: 1),
                buildListTile(
                  title: localization.instagram,
                  iconData: FontAwesomeIcons.instagram,
                  onTap: () => _launchUrl(model?.instagramUrl),
                ),
                const Divider(height: 1),
                buildListTile(
                  title: localization.aboutUs,
                  iconData: Icons.business,
                  onTap: () => WebViewInformationScreenScreen.navigate(
                    context,
                    title: localization.aboutUs,
                    htmlContent: model?.aboutUs ?? "",
                  ),
                ),
                const Divider(height: 1),
                buildListTile(
                    title: localization.contactUs,
                    iconData: Icons.mail,
                    onTap: () {
                      if (model?.email?.isNotEmpty == true) {
                        _launchUrl("mailto:${model!.email!}");
                      }
                    }),
                const Divider(height: 1),
                buildListTile(
                  title: localization.privacyPolicy,
                  iconData: Icons.privacy_tip,
                  onTap: () => WebViewInformationScreenScreen.navigate(
                    context,
                    title: localization.privacyPolicy,
                    htmlContent: model?.privacyPolicy ?? "",
                  ),
                ),
                const Divider(height: 1),
                buildListTile(
                  title: localization.settings,
                  iconData: Icons.settings,
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) =>
                          const SettingsSheetDialog(),
                    );
                  },
                ),
                const Divider(height: 1),
                if (authentication.isLoggedIn)
                  buildListTile(
                    title: localization.logout,
                    iconData: Icons.logout,
                    onTap: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: Text(localization.logoutAlertTitle),
                          content: Text(localization.logoutAlertDesc),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: Text(localization.noUpper),
                            ),
                            TextButton(
                              onPressed: () {
                                authentication.logout();
                                Navigator.pop(context, 'Cancel');
                              },
                              child: Text(localization.yesUpper),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            );
          }
          return Center(
            child: Text(localization.noDataErrorMessage),
          );
        },
      ),
      ),
    );
  }

  ListTile buildListTile({
    required String title,
    required IconData iconData,
    GestureTapCallback? onTap,
  }) {
    final theme = AppThemes.of(context);
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontSize: 17),
      ),
      leading: SizedBox(
        width: 24,
        child: Center(
          child: FaIcon(
            iconData,
          ),
        ),
      ),
      minLeadingWidth: 0,
      minVerticalPadding: 0,
      iconColor: theme.customLabelColor.withOpacity(0.6),
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      trailing: const Icon(Icons.chevron_right_outlined),
      onTap: onTap,
    );
  }

  Future<void> _launchUrl(String? url) async {
    if (url == null || url.isEmpty == true) {
      return;
    }
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }
}

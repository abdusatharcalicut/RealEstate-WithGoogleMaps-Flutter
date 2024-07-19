import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:publrealty/extensions/global_extensions.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/providers/authentication_provider.dart';
import 'package:publrealty/screens/authentication/authentication_root_screen.dart';
import 'package:publrealty/screens/liked_properties_screen.dart';
import 'package:publrealty/service/ApiService.dart';
import 'package:publrealty/themes/app_themes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.of(context);
    final localization = AppLocalizations.of(context);
    final authentication = AuthenticationProvider.of(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localization.profile,
          style: TextStyle(color: theme.customLabelColor),
        ),
        elevation: 0.3,
        backgroundColor: theme.cardColor,
      ),
      body: authentication.isLoggedIn == false
          ? const SizedBox.shrink()
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: theme.dividerColor,
                          backgroundImage: CachedNetworkImageProvider(
                            "${ApiService.imagesUrl}${authentication.user!.imageName!}",
                          ),
                        ),
                        Positioned.directional(
                          textDirection: Directionality.of(context),
                          bottom: 0,
                          end: 8,
                          child: GestureDetector(
                            onTap: () async {
                              try {
                                XFile? pickedFile =
                                    await ImagePicker().pickImage(
                                  source: ImageSource.gallery,
                                  maxWidth: 500,
                                  maxHeight: 500,
                                );
                                if (pickedFile != null) {
                                  showLoading();
                                  final imageName =
                                      await ApiService.uploadProfileImage(
                                          pickedFile);
                                  authentication.user?.imageName = imageName;
                                  authentication
                                      .updateUserModelInLocalStorage();
                                  setState(() {});
                                }
                              } catch (e) {
                                handleException(e);
                              } finally {
                                hideLoading();
                              }
                            },
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: theme.cardColor,
                              child: Icon(
                                Icons.change_circle_sharp,
                                size: 28,
                                color: theme.primaryColorDark,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 42),
                    ListTile(
                      onTap: () {
                        if (!AuthenticationProvider.of(context).isLoggedIn) {
                          AuthenticationRootScreen.navigate(context);
                          return;
                        }
                        LikedPropertiesScreen.navigate(context);
                      },
                      title: Text(localization.favoriteProperties),
                      subtitle: Text(localization.likedProperties),
                      leading: const FaIcon(
                        FontAwesomeIcons.solidHeart,
                        color: Color(0xFFEB5757),
                      ),
                      minLeadingWidth: 0,
                      minVerticalPadding: 0,
                      trailing: const Icon(Icons.chevron_right_outlined),
                    ),
                    const Divider(height: 4),
                    ListTile(
                      onTap: () => print("object"),
                      title: Text(localization.notifications),
                      subtitle: Text(localization.showAllNotifications),
                      leading: const FaIcon(
                        FontAwesomeIcons.solidBell,
                        color: Color(0xFFF2994A),
                      ),
                      minLeadingWidth: 0,
                      minVerticalPadding: 0,
                      trailing: const Icon(Icons.chevron_right_outlined),
                    ),
                    const Divider(height: 4),
                    ListTile(
                      onTap: () => print("object"),
                      title: const Text("Menu 1"),
                      subtitle: const Text("short desc"),
                      leading: FaIcon(
                        FontAwesomeIcons.egg,
                        color: theme.primaryColor,
                      ),
                      minLeadingWidth: 0,
                      minVerticalPadding: 0,
                      trailing: const Icon(Icons.chevron_right_outlined),
                    ),
                    const Divider(height: 4),
                    ListTile(
                      onTap: () => print("object"),
                      title: const Text("Menu 2"),
                      subtitle: const Text("short desc"),
                      leading: const FaIcon(
                        FontAwesomeIcons.egg,
                        color: Color(0xFF2D9CDB),
                      ),
                      minLeadingWidth: 0,
                      minVerticalPadding: 0,
                      trailing: const Icon(Icons.chevron_right_outlined),
                    ),
                    const Divider(height: 4),
                    ListTile(
                      onTap: () => print("object"),
                      title: const Text("Menu 3"),
                      subtitle: const Text("short desc"),
                      leading: const FaIcon(
                        FontAwesomeIcons.egg,
                        color: Color(0xFF27AE60),
                      ),
                      minLeadingWidth: 0,
                      minVerticalPadding: 0,
                      trailing: const Icon(Icons.chevron_right_outlined),
                    ),
                    const Divider(height: 4),
                  ],
                ),
              ),
            ),
    );
  }
}

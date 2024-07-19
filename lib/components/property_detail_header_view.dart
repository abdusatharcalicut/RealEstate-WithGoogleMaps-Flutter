import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:publrealty/components/dots_indicator.dart';
import 'package:publrealty/components/like_button.dart';
import 'package:publrealty/extensions/global_extensions.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/models/property_model.dart';
import 'package:publrealty/providers/authentication_provider.dart';
import 'package:publrealty/providers/liked_properties_provider.dart';
import 'package:publrealty/screens/authentication/authentication_root_screen.dart';
import 'package:publrealty/screens/photo_preview_screen.dart';
import 'package:publrealty/service/ApiService.dart';
import 'package:publrealty/themes/app_themes.dart';

class PropertyDetailHeaderView extends StatefulWidget {
  const PropertyDetailHeaderView({Key? key, required this.model})
      : super(key: key);

  final PropertyModel model;

  @override
  State<PropertyDetailHeaderView> createState() =>
      _PropertyDetailHeaderViewState();
}

class _PropertyDetailHeaderViewState extends State<PropertyDetailHeaderView> {
  final _controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.of(context);
    final localization = AppLocalizations.of(context);
    final likedPropertiesProvider =
        LikedPropertiesProvider.of(context, listen: true);

    return SizedBox(
      height: 340,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: PageView.builder(
              controller: _controller,
              itemBuilder: (context, index) {
                final item = widget.model.imageNames!.split(",")[index];
                return GestureDetector(
                  onTap: () {
                    PhotoPreviewScreen.navigate(context, item);
                  },
                  child: CachedNetworkImage(
                      imageUrl:
                    ApiService.imagesUrl + item,
                    fit: BoxFit.cover,
                  ),
                );
              },
              itemCount: widget.model.imageNames?.split(",").length ?? 0,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: theme.primaryColor,
                    //     borderRadius: BorderRadius.circular(4),
                    //   ),
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 8, vertical: 4),
                    //   child: Text(
                    //     widget.model.propertyType?.name?.toLowerCase() == "rent"
                    //         ? localization.forRentUpper
                    //         : localization.forSaleUpper,
                    //     style: const TextStyle(
                    //         fontSize: 10,
                    //         fontWeight: FontWeight.w500,
                    //         color: Colors.white),
                    //   ),
                    // ),
                    // const SizedBox(height: 8),
                    Text(
                      widget.model.title ?? "",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          widget.model.city?.name ?? "",
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.space_dashboard,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          "${widget.model.size}m²",
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: DotsIndicator(
                        controller: _controller,
                        itemCount:
                            widget.model.imageNames?.split(",").length ?? 0,
                        onPageSelected: (int page) {
                          _controller.animateToPage(
                            page,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned.directional(
            textDirection: Directionality.of(context),
            end: 12,
            bottom: -16,
            child: LikeButton(
              isLiked: likedPropertiesProvider.containsInList(widget.model),
              onTap: () async {
                try {
                  if (!AuthenticationProvider.of(context).isLoggedIn) {
                    AuthenticationRootScreen.navigate(context);
                    return;
                  }
                  if (widget.model.id != null) {
                    await likedPropertiesProvider.likeProperty(widget.model.id!,
                        !likedPropertiesProvider.containsInList(widget.model));
                  }
                } catch (e) {
                  handleException(e);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

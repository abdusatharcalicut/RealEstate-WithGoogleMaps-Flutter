import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:publrealty/components/dots_indicator.dart';
import 'package:publrealty/components/like_button.dart';
import 'package:publrealty/extensions/convert_extensions.dart';
import 'package:publrealty/extensions/global_extensions.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/models/property_model.dart';
import 'package:publrealty/providers/authentication_provider.dart';
import 'package:publrealty/providers/liked_properties_provider.dart';
import 'package:publrealty/screens/authentication/authentication_root_screen.dart';
import 'package:publrealty/service/ApiService.dart';
import 'package:publrealty/themes/app_themes.dart';

class PropertyItemRowView extends StatefulWidget {
  const PropertyItemRowView(
      {Key? key, required this.model, this.onItemClick, required this.isLiked})
      : super(key: key);

  final PropertyModel model;
  final Function(PropertyModel model)? onItemClick;
  final bool isLiked;

  @override
  State<PropertyItemRowView> createState() => _PropertyItemRowViewState();
}

class _PropertyItemRowViewState extends State<PropertyItemRowView> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onClickLike() async {
    if (widget.model.id == null) {
      return;
    }
    if (!AuthenticationProvider.of(context).isLoggedIn) {
      AuthenticationRootScreen.navigate(context);
      return;
    }
    try {
      await LikedPropertiesProvider.of(context)
          .likeProperty(widget.model.id!, !widget.isLiked);
    } catch (e) {
      handleException(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.of(context);
    final localization = AppLocalizations.of(context);

    final price = widget.model.price?.toMoney(widget.model.currency ?? "");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          if (widget.onItemClick != null) widget.onItemClick!(widget.model);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              color: theme.cardColor,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildPagingView(widget.model),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              price ?? "",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: theme.customLabelColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Opacity(
                              opacity: 0.5,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on, size: 14),
                                  const SizedBox(width: 2),
                                  Expanded(
                                    child: Text(
                                      widget.model.address ?? "",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: theme.customLabelColor,
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.space_dashboard, size: 14),
                                  const SizedBox(width: 2),
                                  Text(
                                    "${widget.model.size}m²",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: theme.customLabelColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Divider(),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                buildPropertyFeatureItem(
                                  FontAwesomeIcons.car,
                                  localization.parking//parkingWithCount(
                                  //   widget.model.parkingCount ?? "",
                                  // ),
                                ),
                                const Spacer(),
                                buildPropertyFeatureItem(
                                  FontAwesomeIcons.temperatureArrowDown,
                                  localization.airConditioned//bathWithCount(
                                  //   widget.model.bathRoomCount ?? "",
                                  // ),
                                ),
                                const Spacer(),
                                buildPropertyFeatureItem(
                                  FontAwesomeIcons.wifi,
                                  localization.wifi//bedWithCount(
                                  //   widget.model.bedRoomCount ?? "",
                                  // ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned.directional(
                    textDirection: Directionality.of(context),
                    end: 12,
                    top: 166,
                    child: LikeButton(
                      isLiked: widget.isLiked,
                      onTap: () {
                        onClickLike();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPagingView(PropertyModel model) {
    final theme = AppThemes.of(context);
    final localization = AppLocalizations.of(context);

    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemBuilder: (context, index) {
              final imageName = model.imageNames!.split(",")[index];
              return CachedNetworkImage(
                      imageUrl:
                ApiService.imagesUrl + imageName,
                fit: BoxFit.cover,
              );
            },
            itemCount: model.imageNames?.split(",").length ?? 0,
          ),
          // Positioned.directional(
          //   textDirection: Directionality.of(context),
          //   start: 16,
          //   top: 16,
          //   child: Container(
          //     decoration: BoxDecoration(
          //         color: theme.primaryColor,
          //         borderRadius: BorderRadius.circular(4)),
          //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          //     child: Text(
          //       model.propertyType?.name?.toLowerCase() == "rent"
          //           ? localization.forRentUpper
          //           : localization.forSaleUpper,
          //       style: const TextStyle(
          //           fontSize: 11,
          //           fontWeight: FontWeight.w500,
          //           color: Colors.white),
          //     ),
          //   ),
          // ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            child: DotsIndicator(
              controller: _controller,
              itemCount: model.imageNames?.split(",").length ?? 0,
              onPageSelected: (value) {},
            ),
          )
        ],
      ),
    );
  }

  Widget buildPropertyFeatureItem(IconData icon, String title) {
    final theme = AppThemes.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(icon, size: 17, color: theme.primaryColor),
        const SizedBox(
          width: 12,
        ),
        Text(
          title,
          style: TextStyle(
              color: theme.primaryColor,
              fontWeight: FontWeight.w500,
              fontSize: 13),
        )
      ],
    );
  }
}

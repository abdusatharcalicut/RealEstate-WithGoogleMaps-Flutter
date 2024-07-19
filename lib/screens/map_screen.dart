import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:publrealty/components/publ_app_bar.dart';
import 'package:publrealty/extensions/convert_extensions.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/models/property_model.dart';
import 'package:publrealty/screens/property_detail_screen.dart';
import 'package:publrealty/service/ApiService.dart';
import 'package:publrealty/themes/app_themes.dart';

class PropertiesMapScreen extends StatefulWidget {
  const PropertiesMapScreen({
    super.key,
    required this.properties,
  });

  final List<PropertyModel> properties;

  @override
  State<PropertiesMapScreen> createState() => _PropertiesMapScreenState();
}

class _PropertiesMapScreenState extends State<PropertiesMapScreen> {
  late GoogleMapController mapController;
  late final PageController _pageController = PageController();

  LatLng _center = const LatLng(0.0, 0.0);

  @override
  void initState() {
    if (widget.properties.isNotEmpty) {
      final lat = double.tryParse(widget.properties.first.latitude ?? "");
      final long = double.tryParse(widget.properties.first.longitude ?? "");
      if (lat != null && long != null) {
        _center = LatLng(lat, long);
      }
    }
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = AppThemes.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Adjust padding as needed
          child: Image.asset(
            'assets/images/logo.png', // Path to your logo image
            width: 40, // Adjust the width as needed
            height: 40, // Adjust the height as needed
          ),
        ),
        title: Text('Map'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            markers: widget.properties.map((item) {
              final lat = double.tryParse(item.latitude ?? "");
              final long = double.tryParse(item.longitude ?? "");

              return Marker(
                markerId: MarkerId("${item.id}"),
                position: LatLng(
                  lat ?? 0,
                  long ?? 0,
                ),
                onTap: () {
                  final index = widget.properties.indexOf(item);
                  _pageController.jumpToPage(index);
                },
              );
            }).toSet(),
          ),
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: true,
              child: SizedBox(
                height: 142,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (value) {
                    final item = widget.properties[value];
                    final lat = double.tryParse(item.latitude ?? "");
                    final long = double.tryParse(item.longitude ?? "");
                    if (lat != null && long != null) {
                      setState(() {
                        mapController.animateCamera(CameraUpdate.newLatLngZoom(
                            LatLng(lat, long), 11.0));
                      });
                    }
                  },
                  children: widget.properties
                      .map(
                        (model) => InkWell(
                          onTap: () {
                            PropertyDetailScreen.navigate(context, model);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                      "${ApiService.imagesUrl}${model.imageNames?.split(",").first ?? ""}",
                                      width: 110,
                                      height: 110,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          model.address ?? "",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                            color: theme.customLabelColor
                                                .withOpacity(0.4),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          model.price?.toMoney(
                                                  model.currency ?? "") ??
                                              "",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: theme.primaryColorDark,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 16),
                                        Row(
                                          children: [
                                            buildPropertyFeatureItem(
                                              FontAwesomeIcons.bed,
                                              model.bedRoomCount,
                                            ),
                                            const SizedBox(width: 16),
                                            buildPropertyFeatureItem(
                                              FontAwesomeIcons.bath,
                                              model.bathRoomCount,
                                            ),
                                            const SizedBox(width: 16),
                                            buildPropertyFeatureItem(
                                              FontAwesomeIcons.car,
                                              model.parkingCount,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildPropertyFeatureItem(IconData icon, String? title) {
    final theme = AppThemes.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(icon, size: 16, color: theme.customBlackColor.withOpacity(0.4)),
        const SizedBox(
          width: 8,
        ),
        Text(
          title ?? "-",
          style: TextStyle(
              color: theme.customBlackColor.withOpacity(0.4),
              fontWeight: FontWeight.w500,
              fontSize: 12),
        )
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as map;
import 'package:publrealty/components/app_bar_with_opacity_view.dart';
import 'package:publrealty/components/property_detail_header_view.dart';
import 'package:publrealty/components/section_header.dart';
import 'package:publrealty/extensions/convert_extensions.dart';
import 'package:publrealty/helpers/maps_launcher.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/models/property_model.dart';
import 'package:publrealty/screens/photo_preview_screen.dart';
import 'package:publrealty/service/ApiService.dart';
import 'package:publrealty/themes/app_themes.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailScreen extends StatefulWidget {
  const PropertyDetailScreen({Key? key, required this.model}) : super(key: key);

  final PropertyModel model;

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();

  static void navigate(BuildContext context, PropertyModel model) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PropertyDetailScreen(model: model),
      ),
    );
  }
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  late ScrollController _controller;
  late map.GoogleMapController mapController;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = AppThemes.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWithOpacityView(
        title: widget.model.title ?? "",
        controller: _controller,
      ),
      body: SafeArea(
        top: false,
        bottom: true,
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          controller: _controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PropertyDetailHeaderView(model: widget.model),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      localization.price,
                      style: TextStyle(
                        color: theme.primaryColorDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      widget.model.price
                              ?.toMoney(widget.model.currency ?? "") ??
                          "",
                      style: TextStyle(
                        color: theme.customLabelColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.facilities,
                      style: TextStyle(
                        color: theme.primaryColorDark,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        buildPropertyFeatureItem(
                          FontAwesomeIcons.car,
                          localization.parkingWithCount(
                            widget.model.parkingCount ?? "",
                          ),
                        ),
                        const Spacer(),
                        buildPropertyFeatureItem(
                            FontAwesomeIcons.temperatureArrowDown,
                            localization.airConditioned
                          // .bathWithCount(widget.model.bathRoomCount ?? ""),
                        ),
                        const Spacer(),
                        buildPropertyFeatureItem(
                            FontAwesomeIcons.wifi,
                            localization.wifi//.kitchenWithCount(widget.model.kitchenRoomCount ?? ""),
                        ),
                        // const Spacer(),
                        // buildPropertyFeatureItem(
                        //   FontAwesomeIcons.car,
                        //   localization
                        //       .parkingWithCount(widget.model.parkingCount ?? ""),
                        // )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],

                ),
              ),
              const Divider(),
              const SizedBox(height: 8),
              SectionHeader(
                title: localization.description,
                paddingVertical: 0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Html(data: widget.model.description),
              ),
              const Divider(),
              SectionHeader(title: localization.photos),
              const SizedBox(height: 4),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemBuilder: (context, index) {
                    final item = widget.model.imageNames!.split(",")[index];
                    return GestureDetector(
                      onTap: () {
                        PhotoPreviewScreen.navigate(context, item);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 1,
                              offset: const Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl:
                            ApiService.imagesUrl + item,
                            fit: BoxFit.cover,
                            width: 140,
                            height: 100,
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: widget.model.imageNames?.split(",").length ?? 0,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              SectionHeader(title: localization.propertyDetails,
                paddingVertical: 0,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Html(data: widget.model.description),
              ),
              // for (final String item
              //     in (widget.model.additionalFeatures?.split(",") ?? []))
              //   Padding(
              //     padding:
              //         const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              //     child: Row(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: [
              //         FaIcon(
              //           Icons.check_circle_outline_rounded,
              //           size: 22,
              //           color: theme.primaryColorDark,
              //         ),
              //         const SizedBox(width: 12),
              //         Expanded(
              //           child: Text(
              //             item.trim(),
              //             style: TextStyle(
              //               color: theme.customLabelColor,
              //               fontSize: 15,
              //             ),
              //           ),
              //         )
              //       ],
              //     ),
              //   ),
              const SizedBox(height: 12.0),
              const Divider(),
              // if (widget.model.latitude != null &&
              //     widget.model.longitude != null)
              //   Column(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       SectionHeader(
              //         title: localization.location,
              //         rightTitle: localization.goToMap,
              //         rightAction: () {
              //           MapsLauncher.launchCoordinates(
              //             widget.model.latitude?.toDouble() ?? 0,
              //             widget.model.longitude?.toDouble() ?? 0,
              //           );
              //         },
              //       ),
              //       const SizedBox(height: 8.0),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //         child: Text(
              //           widget.model.address ?? "",
              //           style: TextStyle(
              //             fontSize: 15,
              //             fontWeight: FontWeight.normal,
              //             color: theme.customLabelColor,
              //           ),
              //         ),
              //       ),
              //       const SizedBox(height: 12.0),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //         child: ClipRRect(
              //           borderRadius: BorderRadius.circular(12.0),
              //           child: SizedBox(
              //             height: 180,
              //             child: map.GoogleMap(
              //               myLocationButtonEnabled: false,
              //               onMapCreated: (controller) {
              //                 mapController = controller;
              //               },
              //               initialCameraPosition: map.CameraPosition(
              //                 target: map.LatLng(
              //                   widget.model.latitude?.toDouble() ?? 0,
              //                   widget.model.longitude?.toDouble() ?? 0,
              //                 ),
              //                 zoom: 11.0,
              //               ),
              //               markers: {
              //                 map.Marker(
              //                   markerId: map.MarkerId("${widget.model.id}"),
              //                   position: map.LatLng(
              //                     widget.model.latitude?.toDouble() ?? 0,
              //                     widget.model.longitude?.toDouble() ?? 0,
              //                   ),
              //                 )
              //               },
              //             ),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              const SizedBox(height: 12),
              SectionHeader(title: localization.contact),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (widget.model.user?.firstName ?? "") +
                                (widget.model.user?.lastName ?? ""),
                            style: TextStyle(
                              color: theme.primaryColorDark,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            (widget.model.user?.address ?? ""),
                            style: TextStyle(
                              color: theme.customLabelColor.withOpacity(0.6),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                    Ink(
                      width: 48,
                      height: 48,
                      decoration: ShapeDecoration(
                        color: theme.cardColor,
                        shape: const CircleBorder(),
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.call),
                        iconSize: 25,
                        color: theme.primaryColor,
                        onPressed: _callPhone,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Ink(
                      width: 48,
                      height: 48,
                      decoration: ShapeDecoration(
                        color: theme.cardColor,
                        shape: const CircleBorder(),
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: const Offset(
                                0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.mail_rounded),
                        iconSize: 25,
                        color: theme.primaryColor,
                        onPressed: _sendEmail,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Row buildPropertyFeatureItem(IconData iconData, String title) {
    final theme = AppThemes.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FaIcon(
          iconData,
          size: 20,
          color: theme.primaryColor,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: theme.customLabelColor.withOpacity(0.6),
          ),
        )
      ],
    );
  }

  Future<void> _callPhone() async {
    final phoneNumber = widget.model.user?.phoneNumber;
    if (phoneNumber == null) {
      return;
    }
    await launchUrl(Uri.parse("tel:$phoneNumber"));
  }

  Future<void> _sendEmail() async {
    final email = widget.model.user?.email;
    if (email == null) {
      return;
    }
    await launchUrl(Uri.parse("mailto:$email"));
  }
}

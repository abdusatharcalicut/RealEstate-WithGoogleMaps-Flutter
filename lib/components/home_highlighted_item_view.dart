import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:publrealty/extensions/convert_extensions.dart';
import 'package:publrealty/models/property_model.dart';
import 'package:publrealty/service/ApiService.dart';

class HomeHighlightedItemView extends StatelessWidget {
  const HomeHighlightedItemView(
      {Key? key, required this.model, required this.onItemClick})
      : super(key: key);

  final PropertyModel model;
  final Function(PropertyModel model) onItemClick;

  @override
  Widget build(BuildContext context) {
    final price = model.price?.toMoney(model.currency ?? "");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onTap: () => onItemClick(model),
          child: Stack(
            children: [
              if (model.imageNames != null)
                Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl:
                        ApiService.imagesUrl +
                            model.imageNames!.split(",").first,
                        fit: BoxFit.cover)),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
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
                  )),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              model.title ?? "",
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    color: Colors.white, size: 14),
                                const SizedBox(width: 3),
                                Text(
                                  model.city?.name ?? "",
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.white),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.space_dashboard,
                                    color: Colors.white, size: 14),
                                const SizedBox(width: 3),
                                Text(
                                  "${model.size}m²",
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.white),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Text(
                        price ?? "",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 22),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

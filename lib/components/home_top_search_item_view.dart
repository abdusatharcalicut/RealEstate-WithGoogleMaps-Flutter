import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:publrealty/models/city_model.dart';
import 'package:publrealty/screens/search_screen.dart';
import 'package:publrealty/service/ApiService.dart';

class HomeTopSearchItemView extends StatelessWidget {
  const HomeTopSearchItemView({Key? key, required this.model})
      : super(key: key);

  final CityModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the SearchScreen when the image is clicked
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(), // Navigate to SearchScreen
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            color: Color(0xFFC99E23),
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Opacity(
                    opacity: 0.7,
                    child: CachedNetworkImage(
                        imageUrl:
                            ApiService.imagesUrl + (model.imageName ?? ""))),
                Text(
                  model.name?.toUpperCase() ?? "",
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

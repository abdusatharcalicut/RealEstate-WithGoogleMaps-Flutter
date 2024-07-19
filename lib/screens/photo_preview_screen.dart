import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:publrealty/service/ApiService.dart';

class PhotoPreviewScreen extends StatefulWidget {
  const PhotoPreviewScreen({Key? key, required this.imagePath})
      : super(key: key);

  final String imagePath;

  @override
  State<PhotoPreviewScreen> createState() => _PhotoPreviewScreenState();

  static void navigate(BuildContext context, String imagePath) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => PhotoPreviewScreen(imagePath: imagePath),
      ),
    );
  }
}

class _PhotoPreviewScreenState extends State<PhotoPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: PhotoView(
        maxScale: 5.0,
        imageProvider:
            CachedNetworkImageProvider("${ApiService.imagesUrl}${widget.imagePath}"),
      ),
    );
  }
}

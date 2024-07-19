import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:publrealty/components/dots_indicator.dart';
import 'package:publrealty/components/publ_text_field.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/screens/root_screen.dart';
import 'package:publrealty/service/ApiService.dart';
import 'package:publrealty/themes/app_themes.dart';

class HomeHeaderView extends StatefulWidget {
  const HomeHeaderView(
      {Key? key, required this.headerImages, required this.scrollController})
      : super(key: key);

  final ScrollController scrollController;
  final List<String> headerImages;

  @override
  State<HomeHeaderView> createState() => _HomeHeaderViewState();
}

class _HomeHeaderViewState extends State<HomeHeaderView> {
  final _controller = PageController();
  var _headerOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollListener = () => setState(() {
          _headerOffset = -widget.scrollController.offset;
        });
    widget.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  late VoidCallback _scrollListener;

  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.of(context);
    final localization = AppLocalizations.of(context);
    final headerHeight = 200.0 + MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        SizedBox(
          height: min(max(0, headerHeight + _headerOffset), headerHeight),
          child: Stack(
            children: [
              Positioned.fill(
                child: PageView.builder(
                  controller: _controller,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl:
                        "${ApiService.imagesUrl}${widget.headerImages[index]}",
                        fit: BoxFit.cover);
                  },
                  itemCount: widget.headerImages.length,
                ),
              ),
              Positioned.directional(
                textDirection: Directionality.of(context),
                bottom: 33.0,
                start: 0.0,
                end: 0.0,
                child: Center(
                  child: DotsIndicator(
                    controller: _controller,
                    itemCount: widget.headerImages.length,
                    onPageSelected: (int page) {
                      _controller.animateToPage(
                        page,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                  ),
                ),
              )
              // Positioned(
              //   child: IgnorePointer(
              //     child: Center(
              //       child: Image.asset(
              //         "assets/images/logo.png",
              //         width: 180,
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            top: max(MediaQuery.of(context).padding.top,
                (headerHeight - 25 + min(0, _headerOffset))),
          ),
          child: GestureDetector(
            onTap: () {
              RootScreen.rootScreenKey.currentState?.changeTab(1);
            },
            child: Container(
              color: Colors.transparent,
              child: IgnorePointer(
                child: PublTextField(
                  controller: TextEditingController(),
                  placeHolder: localization.searchPlaceHolder,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

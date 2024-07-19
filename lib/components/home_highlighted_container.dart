import 'package:flutter/material.dart';
import 'package:publrealty/components/dots_indicator.dart';
import 'package:publrealty/components/home_highlighted_item_view.dart';
import 'package:publrealty/screens/property_detail_screen.dart';
import 'package:publrealty/service/response/dashboard_response_model.dart';
import 'package:publrealty/themes/app_themes.dart';

class HomeHighlightedContainer extends StatefulWidget {
  const HomeHighlightedContainer({Key? key, required this.dashboardModel})
      : super(key: key);

  final DashboardResponseModel? dashboardModel;

  @override
  State<HomeHighlightedContainer> createState() =>
      _HomeHighlightedContainerState();
}

class _HomeHighlightedContainerState extends State<HomeHighlightedContainer> {
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final theme = AppThemes.of(context);

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              final item = widget.dashboardModel!.featuredProperties![index];
              return HomeHighlightedItemView(
                model: item,
                onItemClick: (model) =>
                    PropertyDetailScreen.navigate(context, model),
              );
            },
            itemCount: widget.dashboardModel?.featuredProperties?.length ?? 0,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 14,
          child: DotsIndicator(
            controller: _pageController,
            itemCount: widget.dashboardModel?.featuredProperties?.length ?? 0,
            onPageSelected: (value) {},
            color: theme.primaryColor,
          ),
        ),
      ],
    );
  }
}

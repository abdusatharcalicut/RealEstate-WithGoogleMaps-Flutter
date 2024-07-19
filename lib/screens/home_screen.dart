import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:publrealty/components/home_highlighted_container.dart';
import 'package:publrealty/components/home_top_search_item_view.dart';
import 'package:publrealty/components/index.dart';
import 'package:publrealty/components/property_item_row_view.dart';
import 'package:publrealty/components/section_header.dart';
import 'package:publrealty/extensions/global_extensions.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/providers/liked_properties_provider.dart';
import 'package:publrealty/screens/property_detail_screen.dart';
import 'package:publrealty/service/ApiService.dart';
import 'package:publrealty/service/response/dashboard_response_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  DashboardResponseModel? dashboardModel;
  bool _showProgressBar = false;
  late StreamSubscription subscription;
  var isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    _scrollController = ScrollController();
    fetchData();
    super.initState();
    // Show progress bar
    setState(() {
      _showProgressBar = true;
    });


  void dispose() {
    subscription.cancel();
    super.dispose();
  }

    // Hide progressBar
    Future.delayed(Duration(seconds: 20), () {
      setState(() {
        _showProgressBar = false;
      });
    });
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );

  void fetchData() async {
    try {
      final value = await ApiService.getDashboard();
      setState(() {
        dashboardModel = value;
      });
    } catch (e) {
      handleException(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final likedProperties = LikedPropertiesProvider.of(context, listen: true);

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
        title: Text('Home'),
      ),
      body: Center(
        child: Stack(
          children: [
            ListView(
              controller: _scrollController,
              children: [
                Container(height: 240),
                SectionHeader(
                  title: localization.sponsored,
                ),
                const SizedBox(height: 8),
                HomeHighlightedContainer(
                  dashboardModel: dashboardModel,
                ),
                const SizedBox(height: 8),
                SectionHeader(
                  title: localization.topSearches,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      clipBehavior: Clip.none,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = dashboardModel!.topSearchCities![index];
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          child: HomeTopSearchItemView(model: item),
                        );
                      },
                      itemCount: dashboardModel?.topSearchCities?.length ?? 0),
                ),
                const SizedBox(height: 16),
                SectionHeader(title: localization.todayNew),
                for (var item in dashboardModel?.newProperties ?? [])
                  PropertyItemRowView(
                    model: item,
                    isLiked: likedProperties.containsInList(item),
                    onItemClick: (model) {
                      PropertyDetailScreen.navigate(context, model);
                    },
                  )
              ],
            ),
            HomeHeaderView(
              headerImages: dashboardModel?.headerImages ?? [],
              scrollController: _scrollController,
            ),
            if (_showProgressBar) 
            Center( // Adjust position as needed
              child: CircularProgressIndicator(), // Progress bar
            ),
          ],
        ),
      ),
    );
  }
  void showDialogBox() => showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: const Text("No Connection"),
            content: const Text("Please check your internet connectivity"),
            actions: <Widget>[
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context, 'Cancel');
                    setState(() => isAlertSet = false);
                    isDeviceConnected =
                        await InternetConnectionChecker().hasConnection;
                    if (!isDeviceConnected) {
                      showDialogBox();
                      setState(() => isAlertSet = true);
                    }
                  },
                  child: const Text("Re Try")),
            ],
          ));
}

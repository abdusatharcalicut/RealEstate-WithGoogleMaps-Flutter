import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:publrealty/components/filter_botton_sheet_dialog.dart';
import 'package:publrealty/components/property_item_row_view.dart';
import 'package:publrealty/components/publ_primary_button.dart';
import 'package:publrealty/components/publ_text_field.dart';
import 'package:publrealty/constants/application_constants.dart';
import 'package:publrealty/extensions/global_extensions.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/models/property_model.dart';
import 'package:publrealty/providers/liked_properties_provider.dart';
import 'package:publrealty/screens/map_screen.dart';
import 'package:publrealty/screens/menu_screen.dart';
import 'package:publrealty/screens/property_detail_screen.dart';
import 'package:publrealty/service/ApiService.dart';
import 'package:publrealty/service/request/search_property_request_model.dart';
import 'package:publrealty/service/response/search_constants_response_model.dart';
import 'package:publrealty/themes/app_themes.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchTextController = TextEditingController();

  SearchConstantsResponseModel? searchConstants;

  List<PropertyModel> items = [];
  Timer? _debounceSearchEditText;

  final requestModel = SearchPropertyRequestModel(
      
      propertyTypes: [],
      propertyCategories: [],
      cities: [],
      bedRoomCounts: [0],
      bathRoomCounts: [0],
      kitchenRoomCounts: [0],
      parkingCounts: [0],
      minSize: ApplicationConstants.searchMinSize,
      maxSize: ApplicationConstants.searchMaxSize,
      minPrice: ApplicationConstants.searchMinPrice,
      maxPrice: ApplicationConstants.searchMaxPrice,
      address: "");

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _fetchSearchConstants();

      _searchTextController.addListener(() {
        if (_debounceSearchEditText?.isActive ?? false) {
          _debounceSearchEditText?.cancel();
        }
        _debounceSearchEditText = Timer(const Duration(milliseconds: 1000), () {
          _searchProperties();
        });
      });
    });
  }

  void _fetchSearchConstants() async {
    try {
      final value = await ApiService.getSearchConstants();
      setState(() {
        searchConstants = value;
      });
      _searchProperties();
    } catch (e) {
      handleException(e);
    }
  }

  void _searchProperties() async {
    try {
      requestModel.searchText = _searchTextController.text;
      final result = await ApiService.searchProperties(requestModel);
      setState(() {
        items = result;
      });
    } catch (e) {
      handleException(e);
    }
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = AppThemes.of(context);

    final likedPropertiesProvider =
        LikedPropertiesProvider.of(context, listen: true);

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
          title: Text('Search'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: PublTextField(
                controller: _searchTextController,
                placeHolder: localization.searchPlaceHolder,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        children: [
                          for (final item in requestModel.propertyTypes ?? [])
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Chip(
                                  label: Text(
                                item.name == "Sale"
                                    ? localization.auditorium
                                    : item.name == "Rent"
                                        ? localization.conventionCentre
                                        : (item.name ?? ""),
                              )),
                            ),
                          for (final item
                              in requestModel.propertyCategories ?? [])
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Chip(label: Text(item.name ?? "")),
                            ),
                          for (final item in requestModel.cities ?? [])
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Chip(label: Text(item.name ?? "")),
                            )
                        ],
                      ),
                    ),
                  ),
                  PublPrimaryButton(
                    title: localization.filters,
                    onPressed: () {
                      if (searchConstants != null) {
                        Future<void> future = showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return FilterBottomSheetDialog(
                                searchProperty: requestModel,
                                searchConstants: searchConstants!);
                          },
                        );
                        future.then((void value) {
                          _searchProperties();
                        });
                      }
                    },
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    localization.searchResultWithCount(items.length.toString()),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: theme.customLabelColor,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PropertiesMapScreen(
                            properties: items,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 8.0),
                      child: Text(
                        localization.goToMap,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: theme.primaryColorDark,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: CircularProgressIndicator.adaptive(), 
                    )
                  : ListView.builder(
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return PropertyItemRowView(
                          model: item,
                          isLiked: likedPropertiesProvider.containsInList(item),
                          onItemClick: (model) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PropertyDetailScreen(model: model),
                              ),
                            );
                          },
                        );
                      },
                      itemCount: items.length,
                    ),
            )
          ],
        ),
      ),
    );
  }
}

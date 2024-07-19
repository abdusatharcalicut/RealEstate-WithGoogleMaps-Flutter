import 'package:flutter/material.dart';
import 'package:publrealty/components/filter_selector_view.dart';
import 'package:publrealty/components/publ_primary_button.dart';
import 'package:publrealty/constants/application_constants.dart';
import 'package:publrealty/extensions/convert_extensions.dart';
import 'package:publrealty/localizations/app_localizations.dart';
import 'package:publrealty/models/city_model.dart';
import 'package:publrealty/models/property_category_model.dart';
import 'package:publrealty/models/property_type_model.dart';
import 'package:publrealty/service/request/search_property_request_model.dart';
import 'package:publrealty/service/response/search_constants_response_model.dart';
import 'package:publrealty/themes/app_themes.dart';

class FilterBottomSheetDialog extends StatefulWidget {
  const FilterBottomSheetDialog(
      {Key? key, required this.searchConstants, required this.searchProperty})
      : super(key: key);

  final SearchConstantsResponseModel searchConstants;
  final SearchPropertyRequestModel searchProperty;

  @override
  State<FilterBottomSheetDialog> createState() =>
      _FilterBottomSheetDialogState();
}

class _FilterBottomSheetDialogState extends State<FilterBottomSheetDialog> {
  RangeValues _currentPriceValues = const RangeValues(
      ApplicationConstants.searchMinPrice, ApplicationConstants.searchMaxPrice);
  RangeValues _currentSizeValues = const RangeValues(
      ApplicationConstants.searchMinSize, ApplicationConstants.searchMaxSize);

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PublPrimaryButton(
                    title:localization.applyfilter,
                    onPressed: () {
                      Navigator.of(context).pop(); // Dismiss the bottom sheet
                    },
                  ),
                ],
              ),
            ),
        buildTitleText(localization.type),
            SizedBox(
              height: 48,
              child: FilterSelectorView<PropertyTypeModel>(
                items: widget.searchConstants.propertyTypes ?? [],
                selectedItems: widget.searchProperty.propertyTypes ?? [],
                getTitle: (item) => item.name == "Sale" ? localization.auditorium : item.name == "Rent" ? localization.conventionCentre:(item as PropertyTypeModel).name ?? "",
              ),
            ),
            buildTitleText(localization.price),
            RangeSlider(
              activeColor: Colors.green,
              inactiveColor: Colors.green.withOpacity(0.3),
              values: _currentPriceValues,
              max: ApplicationConstants.searchMaxPrice,
              divisions: ApplicationConstants.searchMaxPrice.toInt(),
              labels: RangeLabels(
                _currentPriceValues.start.roundToDouble().toMoney(),
                _currentPriceValues.end.roundToDouble().toMoney(),
              ),
              onChanged: (values) {
                setState(() {
                  _currentPriceValues = values;
                });
              },
            ),
            // buildTitleText(localization.categories),
            // SizedBox(
            //   height: 48,
            //   child: FilterSelectorView<PropertyCategoryModel>(
            //     items: widget.searchConstants.propertyCategories ?? [],
            //     selectedItems: widget.searchProperty.propertyCategories ?? [],
            //     getTitle: (item) => (item as PropertyCategoryModel).name ?? "",
            //   ),
            // ),
            buildTitleText(localization.seatCapacity),
            SizedBox(
              height: 48,
              child: FilterSelectorView<int>(
                  items: const [0,250, 500, 750, 1000, 1500],
                  selectedItems: widget.searchProperty.bedRoomCounts ?? [],
                  getTitle: (item) => item == 0 ? "Any" : item.toString()),
            ),
            // buildTitleText(localization.bathrooms),
            // SizedBox(
            //   height: 48,
            //   child: FilterSelectorView<int>(
            //       items: const [0, 1, 2, 3, 4, 5],
            //       selectedItems: widget.searchProperty.bathRoomCounts ?? [],
            //       getTitle: (item) => item == 0 ? "Any" : item.toString()),
            // ),
            // buildTitleText(localization.kitchens),
            // SizedBox(
            //   height: 48,
            //   child: FilterSelectorView<int>(
            //       items: const [0, 1, 2, 3, 4, 5],
            //       selectedItems: widget.searchProperty.kitchenRoomCounts ?? [],
            //       getTitle: (item) => item == 0 ? "Any" : item.toString()),
            // ),
            // buildTitleText(localization.parkings),
            // SizedBox(
            //   height: 48,
            //   child: FilterSelectorView<int>(
            //       items: const [0, 1, 2, 3, 4, 5],
            //       selectedItems: widget.searchProperty.parkingCounts ?? [],
            //       getTitle: (item) => item == 0 ? "Any" : item.toString()),
            // ),
            // buildTitleText(localization.size),
            // RangeSlider(
            //   activeColor: Colors.green,
            //   inactiveColor: Colors.green.withOpacity(0.3),
            //   values: _currentSizeValues,
            //   max: ApplicationConstants.searchMaxSize,
            //   divisions: ApplicationConstants.searchMaxSize.toInt(),
            //   labels: RangeLabels(
            //     _currentSizeValues.start.roundToDouble().toMoney(),
            //     _currentSizeValues.end.roundToDouble().toMoney(),
            //   ),
            //   onChanged: (values) {
            //     setState(() {
            //       _currentSizeValues = values;
            //     });
            //   },
            // ),
            buildTitleText(localization.facilities),
            SizedBox(
              height: 48,
              child: FilterSelectorView<PropertyTypeModel>( //CityModel
                items: widget.searchConstants.propertyTypes ?? [],
                selectedItems: widget.searchProperty.propertyTypes ?? [],
                getTitle: (item) => item.name == "Sale" ? localization.parking : item.name == "Rent" ? localization.airConditioned:(item as PropertyTypeModel).name ?? "",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildTitleText(String title) {
    final theme = AppThemes.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 18, bottom: 6),
      child: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: theme.customLabelColor),
      ),
    );
  }
}

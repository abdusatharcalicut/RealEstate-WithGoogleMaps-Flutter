import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:publrealty/models/property_model.dart';
import 'package:publrealty/service/ApiService.dart';

class LikedPropertiesProvider extends ChangeNotifier {
  static LikedPropertiesProvider of(BuildContext context, {listen = false}) =>
      Provider.of<LikedPropertiesProvider>(context, listen: listen);

  List<PropertyModel> properties = [];

  Future<void> fetchLikedProperties() async {
    try {
      final result = await ApiService.getLikedProperties();
      properties = result;
      notifyListeners();
    } catch (e) {
      properties.clear();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> likeProperty(int propertyId, bool isLiked) async {
    await ApiService.likeProperty(propertyId, isLiked);
    await fetchLikedProperties();
  }

  bool containsInList(PropertyModel model) {
    return properties.any((element) => element.id == model.id);
  }
}

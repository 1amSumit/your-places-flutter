import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:services/models/place_model.dart";
import "package:services/data/dummy_data.dart";

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([...places_data]);
}

final placesProvider =
    StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});

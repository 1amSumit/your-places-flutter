import "dart:io";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:services/models/place_model.dart";
import "package:path_provider/path_provider.dart" as syspath;
import "package:path/path.dart" as path;
import "package:sqflite/sqflite.dart" as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> getDataBase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, "places.db"),
    onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY, name TEXT, image TEXT, lat REAL, lng REAL, address TEXT)');
    },
    version: 5,
  );

  return db;
}

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  Future<void> loadPlacesFromDevice() async {
    final db = await getDataBase();

    final data = await db.query('user_places');

    final places = data
        .map((row) => Place(
              id: row['id'] as String,
              name: row["name"] as String,
              image: File(row["image"] as String),
              location: PlaceLocation(
                  latitude: row['lat'] as double,
                  longitude: row['lng'] as double,
                  address: row['address'] as String),
            ))
        .toList();

    state = places;
  }

  void addPlace(String name, File image, PlaceLocation location) async {
    final appDirectory = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImagePath = await image.copy('${appDirectory.path}/$fileName');

    final newPlace =
        Place(name: name, image: copiedImagePath, location: location);

    final db = await getDataBase();
    db.insert("user_places", {
      "id": newPlace.id,
      "name": newPlace.name,
      "image": newPlace.image.path,
      "lat": newPlace.location.latitude,
      "lng": newPlace.location.longitude,
      "address": newPlace.location.address,
    });

    // print(db);

    state = [...state, newPlace];
  }

  void removePlace(Place place) {
    state = state.where((p) => p.id != place.id).toList();
  }
}

final placesProvider =
    StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});

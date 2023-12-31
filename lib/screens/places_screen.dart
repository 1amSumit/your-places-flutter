import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:services/main.dart';
import "package:services/provider/places_provider.dart";
import 'package:services/screens/add_place.dart';
import 'package:services/screens/place_screen.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _loadPlacesFuture;

  @override
  void initState() {
    super.initState();
    _loadPlacesFuture =
        ref.read(placesProvider.notifier).loadPlacesFromDevice();
  }

  @override
  Widget build(BuildContext context) {
    final placesData = ref.watch(placesProvider);

    Widget content = Center(
      child: Text(
        "No place add to display.",
        style: theme.textTheme.titleLarge!
            .copyWith(color: Colors.white, fontSize: 20),
      ),
    );

    if (placesData.isNotEmpty) {
      content = Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: placesData.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: ValueKey(placesData[index].id),
              onDismissed: (direction) {
                ref
                    .read(placesProvider.notifier)
                    .removePlace(placesData[index]);
              },
              child: ListTile(
                subtitle: Text(
                  placesData[index].location.address,
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                leading: CircleAvatar(
                  radius: 26,
                  backgroundImage: FileImage(placesData[index].image),
                ),
                title: Text(
                  placesData[index].name,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) {
                        return PlaceScreen(
                          place: placesData[index],
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Your Places"),
        ),
      ),
      body: FutureBuilder(
          future: _loadPlacesFuture,
          builder: ((context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : content)),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (ctx) {
              return const AddPlace();
            }));
          },
          label: const Icon(Icons.add)),
    );
  }
}

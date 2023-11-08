import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:services/main.dart';
import "package:services/provider/places_provider.dart";
import 'package:services/screens/add_place.dart';

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});

  @override
  ConsumerState<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends ConsumerState<PlacesScreen> {
  @override
  Widget build(BuildContext context) {
    final placesData = ref.watch(placesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Your Places"),
        ),
      ),
      body: ListView.builder(
          itemCount: placesData.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: TextButton(
                onPressed: () {},
                child: Text(
                  placesData[index].name,
                  style: theme.textTheme.titleLarge!
                      .copyWith(color: Colors.white, fontSize: 18),
                ),
              ),
            );
          }),
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

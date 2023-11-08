import 'package:flutter/material.dart';
import 'package:services/data/dummy_data.dart';
import 'package:services/main.dart';

class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Your Places"),
        ),
      ),
      body: ListView.builder(
          itemCount: places_data.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: TextButton(
                onPressed: () {},
                child: Text(
                  places_data[index].name,
                  style: theme.textTheme.titleLarge!
                      .copyWith(color: Colors.white, fontSize: 18),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {}, label: const Icon(Icons.add)),
    );
  }
}

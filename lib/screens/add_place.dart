import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:services/main.dart';
import 'package:services/models/place_model.dart';
import 'package:services/provider/places_provider.dart';
import 'package:services/widget/image_input.dart';
import 'package:services/widget/location_widget.dart';

class AddPlace extends ConsumerStatefulWidget {
  const AddPlace({super.key});

  @override
  ConsumerState<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends ConsumerState<AddPlace> {
  final _formKey = GlobalKey<FormState>();
  String enteredPlaceName = "";
  File? capturedImage;

  void getImage(File image) {
    capturedImage = image;
  }

  void savePlace() {
    if (_formKey.currentState!.validate() || capturedImage == null) {
      _formKey.currentState!.save();

      ref.read(placesProvider.notifier).addPlace(
            Place(name: enteredPlaceName, image: capturedImage!),
          );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Add New Place"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                maxLength: 50,
                decoration: InputDecoration(
                  label: Text(
                    "Place Name",
                    style: theme.textTheme.titleSmall!.copyWith(),
                  ),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.length <= 1 ||
                      value.length >= 50) {
                    return "Must be between 1 and 50 characters.";
                  }
                  return null;
                },
                onSaved: (newPlace) {
                  enteredPlaceName = newPlace!;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              ImageInput(
                onCaptureImage: getImage,
              ),
              const SizedBox(
                height: 12,
              ),
              const LocationInput(),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: savePlace,
                    child: Row(
                      children: [
                        const Icon(Icons.add),
                        Text(
                          "Add Place",
                          style: theme.textTheme.titleMedium!.copyWith(),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

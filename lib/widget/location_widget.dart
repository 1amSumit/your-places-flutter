import "package:flutter/material.dart";
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  bool isGettingLocation = false;
  LatLng? latlong;

  Position? position;

  String address = "";

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void getCurrentPosition() async {
    setState(() {
      isGettingLocation = true;
    });
    position = await _determinePosition();

    setState(() {
      isGettingLocation = false;
    });

    if (position == null) {
      return;
    }

    latlong = LatLng(position!.latitude, position!.longitude);

    getAddress(latlong);
  }

  void getAddress(LatLng? latLong) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLong!.latitude, latLong.longitude);

    address =
        "${placemarks[0].name} ${placemarks[0].street} ${placemarks[0].thoroughfare} ${placemarks[0].subLocality} ${placemarks[0].locality} ${placemarks[0].administrativeArea}";
    print(address);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      "No location choosen",
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );
    if (isGettingLocation) {
      previewContent = CircularProgressIndicator();
    }

    if (latlong != null) {
      previewContent = FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(latlong!.latitude, latlong!.longitude),
          initialZoom: 16,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/sumit0718/clooap5f300fd01pmcn8i7yl4/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic3VtaXQwNzE4IiwiYSI6ImNrdmVybDluMDM1bWYycm9rbnhjZ2l0YmYifQ.vL8_bdMZTKYtRALXWIE7WA',
            additionalOptions: const {
              "accessToken":
                  "pk.eyJ1Ijoic3VtaXQwNzE4IiwiYSI6ImNrdmVybDluMDM1bWYycm9rbnhjZ2l0YmYifQ.vL8_bdMZTKYtRALXWIE7WA"
            },
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(latlong!.latitude, latlong!.longitude),
                child: Icon(
                  Icons.pin_drop_rounded,
                  color: Colors.red[900],
                  size: 35,
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2)),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: getCurrentPosition,
              icon: const Icon(Icons.location_on),
              label: const Text("Get current location"),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text("Select on map"),
            )
          ],
        ),
      ],
    );
  }
}

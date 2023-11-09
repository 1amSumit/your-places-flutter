import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double latitude = 0.0;
  double longitude = 0.0;
  bool isGettingLocation = false;

  Position? position;

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

    setState(() {
      latitude = position!.latitude;
      longitude = position!.longitude;
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    Widget mapContent = FlutterMap(
      options: MapOptions(
          initialCenter: LatLng(latitude, longitude),
          initialZoom: 16,
          onTap: (tapPosi, point) {
            setState(() {
              latitude = point.latitude;
              longitude = point.longitude;
            });
          }),
      children: [
        TileLayer(
          urlTemplate:
              'https://api.mapbox.com/styles/v1/sumit0718/cloqvrnm900k701nz9ggp4wwp/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic3VtaXQwNzE4IiwiYSI6ImNrdmVybDluMDM1bWYycm9rbnhjZ2l0YmYifQ.vL8_bdMZTKYtRALXWIE7WA',
          additionalOptions: const {
            "accessToken":
                "pk.eyJ1Ijoic3VtaXQwNzE4IiwiYSI6ImNrdmVybDluMDM1bWYycm9rbnhjZ2l0YmYifQ.vL8_bdMZTKYtRALXWIE7WA"
          },
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(latitude, longitude),
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

    if (isGettingLocation) {
      mapContent = const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.fork_right))
        ],
      ),
      body: mapContent,
    );
  }
}

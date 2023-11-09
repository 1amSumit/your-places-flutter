import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:services/main.dart';
import 'package:services/models/place_model.dart';

class PlaceScreen extends StatefulWidget {
  const PlaceScreen({super.key, required this.place});
  final Place place;

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.place.name),
        ),
      ),
      body: Stack(
        children: [
          Image.file(
            widget.place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(widget.place.location.latitude,
                          widget.place.location.longitude),
                      initialZoom: 15,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://api.mapbox.com/styles/v1/sumit0718/cloqvokd200m601pla2h7h5yt/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoic3VtaXQwNzE4IiwiYSI6ImNrdmVybDluMDM1bWYycm9rbnhjZ2l0YmYifQ.vL8_bdMZTKYtRALXWIE7WA',
                        additionalOptions: const {
                          "accessToken":
                              "pk.eyJ1Ijoic3VtaXQwNzE4IiwiYSI6ImNrdmVybDluMDM1bWYycm9rbnhjZ2l0YmYifQ.vL8_bdMZTKYtRALXWIE7WA"
                        },
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: LatLng(widget.place.location.latitude,
                                widget.place.location.longitude),
                            child: Icon(
                              Icons.pin_drop_rounded,
                              color: Colors.red[900],
                              size: 35,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black54,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  child: Text(
                    widget.place.location.address,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: colorSheme.onBackground),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

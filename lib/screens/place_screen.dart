import 'package:flutter/material.dart';

class PlaceScreen extends StatefulWidget {
  const PlaceScreen({super.key, required this.title});
  final String title;

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(widget.title),
        ),
      ),
    );
  }
}

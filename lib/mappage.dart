import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(-33.86, 151.20);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
          markers: {
            const Marker(
              markerId: MarkerId("Sydney"),
              position: LatLng(-33.86, 151.20),
              infoWindow: InfoWindow(
                title: "Sydney",
                snippet: "Capital of New South Wales",
              ), // InfoWindow
            ), // Marker
          }, // markers
        ), // GoogleMap
      ), // Scaffold
    ); // MaterialApp
  }
}

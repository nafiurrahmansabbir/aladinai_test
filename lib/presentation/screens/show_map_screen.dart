import 'package:aladinai_test/presentation/utls/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class ShowMapScreen extends StatefulWidget {
  const ShowMapScreen({super.key, required this.lat, required this.long});

  final double lat;
  final double long;

  @override
  State<ShowMapScreen> createState() => _ShowMapScreenState();
}

class _ShowMapScreenState extends State<ShowMapScreen> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  void _recenterMap() {
    Get.snackbar(
      'Your Current Location',
      'Lat: ${widget.lat} Long: ${widget.long}',
      colorText: Colors.white,
      backgroundColor: AppColors.themeColor,
    );
    _mapController.move(LatLng(widget.lat, widget.long), 16);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Location', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        backgroundColor: AppColors.themeColor,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(widget.lat, widget.long),
              initialZoom: 16,
              interactionOptions: const InteractionOptions(
                flags: ~InteractiveFlag.doubleTapZoom,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(widget.lat, widget.long),
                    child: const Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),

          _floatingZoomAndLocationButton(),
        ],
      ),
    );
  }

  Widget _floatingZoomAndLocationButton() {
    return Positioned(
      right: 10,
      bottom: 40,
      child: Column(
        children: [
          FloatingActionButton(
            mini: true,
            heroTag: "zoomIn",
            onPressed: () {
              final currentZoom = _mapController.camera.zoom;
              final center = _mapController.camera.center;
              _mapController.move(center, currentZoom + 1);
            },
            backgroundColor: AppColors.themeColor,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            mini: true,
            heroTag: "zoomOut",
            onPressed: () {
              final currentZoom = _mapController.camera.zoom;
              final center = _mapController.camera.center;
              _mapController.move(center, currentZoom - 1);
            },
            backgroundColor: AppColors.themeColor,
            child: const Icon(Icons.remove),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "recenter",
            onPressed: _recenterMap,
            backgroundColor: AppColors.themeColor,
            child: const Icon(Icons.my_location),
          ),
        ],
      ),
    );
  }
}

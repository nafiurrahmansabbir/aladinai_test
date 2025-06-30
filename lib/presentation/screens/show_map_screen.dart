import 'package:aladinai_test/presentation/utls/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class ShowMapScreen extends StatefulWidget {
  const ShowMapScreen({
    super.key,
    required this.lat,
    required this.long,
  });

  final double lat;
  final double long;

  @override
  State<ShowMapScreen> createState() => _ShowMapScreenState();
}

class _ShowMapScreenState extends State<ShowMapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map View',style: TextStyle(
        color: Colors.white,

      ),),
      leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: Colors.white,)),
      backgroundColor: AppColors.themeColor),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(widget.lat, widget.long),
          initialZoom: 16,
          interactionOptions: const InteractionOptions(
            flags: ~InteractiveFlag.doubleTapZoom,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(widget.lat, widget.long),
                child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){},
        backgroundColor: AppColors.themeColor.withOpacity(0.9),
        child: Icon(Icons.my_location,color: Colors.red,),
      ),
    );
  }
}

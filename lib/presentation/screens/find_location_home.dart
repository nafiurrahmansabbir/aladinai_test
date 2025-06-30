import 'package:aladinai_test/presentation/screens/show_map_screen.dart';
import 'package:aladinai_test/presentation/utls/app_colors.dart';
import 'package:aladinai_test/presentation/utls/asset_paths.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class FindLocationHomeScreen extends StatefulWidget {
  const FindLocationHomeScreen({super.key});

  @override
  State<FindLocationHomeScreen> createState() => _FindLocationHomeScreenState();
}

class _FindLocationHomeScreenState extends State<FindLocationHomeScreen> {
  double? _latitude;
  double? _longitude;
  String? _address;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _address = null;
    });

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoading = false;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;

      });

      await _getAddressFromCoordinates(position.latitude, position.longitude);
      Get.snackbar('Successfully', 'Location fetch successful',colorText: Colors.white,backgroundColor: AppColors.themeColor);
    } catch (e) {
      setState(() {
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getAddressFromCoordinates(double lat, double long) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(lat, long);
      if (placeMarks.isNotEmpty) {
        Placemark place = placeMarks[0];
        setState(() {
          _address =
              "${place.street}, ${place.subLocality}, ${place.locality},\nDivision: ${place.administrativeArea},\nCountry:  ${place.country}";
        });
      } else {
        setState(() {
          _address = "No address found for these coordinates.";
        });
      }
    } catch (e) {
      setState(() {
        _address = 'Error getting address: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Lottie.asset(AssetPaths.genieLottie),
        ),
        centerTitle: true,
        title: Text('My Location', style: TextStyle(
          color: Colors.white
        )
        ),
        backgroundColor: AppColors.themeColor,
        actions: [
          IconButton(onPressed: _getCurrentLocation, icon: Icon(Icons.my_location,color: Colors.white,))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 200,
                  child: Lottie.asset(AssetPaths.locationLottie)),
              Text('Current Location & Address', style: TextStyle(
                 fontSize: 18,
                fontWeight: FontWeight.w500
              )
              ),
              Column(
                children: [
                   Card(
                     color: AppColors.cardColor,
                    margin: const EdgeInsets.all(20),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child:_isLoading
                          ? Center(child: const CircularProgressIndicator())
                          : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (_latitude != null && _longitude != null)
                            Text(
                              'Lat: ${_latitude?.toStringAsFixed(6)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          if (_latitude != null && _longitude != null)
                            Text(
                              'Long: ${_longitude?.toStringAsFixed(6)}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          if (_address != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                'Address: $_address',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: _getCurrentLocation,
                    child: const Text('Refresh Location'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_latitude != null && _longitude != null) {
                        Get.to(() => ShowMapScreen(lat: _latitude!, long: _longitude!));

                      } else {
                        Get.snackbar('Error', "Location not yet available",backgroundColor: Colors.red,colorText: Colors.white);
                      }
                    },
                    child: const Text('Show on Map'),
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

import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' hide ServiceStatus;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/index.dart';
import 'dart:math' as Math;
import '../widgets/index.dart';
import 'package:permission_handler/permission_handler.dart';

class LocateHOPP extends StatefulWidget {
  const LocateHOPP({Key? key}) : super(key: key);

  @override
  State<LocateHOPP> createState() => LocateHOPPState();
}

class LocateHOPPState extends State<LocateHOPP> {
  bool isLoading = false;
  late LocationPermission permission;
  late Position _currentPosition;
  late LatLng vehiclePosition;
  final Completer<GoogleMapController> _controller = Completer();
  List<Marker> otherVehiclesMarkers = [];
  late Marker vehicleMarker;
  List<List<double>> hopps = [
    [
      28.5484588,
      77.182250,
    ],
    [28.545185, 77.190341],
  ];
  Future<void> getCurrentLocation() async {
    setState(() {
      isLoading = true;
    });
    setState(() {
      otherVehiclesMarkers = [];
    });

    await Geolocator.getCurrentPosition().then((Position position) async {
      print('LATITUDE :' +
          position.latitude.toString() +
          '\nLONGITUDE :' +
          position.longitude.toString());
      setState(() {
        _currentPosition = position;
      });
      double deg2rad(deg) {
        return deg * (Math.pi / 180);
      }

      List<double> distances = [];
      for (var i = 0; i < hopps.length; i++) {
        setState(() {
          otherVehiclesMarkers.add(
            Marker(
              markerId: MarkerId(i.toString()),
              infoWindow: const InfoWindow(title: ''),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueOrange),
              position: LatLng(hopps[i][0], hopps[i][1]),
            ),
          );
        });
        var R = 6371; // Radius of the earth in km
        var dLat =
            deg2rad(hopps[i][0] - _currentPosition.latitude); // deg2rad below
        var dLon = deg2rad(hopps[i][1] - _currentPosition.longitude);
        var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(deg2rad(_currentPosition.latitude)) *
                Math.cos(deg2rad(hopps[i][0])) *
                Math.sin(dLon / 2) *
                Math.sin(dLon / 2);
        var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        double d = R * c; // Distance in km
        setState(() {
          distances.add(d);
        });
      }
      double mini = distances.reduce(min);
      int index = distances.indexOf(mini);
      setState(() {
        otherVehiclesMarkers.removeAt(index);
      });
      print(mini);
      setState(() {
        vehiclePosition = LatLng(hopps[index][0], hopps[index][1]);
      });
      setState(() {
        vehicleMarker = Marker(
          markerId: const MarkerId('hoppLocation'),
          infoWindow: const InfoWindow(title: 'HOPP Location'),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          position: LatLng(vehiclePosition.latitude, vehiclePosition.longitude),
        );
      });
    }).catchError((e) {
      print(e);
    });

    moveTo(vehiclePosition.latitude, vehiclePosition.longitude);
    final GoogleMapController controller = await _controller.future;
    controller.showMarkerInfoWindow(MarkerId('hoppLocation'));
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       appBar: AppBar(
          centerTitle: false,
          title: const Text('Locate HOPP'),
          actions: [],
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      _currentPosition.latitude, _currentPosition.longitude),
                  zoom: 10.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                compassEnabled: true,
                zoomControlsEnabled: false,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                mapToolbarEnabled: true,
                markers: {
                  vehicleMarker,
                  for (var i = 0; i < otherVehiclesMarkers.length; i++) ...[
                    otherVehiclesMarkers[i],
                  ]
                },
              ),
        floatingActionButton: Container(
          height: 50,
          child: FlatButton(
            onPressed: () async {
              String url =
                  "http://maps.google.com/maps?saddr=${_currentPosition.latitude},${_currentPosition.longitude}&daddr=${vehiclePosition.latitude},${vehiclePosition.longitude}";
              url.launchUrl;
              //await moveToMyLocation();
            },
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            child: Ink(
              decoration: BoxDecoration(
                color: Color(0xFF26352e),
                // color: Theme.of(context).accentColor.withOpacity(0.3),
                /* gradient: LinearGradient(
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                          colors: [
                                            Colors.blue,
                                            Colors.greenAccent,
                                          ],
                                        ),*/
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                alignment: Alignment.center,
                constraints: BoxConstraints(
                    minHeight: 75,
                    maxWidth: MediaQuery.of(context).size.width * 0.50),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delivery_dining,
                      color: Theme.of(context).accentColor,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Navigate',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
       /* FloatingActionButton.extended(
          onPressed: () async {
            String url =
                "http://maps.google.com/maps?saddr=${_currentPosition.latitude},${_currentPosition.longitude}&daddr=${vehiclePosition.latitude},${vehiclePosition.longitude}";
            url.launchUrl;
            //await moveToMyLocation();
          },
          backgroundColor: Colors.blue,
          label: Text(
            'Navigate',
            style: GoogleFonts.breeSerif(
              textStyle: TextStyle(color: Colors.white),
            ),
          ),
          icon: Icon(
            Icons.delivery_dining,
            color: Colors.white,
          ),
        ),*/
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Future<void> moveTo(double latitude, double longitude) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(latitude, longitude),
      zoom: 15.0,
    )));
  }

  Future<void> showHOPPMarkerWindow() async {}
  Future<void> moveToMyLocation(double latitude) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
      zoom: 10.0,
    )));
  }
}

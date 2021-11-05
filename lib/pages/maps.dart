import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

import 'package:latlong2/latlong.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:monline/pages/data.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => new _MapsState();
}

class _MapsState extends State<Maps> {
  Position current;
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
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  List<dynamic> data = [
    {"lat": -8.648993658304958, "lng": 116.52560498592898},
    {"lat": -8.650880248618963, "lng": 116.528442964507},
    {"lat": -8.620437497804016, "lng": 116.47752698392225},
  ];
  bool isLoading = true;
  void getCurrentLocation() async {
    current = await _determinePosition();

    mapController.move(LatLng(current.latitude, current.longitude), 18);
    isLoading = false;
    markers = <Marker>[];
    markers.add(
      Marker(
        width: 80.0,
        height: 80.0,
        point: LatLng(current.latitude, current.longitude),
        builder: (ctx) => Container(
          key: Key('blue'),
          child: Icon(
            Icons.location_on_sharp,
            color: Colors.blue,
          ),
        ),
      ),
    );
    for (var item in Data().bengkel) {
      print(distance.as(
        LengthUnit.Kilometer,
        LatLng(current.latitude, current.longitude),
        LatLng(item["lat"], item["lng"]),
      ));
      if (distance.as(
            LengthUnit.Kilometer,
            LatLng(current.latitude, current.longitude),
            LatLng(item["lat"], item["lng"]),
          ) <=
          Data().limit) {
        markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(item["lat"], item["lng"]),
            builder: (ctx) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.build_circle,
                  color: Colors.red,
                ),
                Text(
                  item["nama"],
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        );
      }
    }
    setState(() {});
  }

  MapController mapController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markers = <Marker>[];
  }

  final Distance distance = Distance();
  //static LatLng london = LatLng(51.5, -0.09);
  var markers;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      floatingActionButton: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : FloatingActionButton(
              onPressed: () {
                getCurrentLocation();
              },
              child: Icon(Icons.location_on),
            ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(-8.649270336963685, 116.52562634073767),
          zoom: 13.0,
          onMapCreated: (c) {
            mapController = c;
            getCurrentLocation();
          },
        ),
        mapController: mapController,
        layers: [
          TileLayerOptions(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/uzixcode/ckv2j8sko3ssa14o9lt2snnmq/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoidXppeGNvZGUiLCJhIjoiY2t2MmZ6OWNwNm85eDJ1cGh0bnVnb3psZyJ9.6spJ3n7mQaWex61DB3jzBQ',
            additionalOptions: {
              'accessToken':
                  'pk.eyJ1IjoidXppeGNvZGUiLCJhIjoiY2t2MmZ6OWNwNm85eDJ1cGh0bnVnb3psZyJ9.6spJ3n7mQaWex61DB3jzBQ',
              'id': 'mapbox.satellite',
            },
          ),
          MarkerLayerOptions(markers: markers)
        ],
      ),
    );
  }

  void onStyleLoadedCallback() {}
}

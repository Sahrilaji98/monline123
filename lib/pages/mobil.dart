import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:monline/pages/data.dart';
import 'detailmobil.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' show cos, sqrt, asin;

class Mobil extends StatefulWidget {
  @override
  _MobilState createState() => new _MobilState();
}

class _MobilState extends State<Mobil> {
  final search = TextEditingController();
  @override
  void initState() {
    //getData(true);
    getCurrentLocation();
    super.initState();
  }

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

  final Distance distance = Distance();
  List currentBengkel = [];
  void getCurrentLocation() async {
    current = await _determinePosition();

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
        currentBengkel.add(item);
      }
    }
    isLoading = false;
    setState(() {});
  }

  bool isLoading = true;
  Future<bool> getData(bool loading) async {
    isLoading = loading;
    setState(() {});
    await Future.delayed(Duration(seconds: 2));
    isLoading = false;
    setState(() {});
    return isLoading;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextField(
            controller: search,
            onChanged: (n) {
              setState(() {});
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 19),
                hintText: "search",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.purple, width: 2)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.purple, width: 2)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.purple, width: 2))),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, body) => isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    return getData(true);
                  },
                  child: ListView.builder(
                      itemCount: currentBengkel.length,
                      itemBuilder: (context, index) {
                        return !currentBengkel[index]["nama"]
                                .toString()
                                .contains(search.text)
                            ? Container()
                            : Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailMobil(
                                                  nama: currentBengkel[index]
                                                      ["nama"],
                                                  jalan: currentBengkel[index]
                                                      ["jalan"],
                                                  foto: currentBengkel[index]
                                                      ["foto"],
                                                  phone: currentBengkel[index]
                                                      ["notelp"],
                                                )));
                                  },
                                  leading: SizedBox(
                                      height: body.maxWidth * 0.20,
                                      width: body.maxWidth * 0.30,
                                      child: Image.asset(
                                        "assets/gambarmotor/${currentBengkel[index]["foto"]}",
                                        fit: BoxFit.cover,
                                      )),
                                  title: Text(currentBengkel[index]["nama"]),
                                  subtitle:
                                      Text(currentBengkel[index]["jalan"]),
                                ),
                              );
                      }),
                ),
        ));
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailMobil extends StatefulWidget {
  String nama;
  String jalan;
  String foto;
  String phone;
  DetailMobil({this.nama, this.jalan, this.foto, this.phone});

  @override
  State<DetailMobil> createState() => _DetailMobilState();
}

class _DetailMobilState extends State<DetailMobil> {
  List akun = [];

  int userIndex;

  SharedPreferences pref;

  void getUserAccount() async {
    pref = await SharedPreferences.getInstance();
    String getAkun = await pref.getString("akun");
    userIndex = await pref.getInt("index");
    if (getAkun != null && getAkun.length > 0) {
      akun = jsonDecode(getAkun);
    }
    print(akun[userIndex]);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
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

  String url(latitude, longitude) {
    String message =
        "${akun[userIndex]["nama"]}                 ${akun[userIndex]["nowa"]}" +
            "Saya Ingin Satu Mekanik Untuk Memperbaiki Motor saya pastikan cewek, karena saya seorang laki-laki " +
            "http://maps.google.com/?ie=UTF8&hq=&ll=$latitude,$longitude&z=13";
    if (Platform.isAndroid) {
      // add the [https]
      return "https://wa.me/${widget.phone}/?text=$message"; // new line
    } else {
      // add the [https]
      return "https://api.whatsapp.com/send?phone=${widget.phone}=${Uri.parse(message)}"; // new line
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserAccount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Seputar tentang bengkel",
              style: TextStyle(color: Colors.white)),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green[600],
          onPressed: () async {
            Position posisi = await _determinePosition();
            print(posisi.latitude);
            print(posisi.longitude);

            String message =
                "${akun[userIndex]["nama"]}\n${akun[userIndex]["nowa"]}\n" +
                    "Saya Ingin Satu Mekanik Untuk Memperbaiki Motor saya, \nhttp://maps.google.com/?ie=UTF8%26ll=${posisi.latitude},${posisi.longitude}%26z=23";
            if (await canLaunch(
                "https://wa.me/${widget.phone}/?text=$message")) {
              await launch("https://wa.me/${widget.phone}/?text=$message");
            } else {
              throw 'Could not launch ${url(posisi.latitude, posisi.longitude)}';
            }
          },
          child: Icon(FontAwesome.whatsapp),
        ),
        body: LayoutBuilder(
            builder: (context, body) => Column(
                  children: [
                    SizedBox(
                      height: body.maxHeight * 0.40,
                      child: Image.asset(
                        "assets/gambarmotor/${widget.foto}",
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          widget.nama,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: body.maxWidth * 0.05),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          widget.jalan,
                          style: TextStyle(fontSize: body.maxWidth * 0.05),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "Bengkel kami dalah bengkel terpercaya, karna kepercayaan anda itu sangat berharga " +
                                  "jika anda meyakini bengkel kami silahkan melakukan pemesanan" +
                                  "cara yang bisa dilakukan adalah:" +
                                  "\n\n1. silahkan pilih bengkel terdekat yang ada didalam maps." +
                                  "\n\n2. jika sudah yakin bahwa bengkel ini yang anda pilih silahkan lakukan pemesanan. " +
                                  "\n\n3. Dengan cara memencet tombol Whatshapp yang sudah disediakan." +
                                  " ",
                              style: TextStyle(fontSize: body.maxWidth * 0.05),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )));
  }
}

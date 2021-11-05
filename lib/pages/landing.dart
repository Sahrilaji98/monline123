import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:monline/pages/beranda.dart';
import 'package:monline/pages/berita.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'maps.dart';
import 'mobil.dart';
import './akun.dart';

class LandingPage extends StatefulWidget {
  @override
  LandingPageState createState() => LandingPageState();
}

class LandingPageState extends State<LandingPage> {
  List<Widget> _container = [
    Beranda(),
    Maps(),
    Berita(),
    Akun(),
    Mobil(),
  ];
  GlobalKey serviceList = GlobalKey();
  GlobalKey mapsKey = GlobalKey();
  GlobalKey beritaKey = GlobalKey();

  List<GlobalKey> keys = [GlobalKey(), GlobalKey()];
  List<TargetFocus> targets = [];

  bool isPermit = false;
  Location location = Location();
  PermissionStatus hasPermissions;
  void changePage(int indexi) {
    _bottomNavIndex = indexi;
    setState(() {});
  }

  void pushPage() async {
    if (!kIsWeb) {
      hasPermissions = await location.hasPermission();
      if (hasPermissions != PermissionStatus.granted) {
        await location.requestPermission();
        isPermit = true;
        setState(() {});
      }
      isPermit = true;
      setState(() {});
    }
  }

  @override
  void initState() {
    pushPage();
    checkUser();
    super.initState();
  }

  void checkUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("isFirst") == null) {
      Future.delayed(Duration.zero, showTutorial);
      pref.setBool("isFirst", false);
    }
  }

  void initTarget() {
    targets.clear();
    targets.add(
      TargetFocus(
        identify: "serviceList",
        keyTarget: serviceList,
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Halaman Daftar Bengkel Sesuai Lokasi Terdekat",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "${keys[0]}",
        keyTarget: keys[0],
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Peta Bengkel Terdeket",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "${keys[1]}",
        keyTarget: keys[1],
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Berita Seputar Otomotif Terbaru",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void showTutorial() {
    initTarget();
    TutorialCoachMark(
      context,
      targets: targets, // List<TargetFocus>
      colorShadow: Colors.red, // DEFAULT Colors.black
      // alignSkip: Alignment.bottomRight,
      // textSkip: "SKIP",
      // paddingFocus: 10,
      // opacityShadow: 0.8,
      onClickTarget: (target) {
        print(target);
      },
      onClickOverlay: (target) {
        print(target);
      },
      onSkip: () {
        print("skip");
      },
      onFinish: () {
        print("finish");
      },
    )..show();
  }

  final iconList = <Map<String, dynamic>>[
    {"icon": Icons.home, "title": "Beranda"},
    {"icon": Icons.map, "title": "maps"},
    {"icon": Icons.now_widgets_sharp, "title": "Berita"},
    {"icon": Icons.settings, "title": "pengaturan"},
  ];
  var _bottomNavIndex = 0;
  final autoSizeGroup = AutoSizeGroup();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, screen) => Scaffold(
          body: !isPermit
              ? Center(
                  child: Text("izin menggunakan gps di tolak"),
                )
              : _container[_bottomNavIndex],
          floatingActionButton: Container(
            key: serviceList,
            decoration:
                BoxDecoration(color: Color(0xff373A36), shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: FloatingActionButton(
                elevation: 0,
                hoverElevation: 0,
                disabledElevation: 0,
                focusElevation: 0,
                onPressed: () {
                  setState(() => _bottomNavIndex = 4);
                },
                child: Icon(
                  Icons.home_repair_service,
                  size: screen.maxWidth * 0.10,
                ),
              ),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: AnimatedBottomNavigationBar.builder(
            itemCount: iconList.length,
            tabBuilder: (int index, bool isActive) {
              final color = isActive ? Color(0xffFF0000) : Colors.white;
              return Column(
                key: index == 1
                    ? keys[0]
                    : index == 2
                        ? keys[1]
                        : null,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    iconList[index]["icon"],
                    size: 24,
                    color: color,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: AutoSizeText(
                      iconList[index]["title"],
                      maxLines: 1,
                      style: TextStyle(color: color),
                      group: autoSizeGroup,
                    ),
                  )
                ],
              );
            },
            backgroundColor: Color(0xff373A36),
            activeIndex: _bottomNavIndex,
            splashColor: Color(0xffFFA400),
            splashSpeedInMilliseconds: 300,
            elevation: 0,
            notchMargin: 0,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.sharpEdge,
            leftCornerRadius: 0,
            rightCornerRadius: 0,
            onTap: (index) => setState(() => _bottomNavIndex = index),
          )),
    );
  }
}

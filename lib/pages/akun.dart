import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:monline/pages/landing.dart';
import 'package:monline/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Akun extends StatefulWidget {
  @override
  _AkunState createState() => new _AkunState();
}

class _AkunState extends State<Akun> {
  List akun = [];

  int userIndex;

  SharedPreferences pref;
  bool isLoading = true;
  void getUserAccount() async {
    pref = await SharedPreferences.getInstance();
    String getAkun = await pref.getString("akun");
    userIndex = await pref.getInt("index");
    if (getAkun != null && getAkun.length > 0) {
      akun = jsonDecode(getAkun);
    }
    isLoading = false;
    setState(() {});
    print(akun[userIndex]);
  }

  @override
  void initState() {
    super.initState();
    getUserAccount();
  }

  _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLogin", false);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(akun[userIndex]["nama"].toString()),
            ),
            body: SafeArea(
              child: new Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Akun'),
                          RaisedButton(
                            onPressed: () => _logOut(),
                            color: Colors.white,
                            child: const Text('Logout',
                                style: TextStyle(fontSize: 18)),
                          )
                        ]),
                  )),
            ));
  }
}

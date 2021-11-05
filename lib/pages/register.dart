import 'dart:async';
import 'dart:convert';

import 'package:avoid_keyboard/avoid_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monline/pages/landing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  List akun = [];
  SharedPreferences pref;
  void getUserAccount() async {
    pref = await SharedPreferences.getInstance();
    String getAkun = await pref.getString("akun");
    if (getAkun != null && getAkun.length > 0) {
      akun = jsonDecode(getAkun);
    }
    print(akun);
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserAccount();
    super.initState();
  }

  final username = TextEditingController();

  final password = TextEditingController();

  final nama = TextEditingController();

  final noWa = TextEditingController();
  bool isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : LayoutBuilder(
              builder: (context, body) => ListView(
                    children: [
                      SizedBox(
                        height: body.maxHeight,
                        width: body.maxWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              width: body.maxWidth,
                              height: body.maxHeight * 0.30,
                              child: Center(
                                  child: Text(
                                "Monline",
                                style: GoogleFonts.revalia(
                                    fontSize: body.maxWidth * 0.16,
                                    color: Color(0xffFF0000)),
                              )),
                            ),
                            Column(
                              children: [
                                Center(
                                  child: SizedBox(
                                    //height: body.maxHeight * 0.20,
                                    width: body.maxWidth * 0.80,
                                    child: TextField(
                                      controller: nama,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 19),
                                          hintText: "Nama",
                                          label: Text("Nama"),
                                          enabledBorder: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2)),
                                          border: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2))),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Center(
                                  child: SizedBox(
                                    //height: body.maxHeight * 0.20,
                                    width: body.maxWidth * 0.80,
                                    child: TextField(
                                      controller: username,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 19),
                                          hintText: "Username",
                                          label: Text("Username"),
                                          enabledBorder: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2)),
                                          border: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2))),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Center(
                                  child: SizedBox(
                                    //height: body.maxHeight * 0.20,
                                    width: body.maxWidth * 0.80,
                                    child: TextField(
                                      controller: password,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 19),
                                          hintText: "Password",
                                          label: Text("Password"),
                                          enabledBorder: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2)),
                                          border: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2))),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Center(
                                  child: SizedBox(
                                    //height: body.maxHeight * 0.20,
                                    width: body.maxWidth * 0.80,
                                    child: TextField(
                                      controller: noWa,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 19),
                                          hintText: "No Wa",
                                          label: Text("No Wa"),
                                          enabledBorder: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2)),
                                          border: UnderlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.black,
                                                  width: 2))),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: body.maxHeight * 0.15,
                              child: Center(
                                child: OutlinedButton(
                                    onPressed: () async {
                                      SharedPreferences pref =
                                          await SharedPreferences.getInstance();
                                      isLoading = true;
                                      setState(() {});
                                      bool isExist = false;
                                      for (var item in akun) {
                                        if (item["username"] == username.text) {
                                          isExist = true;
                                        }
                                      }
                                      if (!isExist) {
                                        akun.add({
                                          "username": username.text,
                                          "password": password.text,
                                          "nama": nama.text,
                                          "nowa": noWa.text
                                        });
                                      }
                                      print(akun);
                                      await pref.setString(
                                          "akun", jsonEncode(akun));
                                      Navigator.pop(
                                          _scaffoldKey.currentContext);
                                    },
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20))),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Color(0xffFF0000))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 17),
                                      child: Text(
                                        "Register",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
                    ],
                  )),
    );
  }
}

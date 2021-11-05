import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monline/pages/landing.dart';
import 'package:monline/pages/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
          builder: (context, body) => Column(
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
                            controller: username,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 19),
                                hintText: "Username",
                                label: Text("Username"),
                                enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2)),
                                border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2))),
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
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 19),
                                hintText: "Password",
                                label: Text("Password"),
                                enabledBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2)),
                                border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 2))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: body.maxHeight * 0.13,
                    child: Center(
                      child: Text("Lupa Kata Sandi ?"),
                    ),
                  ),
                  SizedBox(
                    height: body.maxHeight * 0.15,
                    child: Center(
                      child: OutlinedButton(
                          onPressed: () async {
                            bool isMatch = false;
                            int index;
                            for (var item in akun) {
                              if (item["username"] == username.text &&
                                  item["password"] == password.text) {
                                isMatch = true;
                                index = akun.indexOf(item);
                                break;
                              } else {}
                            }
                            if (isMatch) {
                              Timer(Duration(seconds: 1), () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool("isLogin", true);
                                await prefs.setInt("index", index);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LandingPage()));
                              });
                              await showDialog(
                                  context: context,
                                  builder: (context) => UnconstrainedBox(
                                        child: Card(
                                            child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Text("Login Sukses!!!"),
                                        )),
                                      ));
                            } else {
                              await showDialog(
                                  context: context,
                                  builder: (context) => UnconstrainedBox(
                                        child: Card(
                                            child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Text(
                                              "Username Atau Password Salah!!!"),
                                        )),
                                      ));
                            }
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xffFF0000))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 17),
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: body.maxHeight * 0.20,
                    child: Center(
                      child: OutlinedButton(
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register()));
                            getUserAccount();
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xffC4C4C4))),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 17),
                            child: Text(
                              "Buat Akun Baru",
                              style: TextStyle(color: Color(0xffFF0000)),
                            ),
                          )),
                    ),
                  )
                ],
              )),
    );
  }
}

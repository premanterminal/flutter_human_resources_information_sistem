import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:flutter_human_resources_information_sistem/util/app_const.dart';
// import 'package:flutter_human_resources_information_sistem/ScreenHome/fitness_app_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:imei_plugin/imei_plugin.dart';
// import 'package:device_info/device_info.dart';
import 'package:flutter_human_resources_information_sistem/Auth/login.dart';
//import 'package:flutter_human_resources_information_sistem/OldHRIS/login.dart';
// import 'package:flutter_human_resources_information_sistem/ScreenHome/fitness_app_home_screen.dart';
import 'package:flutter_human_resources_information_sistem/ScreenHome/home_hrisv2_screen.dart';

class Splashscreen extends StatefulWidget {
  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool islogin = false;
  _getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('isLogin') == '1') {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (BuildContext context) {
        //return new Home();
        //return new FitnessAppHomeScreen();
        return new HomeHRISv2Screen();
      }));
    } else {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (BuildContext context) {
        return new Login();
      }));
    }

    //testing tanpa login form
    // Navigator.of(context)
    //     .pushReplacement(new MaterialPageRoute(builder: (BuildContext context) {
    //   return new FitnessAppHomeScreen();
    // }));
  }

  delayloading() async {
    Timer(Duration(seconds: 3), () {
      _getPrefs();
      //cekInternet();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    delayloading();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/ikon-launcher-HRIS-01.jpg',
                      //'assets/logo/logo.png',
                      width: Get.width * 0.7,
                    ),
                    sizedBoxH4,
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    const SpinKitFadingCircle(
                      color: Colors.black87,
                      size: 35.0,
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const <Widget>[
                        Spacer(),
                        //Text('v2.1.1 (beta)',
                        Text('v2.1.13',
                            style: TextStyle(color: Colors.black87)),
                        Spacer()
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    Container(
                      width: Get.width * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

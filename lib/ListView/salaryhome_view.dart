import 'package:flutter/foundation.dart';
import 'package:flutter_human_resources_information_sistem/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_human_resources_information_sistem/Theme/fitness_app_theme.dart';
import 'dart:math' as math;
import 'package:flutter_human_resources_information_sistem/Network/baseUrl.dart';
import 'package:flutter_human_resources_information_sistem/util/view_util.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_human_resources_information_sistem/Theme/fitness_app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

class SalaryHomeView extends StatefulWidget {
  final AnimationController animationController;
  final Animation<double> animation;

  const SalaryHomeView(
      {Key? key, required this.animationController, required this.animation})
      : super(key: key);

  @override
  _SalaryHomeViewState createState() => _SalaryHomeViewState();
}

class _SalaryHomeViewState extends State<SalaryHomeView> {
  final formatter = new NumberFormat("#,###");
  var token;

  var statusLogin;

  var id;

  var nama;

  var email;

  var emailVerifiedAt;

  var currentTeamId;

  var profilePhotoPath;

  var createdAt;

  var updatedAt;

  var role;

  var dept;

  var idDept;
  String photo = '';

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('token');
      statusLogin = preferences.getString('isLogin');
      id = preferences.getInt('id');
      nama = preferences.getString('name');
      email = preferences.getString('email');
      emailVerifiedAt = preferences.getString('email_verified_at');
      currentTeamId = preferences.getString('current_team_id');
      // profilePhotoPath = preferences.getString('profile_photo_path');
      profilePhotoPath = preferences.getString('photo');
      createdAt = preferences.getString('created_at');
      updatedAt = preferences.getString('updated_at');
      role = preferences.getString('role');
      dept = preferences.getString('dept');
      photo = profilePhotoPath.toString();
    });
    dataSalary(token);
    print(token);
    print('sinilaa');
  }

  double take_home = 0;
  String Stake_home = '';

  dataSalary(token) async {
    try {
      final response = await http.get(
          Uri.parse(BaseUrl.apiBaseUrl + 'salary-summary'),
          headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        var data = result['data'];

        if (data.isNotEmpty) {
          setState(() {
            take_home = double.parse(data['take_home']);
            Stake_home = take_home.toString();
            print('hai' + take_home.toString());
            print('ini' + Stake_home);
          });
        }
      }
    } catch (e) {
      print(e);
      showErrorDialogTokenerror({
        'message': 'Waktu Habis',
        'errors': {
          'exception': ["Silahkan Login Kembali"]
        }
      });
    }
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [HexColor("#03071e"), HexColor("#1d7a27")],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.6),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Periode Agustus',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: FitnessAppTheme.fontName,
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          letterSpacing: 0.0,
                          color: FitnessAppTheme.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          NumberFormat.currency(locale: 'id')
                                  .format(take_home) ??
                              "",
                          textAlign: TextAlign.left,
                          style: Theme.of(context)
                              .textTheme
                              .button!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.timer,
                                color: FitnessAppTheme.white,
                                size: 16,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 4.0),
                              child: Text(
                                '68 min',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  letterSpacing: 0.0,
                                  color: FitnessAppTheme.white,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: FitnessAppTheme.nearlyWhite,
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: FitnessAppTheme.nearlyBlack
                                          .withOpacity(0.4),
                                      offset: Offset(8.0, 8.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Icon(
                                  Icons.downloading_rounded,
                                  color: HexColor("#1d7a27"),
                                  size: 44,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

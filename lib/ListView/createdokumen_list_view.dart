import 'package:flutter_human_resources_information_sistem/Theme/fitness_app_theme.dart';
//import 'package:flutter_human_resources_information_sistem/Model/meals_list_data.dart';
import 'package:flutter_human_resources_information_sistem/Model/createdokumen_list_data.dart';
import 'package:flutter_human_resources_information_sistem/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_human_resources_information_sistem/Screen/emptydata_screen.dart';
// import 'package:flutter_human_resources_information_sistem/Screen/hod_cuti.dart';
// import 'package:flutter_human_resources_information_sistem/Screen/hod_lembur.dart';
// import 'package:flutter_human_resources_information_sistem/Screen/tambah_cuti_screen.dart';
// import 'package:flutter_human_resources_information_sistem/Screen/tambah_lembur_screen.dart';
//import '../../main.dart';
import 'package:flutter_human_resources_information_sistem/Screen/create_portal_screen.dart';
import 'package:flutter_human_resources_information_sistem/Screen/pengajuan_cuti_screen.dart';
import 'package:flutter_human_resources_information_sistem/Screen/pengajuan_lembur_screen.dart';
import 'package:flutter_human_resources_information_sistem/OldHRIS/ApprovalCuti.dart';
import 'package:flutter_human_resources_information_sistem/OldHRIS/ApprovalLembur.dart';
// import 'package:flutter_human_resources_information_sistem/Screen/hod_cuti.dart';
// import 'package:flutter_human_resources_information_sistem/Screen/hod_lembur.dart';
// import 'package:flutter_human_resources_information_sistem/Screen/emptydata_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
// import 'package:intl/intl.dart';
import '../../main.dart';
import 'package:flutter_human_resources_information_sistem/Network/baseUrl.dart';

class CreateDokumenListView extends StatefulWidget {
  const CreateDokumenListView(
      {Key? key,
      required this.mainScreenAnimationController,
      required this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<double> mainScreenAnimation;

  @override
  _CreateDokumenListViewState createState() => _CreateDokumenListViewState();
}

class _CreateDokumenListViewState extends State<CreateDokumenListView>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  List<CreateDokumenListData> mealsListData =
      CreateDokumenListData.tabIconsList;

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
  var photo1 = "C3557MqIM6y6rsmBCWfihIAoYndIR5RK4qaYnvuR.jpg";
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
    //datatotalcuti(token);
    //datatotallembur(token);

    print("sini sini");
    // print(photo);
    print(preferences);
  }

  int jlh_cuti = 0;
  int jlh_lembur = 0;

  datatotalcuti(token) async {
    try {
      final response = await http.get(
          Uri.parse(BaseUrl.apiBaseUrl + 'total-cuti-unapproved'),
          headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        var data = result['data'];
        if (data.isNotEmpty) {
          setState(() {
            jlh_cuti = int.parse(data['total'].toString());
            print(jlh_cuti);
            print('tes jlh cuti');
          });
        }
      }
    } catch (e) {
      print(e);
      // showErrorDialogTokenerror({
      //   'message': 'Waktu Habis',
      //   'errors': {
      //     'exception': ["Silahkan Login Kembali"]
      //   }
      // });
    }
  }

  datatotallembur(token) async {
    try {
      final response = await http.get(
          Uri.parse(BaseUrl.apiBaseUrl + 'total-lembur-unapproved'),
          headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        var data = result['data'];
        if (data.isNotEmpty) {
          setState(() {
            jlh_lembur = int.parse(data['total'].toString());
            print('tes jlh lembur');
            print(jlh_lembur);
          });
        }
      }
    } catch (e) {
      print(e);
      // showErrorDialogTokenerror({
      //   'message': 'Waktu Habis',
      //   'errors': {
      //     'exception': ["Silahkan Login Kembali"]
      //   }
      // });
    }
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).push(
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return new EmptyDataScreen();
                }));
              },
              child: Container(
                height: 170,
                width: double.infinity,
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 16, left: 16),
                  itemCount: mealsListData.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final int count =
                        mealsListData.length > 10 ? 10 : mealsListData.length;
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                    animationController.forward();

                    return CreateDokumenView(
                      mealsListData: mealsListData[index],
                      animation: animation,
                      animationController: animationController,
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CreateDokumenView extends StatefulWidget {
  const CreateDokumenView(
      {Key? key,
      required this.mealsListData,
      required this.animationController,
      required this.animation})
      : super(key: key);

  final CreateDokumenListData mealsListData;
  final AnimationController animationController;
  final Animation<double> animation;

  @override
  _CreateDokumenViewState createState() => _CreateDokumenViewState();
}

class _CreateDokumenViewState extends State<CreateDokumenView> {
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
    datatotalcuti(token);
    datatotallembur(token);

    print(role);
  }

  int jlh_cuti = 0;
  int jlh_lembur = 0;

  datatotalcuti(token) async {
    try {
      final response = await http.get(
          Uri.parse(BaseUrl.apiBaseUrl + 'total-cuti-unapproved'),
          headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        var data = result['data'];
        if (data.isNotEmpty) {
          setState(() {
            jlh_cuti = int.parse(data['total'].toString());
            print(jlh_cuti);
            print('tes jlh cuti');
          });
        }
      }
    } catch (e) {
      print(e);
      // showErrorDialogTokenerror({
      //   'message': 'Waktu Habis',
      //   'errors': {
      //     'exception': ["Silahkan Login Kembali"]
      //   }
      // });
    }
  }

  datatotallembur(token) async {
    try {
      final response = await http.get(
          Uri.parse(BaseUrl.apiBaseUrl + 'total-lembur-unapproved'),
          headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        var data = result['data'];
        if (data.isNotEmpty) {
          setState(() {
            jlh_lembur = int.parse(data['total'].toString());
            print('tes jlh lembur');
            print(jlh_lembur);
          });
        }
      }
    } catch (e) {
      print(e);
      // showErrorDialogTokenerror({
      //   'message': 'Waktu Habis',
      //   'errors': {
      //     'exception': ["Silahkan Login Kembali"]
      //   }
      // });
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
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - widget.animation.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                if (widget.mealsListData.ID == 1) {
                  if (role == 'admin' || role == 'manager') {
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return new EmptyDataScreen();
                    }));
                    // Navigator.of(context).push(
                    //     new MaterialPageRoute(builder: (BuildContext context) {
                    //   return new CreatePortalScreen();
                    // }));
                  } else {
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return new EmptyDataScreen();
                    }));
                  }
                }
                if (widget.mealsListData.ID == 2) {
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (BuildContext context) {
                    return new PengajuanCutiScreen();
                  }));
                }
                if (widget.mealsListData.ID == 3) {
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (BuildContext context) {
                    //return new PengajuanLemburScreen();
                    return new PengajuanLemburScreen();
                  }));
                }
                if (widget.mealsListData.ID == 4) {
                  widget.mealsListData.kacl = int.parse(jlh_cuti.toString());
                  print(role);
                  if (role == 'manager') {
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return new ApprovalCuti();
                    }));
                  } else {
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return new EmptyDataScreen();
                    }));
                  }
                }
                if (widget.mealsListData.ID == 5) {
                  if (role == 'manager') {
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return new ApprovalLembur();
                    }));
                  } else {
                    Navigator.of(context).push(
                        new MaterialPageRoute(builder: (BuildContext context) {
                      return new EmptyDataScreen();
                    }));
                  }
                }
              },
              child: SizedBox(
                width: 130,
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 32, left: 8, right: 8, bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: HexColor(widget.mealsListData.endColor)
                                    .withOpacity(0.6),
                                offset: const Offset(1.1, 4.0),
                                blurRadius: 8.0),
                          ],
                          gradient: LinearGradient(
                            colors: <HexColor>[
                              HexColor(widget.mealsListData.startColor),
                              HexColor(widget.mealsListData.endColor),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(54.0),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 54, left: 16, right: 16, bottom: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.mealsListData.titleTxt,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.5,
                                  letterSpacing: 0.2,
                                  color: FitnessAppTheme.white,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        widget.mealsListData.meals.join('\n'),
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 10,
                                          letterSpacing: 0.2,
                                          color: FitnessAppTheme.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              widget.mealsListData.kacl != 0
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          onTap: () {
                                            //widget.changeIndex(8);
                                          },
                                          child: Container(
                                            child: Text(
                                              widget.mealsListData.ID == 4
                                                  ? widget.mealsListData.kacl =
                                                      int.parse(
                                                          jlh_cuti.toString())
                                                  : widget.mealsListData.ID == 5
                                                      ? widget.mealsListData
                                                              .kacl =
                                                          int.parse(jlh_lembur
                                                              .toString())
                                                      : widget
                                                          .mealsListData.kacl
                                                          .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily:
                                                    FitnessAppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 24,
                                                letterSpacing: 0.2,
                                                color: FitnessAppTheme.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, bottom: 3),
                                          child: Text(
                                            ' Pengajuan',
                                            style: TextStyle(
                                              fontFamily:
                                                  FitnessAppTheme.fontName,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                              letterSpacing: 0.2,
                                              color: FitnessAppTheme.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(
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
                                        padding: const EdgeInsets.all(6.0),
                                        child: Icon(
                                          Icons.add,
                                          color: HexColor(
                                              widget.mealsListData.endColor),
                                          size: 25,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: FitnessAppTheme.nearlyWhite.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 8,
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.asset(widget.mealsListData.imagePath),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

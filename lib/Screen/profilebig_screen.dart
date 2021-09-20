import 'package:hrisv2/listview/profileheaderlist.dart';
import 'package:hrisv2/Screen/course_info_screen.dart';
//import 'package:hrisv2/design_course/popular_course_list_view.dart';
import 'package:hrisv2/listview/ProfileDetail_view.dart';
import 'package:hrisv2/main.dart';
import 'package:flutter/material.dart';
import 'package:hrisv2/Theme/design_course_app_theme.dart';
import 'package:hrisv2/Theme/fitness_app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'dart:convert';
import 'dart:io';

//import 'package:flutter/material.dart';
//import 'package:get/get.dart';
import 'package:hrisv2/Network/baseUrl.dart';
import 'package:hrisv2/util/view_util.dart';
//import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:dotted_line/dotted_line.dart';
import 'package:http/http.dart' as http;
//import 'package:intl/intl.dart';

class ProfileBigScreen extends StatefulWidget {
  @override
  _ProfileBigScreenState createState() => _ProfileBigScreenState();
}

class _ProfileBigScreenState extends State<ProfileBigScreen> {
  CategoryType categoryType = CategoryType.ui;
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
      profilePhotoPath = preferences.getString('profile_photo_path');
      createdAt = preferences.getString('created_at');
      updatedAt = preferences.getString('updated_at');
      role = preferences.getString('role');
      dept = preferences.getString('dept');
    });
    dataclockin(token);
    photo = profilePhotoPath.toString();
  }

  String keteranganin = '';

  String keteranganout = '';

  String statusclockin = '0';

  String signedIn = '';

  String signedOut = '';

  String gabungket = '';

  DateTime TimeSignIn;

  String ConvertTimeSignIn;

  dataclockin(token) async {
    bool cekmasuk = false;
    try {
      final response = await http.get(
          Uri.parse(BaseUrl.apiBaseUrl + 'attendance/cek-masuk'),
          headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        var data = result['data'];
        if (data.isNotEmpty) {
          setState(() {
            signedIn = data['signed_in'].toString();
            // TimeSignIn = new DateFormat("H:M:s").parse(signedIn);
            // ConvertTimeSignIn = TimeSignIn.toString();

            cekmasuk = true;
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
    if (cekmasuk == true) {
      try {
        final response2 = await http.get(
            Uri.parse(BaseUrl.apiBaseUrl + 'attendance/cek-keluar'),
            headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
        final result2 = json.decode(response2.body);
        if (response2.statusCode == 200) {
          var data2 = result2['data'];
          if (data2.isNotEmpty) {
            setState(() {
              signedOut = data2['signed_out'].toString();
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
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/home-full.png"),
        fit: BoxFit.cover,
      )),
      // color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            // getSaldoBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      //getSearchBarUI(),
                      getCategoryUI(),
                      //getSlipGajiUI(),
                      Flexible(
                        child: getPopularCourseUI(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getCategoryUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 16,
        ),
        ProfileHeaderListView(
          callBack: () {
            moveTo();
          },
        ),
      ],
    );
  }

  Widget getSlipGajiUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(
          height: 16,
        ),
        ProfileHeaderListView(
          callBack: () {
            moveTo();
          },
        ),
      ],
    );
  }

  Widget getPopularCourseUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Profile Detail',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
            ),
          ),
          Flexible(
            child: ProfileDetailListView(
              callBack: () {
                moveTo();
              },
            ),
          )
        ],
      ),
    );
  }

  void moveTo() {
    Navigator.push<dynamic>(
      context,
      MaterialPageRoute<dynamic>(
        builder: (BuildContext context) => CourseInfoScreen(),
      ),
    );
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    String txt = '';
    if (CategoryType.ui == categoryTypeData) {
      txt = 'Ui/Ux';
    } else if (CategoryType.coding == categoryTypeData) {
      txt = 'Coding';
    } else if (CategoryType.basic == categoryTypeData) {
      txt = 'Basic UI';
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? DesignCourseAppTheme.nearlyBlue
                : DesignCourseAppTheme.nearlyWhite,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: DesignCourseAppTheme.nearlyBlue)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: isSelected
                        ? DesignCourseAppTheme.nearlyWhite
                        : DesignCourseAppTheme.nearlyBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor('#F8FAFB'),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(13.0),
                    bottomLeft: Radius.circular(13.0),
                    topLeft: Radius.circular(13.0),
                    topRight: Radius.circular(13.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: DesignCourseAppTheme.nearlyBlue,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Search for course',
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: HexColor('#B9BABC'),
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: HexColor('#B9BABC'),
                            ),
                          ),
                          onEditingComplete: () {},
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Icon(Icons.arrow_right_sharp,
                          color: HexColor('#B9BABC')),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Hai',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    color: DesignCourseAppTheme.grey,
                  ),
                ),
                Text(
                  nama.toString(),
                  //userapps
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 0.27,
                    color: DesignCourseAppTheme.darkerText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle, border: Border.all(color: Colors.grey)),
            child: ClipOval(
                child: CachedNetworkImage(
              imageUrl: BaseUrl.apiBaseUrlstorage + photo,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            )),
            // width: 60,
            // height: 60,
            // child: Image.asset('assets/design_course/userImage.png'),
          )
        ],
      ),
    );
  }

  Widget getSaldoBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Saldo Cuti',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: FitnessAppTheme.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    letterSpacing: -0.2,
                    color: FitnessAppTheme.darkText,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Container(
                    height: 4,
                    width: 70,
                    decoration: BoxDecoration(
                      color: HexColor('#87A0E5').withOpacity(0.2),
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: ((70 / 1.2) * 15),
                          height: 4,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              HexColor('#87A0E5'),
                              HexColor('#87A0E5').withOpacity(0.5),
                            ]),
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.0)),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '-- days',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FitnessAppTheme.fontName,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: FitnessAppTheme.grey.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Terlambat',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: FitnessAppTheme.fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: -0.2,
                        color: FitnessAppTheme.darkText,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        height: 4,
                        width: 70,
                        decoration: BoxDecoration(
                          color: HexColor('#F56E98').withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: ((70 / 2) * 15),
                              height: 4,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  HexColor('#F56E98').withOpacity(0.1),
                                  HexColor('#F56E98'),
                                ]),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '-- times',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: FitnessAppTheme.fontName,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: FitnessAppTheme.grey.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Lembur',
                      style: TextStyle(
                        fontFamily: FitnessAppTheme.fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        letterSpacing: -0.2,
                        color: FitnessAppTheme.darkText,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0, top: 4),
                      child: Container(
                        height: 4,
                        width: 70,
                        decoration: BoxDecoration(
                          color: HexColor('#F1B440').withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: ((70 / 2.5) * 15),
                              height: 4,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  HexColor('#F1B440').withOpacity(0.1),
                                  HexColor('#F1B440'),
                                ]),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        '-- hours',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: FitnessAppTheme.fontName,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: FitnessAppTheme.grey.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

enum CategoryType {
  ui,
  coding,
  basic,
}

import 'package:flutter_human_resources_information_sistem/Theme/fitness_app_theme.dart';
import 'package:flutter_human_resources_information_sistem/main.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_human_resources_information_sistem/Network/baseUrl.dart';
import 'package:flutter_human_resources_information_sistem/util/view_util.dart';
import 'package:cached_network_image/cached_network_image.dart';

// import 'package:flutter_human_resources_information_sistem/Theme/fitness_app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class ProfilEdLV extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;

  const ProfilEdLV({Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  _ProfilEdLVState createState() => _ProfilEdLVState();
}

class _ProfilEdLVState extends State<ProfilEdLV> {
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
    dataclockin(token);
    print("sini sini");
    // print(photo);
    print(preferences);
  }

  String keteranganin = '';

  String keteranganout = '';

  String statusclockin = '0';

  String signedIn = '';

  String signedOut = '';

  String gabungket = '';

  String nickname = '';
  String mobile_phone = '';
  String joindate = '';
  String IdentityNo = '';
  String employeeCode = '';
  String Sex = '';
  String Birthdate = '';
  String BirthPlace = '';

  String Schoolname = '';
  String AcademilevelName = '';
  String Major = '';
  String Degree = '';
  String StartYear = '';
  String EndYear = '';
  String Remarks = '';
  String FlagCertivicate = '';
  String Result = '';

  dataProfil(token) async {
    try {
      final response = await http.get(Uri.parse(BaseUrl.apiBaseUrl + 'profile'),
          headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        var data = result['data']['profile'];
        if (data.isNotEmpty) {
          setState(() {
            nickname = data['nickname'].toString();
            mobile_phone = data['mobile_phone'].toString();
            joindate = data['join_date'].toString();
            IdentityNo = data['identity_no'].toString();
            employeeCode = data['employee_code'].toString();
            Sex = data['sex'].toString();
            Birthdate = data['birth_date'].toString();
            BirthPlace = data['birth_place'].toString();
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
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.animation.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8.0),
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                      topRight: Radius.circular(68.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey.withOpacity(0.2),
                        offset: Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 4),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 48,
                                        width: 2,
                                        decoration: BoxDecoration(
                                          color: HexColor('#87A0E5')
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4, bottom: 2),
                                              child: Text(
                                                'Department : ',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FitnessAppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  letterSpacing: -0.1,
                                                  color: FitnessAppTheme.grey
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 28,
                                                  height: 28,
                                                  child: Image.asset(
                                                      "assets/fitness_app/eaten.png"),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 4, bottom: 3),
                                                  child: (dept == null)
                                                      ? Text("-")
                                                      : Text(
                                                          dept,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                FitnessAppTheme
                                                                    .fontName,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 12,
                                                            letterSpacing: -0.2,
                                                            color:
                                                                FitnessAppTheme
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.5),
                                                          ),
                                                        ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        height: 48,
                                        width: 2,
                                        decoration: BoxDecoration(
                                          color: HexColor('#F56E98')
                                              .withOpacity(0.5),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4, bottom: 2),
                                              child: Text(
                                                'NIK',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FitnessAppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  letterSpacing: -0.1,
                                                  color: FitnessAppTheme.grey
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                SizedBox(
                                                  width: 28,
                                                  height: 28,
                                                  child: Image.asset(
                                                      "assets/fitness_app/burned.png"),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8, bottom: 3),
                                                  child: Text(
                                                    employeeCode,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FitnessAppTheme
                                                              .fontName,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12,
                                                      letterSpacing: -0.2,
                                                      color: FitnessAppTheme
                                                          .grey
                                                          .withOpacity(0.5),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Center(
                              child: Stack(
                                overflow: Overflow.visible,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          color: FitnessAppTheme.white,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(100.0),
                                          ),
                                          border: new Border.all(
                                              width: 4,
                                              color: FitnessAppTheme.cgiblue
                                                  .withOpacity(0.2)),
                                        ),
                                        child: Container(
                                          width: 70.0,
                                          height: 70.0,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.grey)),
                                          child: ClipOval(
                                              child: CachedNetworkImage(
                                            imageUrl:
                                                // "http://10.9.2.209:8000" +
                                                BaseUrl.serverUrl + photo,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          )),
                                          // width: 60,
                                          // height: 60,
                                          // child: Image.asset('assets/design_course/userImage.png'),
                                        )),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: CustomPaint(
                                      painter: CurvePainter(
                                          colors: [
                                            FitnessAppTheme.cgiblue,
                                            HexColor("#8A98E8"),
                                            HexColor("#8A98E8")
                                          ],
                                          angle: 140 +
                                              (360 - 140) *
                                                  (1.0 -
                                                      widget.animation.value)),
                                      child: SizedBox(
                                        width: 108,
                                        height: 108,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 8),
                      child: Container(
                        height: 2,
                        decoration: BoxDecoration(
                          color: FitnessAppTheme.background,
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: Image.asset("assets/fitness_app/burned.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 2),
                            child: (nama == null)
                                ? Text("-")
                                : Text(
                                    'Nama : ' + nama,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: -0.1,
                                      color:
                                          FitnessAppTheme.grey.withOpacity(0.5),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: Image.asset("assets/fitness_app/burned.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 2),
                            child: (Sex == null)
                                ? Text("-")
                                : Text(
                                    'Nama Sekolah : ' + Sex,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: -0.1,
                                      color:
                                          FitnessAppTheme.grey.withOpacity(0.5),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: Image.asset("assets/fitness_app/burned.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 2),
                            child: (email == null)
                                ? Text("-")
                                : Text(
                                    'Jenjang Pendidikan : ' + email,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: -0.1,
                                      color:
                                          FitnessAppTheme.grey.withOpacity(0.5),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: Image.asset("assets/fitness_app/burned.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 2),
                            child: (IdentityNo == null)
                                ? Text("-")
                                : Text(
                                    'Gelar : ' + IdentityNo,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: -0.1,
                                      color:
                                          FitnessAppTheme.grey.withOpacity(0.5),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: Image.asset("assets/fitness_app/burned.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 2),
                            child: (mobile_phone == null)
                                ? Text("-")
                                : Text(
                                    'Tahun Mulai : ' + mobile_phone,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: -0.1,
                                      color:
                                          FitnessAppTheme.grey.withOpacity(0.5),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: Image.asset("assets/fitness_app/burned.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 2),
                            child: (BirthPlace == null)
                                ? Text("-")
                                : Text(
                                    'Tahun Berakhir : ' +
                                        BirthPlace +
                                        ', ' +
                                        Birthdate,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: -0.1,
                                      color:
                                          FitnessAppTheme.grey.withOpacity(0.5),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: Image.asset("assets/fitness_app/burned.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 5),
                            child: (joindate == null)
                                ? Text("-")
                                : Text(
                                    'Remarks : ' + joindate,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: -0.1,
                                      color:
                                          FitnessAppTheme.grey.withOpacity(0.5),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: Image.asset("assets/fitness_app/burned.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 5),
                            child: (joindate == null)
                                ? Text("-")
                                : Text(
                                    'Certificate : ' + joindate,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: -0.1,
                                      color:
                                          FitnessAppTheme.grey.withOpacity(0.5),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 16, left: 16, right: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 28,
                            height: 28,
                            child: Image.asset("assets/fitness_app/burned.png"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 5),
                            child: (joindate == null)
                                ? Text("-")
                                : Text(
                                    'Result : ' + joindate,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      letterSpacing: -0.1,
                                      color:
                                          FitnessAppTheme.grey.withOpacity(0.5),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
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

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color> colors;

  CurvePainter({this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = List<Color>();
    if (colors != null) {
      colorsList = colors;
    } else {
      colorsList.addAll([Colors.white, Colors.white]);
    }

    final shdowPaint = new Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final shdowPaintCenter = new Offset(size.width / 2, size.height / 2);
    final shdowPaintRadius =
        math.min(size.width / 2, size.height / 2) - (14 / 2);
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.3);
    shdowPaint.strokeWidth = 16;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.2);
    shdowPaint.strokeWidth = 20;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    shdowPaint.color = Colors.grey.withOpacity(0.1);
    shdowPaint.strokeWidth = 22;
    canvas.drawArc(
        new Rect.fromCircle(center: shdowPaintCenter, radius: shdowPaintRadius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        shdowPaint);

    final rect = new Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = new SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = new Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    final center = new Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(
        new Rect.fromCircle(center: center, radius: radius),
        degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)),
        false,
        paint);

    final gradient1 = new SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = new Paint();
    cPaint..shader = gradient1.createShader(rect);
    cPaint..color = Colors.white;
    cPaint..strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(new Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}

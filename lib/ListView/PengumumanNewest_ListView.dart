import 'package:hrisv2/Theme/fitness_app_theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:hrisv2/Network/baseUrl.dart';
import 'package:hrisv2/util/view_util.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:downloader/downloader.dart';

class PengumumanNewest_ListView extends StatefulWidget {
  final AnimationController animationController;
  final Animation animation;

  const PengumumanNewest_ListView(
      {Key key, this.animationController, this.animation})
      : super(key: key);

  @override
  _PengumumanNewest_ListViewState createState() =>
      _PengumumanNewest_ListViewState();
}

class _PengumumanNewest_ListViewState extends State<PengumumanNewest_ListView> {
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
    dataNewPengumumanUmum(token);
  }

  String keteranganin = '';

  String keteranganout = '';

  String statusclockin = '0';

  String signedIn = '';

  String signedOut = '';

  String gabungket = '';

  String judul = '';
  String body_portal = '';
  String created_at1 = '';
  String link = '';
  String dokumenportal = '';
  //const htmlData = ;

  dataNewPengumumanUmum(token) async {
    try {
      final response = await http.get(
          Uri.parse(BaseUrl.apiBaseUrl + 'last-portal-umum'),
          headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
      final result = json.decode(response.body);
      if (response.statusCode == 200) {
        var data = result['data'];
        print(data);
        if (data.isNotEmpty) {
          setState(() {
            judul = data['judul'].toString();
            body_portal = data['body_portal'].toString();
            created_at1 = Jiffy(data['created_at']).fromNow().toString();
            link = data['link'].toString();
            dokumenportal = data['dokumen_portal'].toString();
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
    Downloader.getPermission();
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
              padding: const EdgeInsets.only(
                  left: 24, right: 24, top: 16, bottom: 18),
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
                          const EdgeInsets.only(top: 16, left: 16, right: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 4, bottom: 8, top: 16),
                            child: Text(
                              judul,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  letterSpacing: -0.1,
                                  color: FitnessAppTheme.darkText),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Text(
                              created_at1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                letterSpacing: 0.0,
                                color: FitnessAppTheme.grey.withOpacity(0.5),
                              ),
                            ),
                          ),
                          Html(
                            data: body_portal,
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
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  Icons.read_more_rounded,
                                  color: FitnessAppTheme.grey,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(
                                    'Details',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: FitnessAppTheme.fontName,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color:
                                          FitnessAppTheme.grey.withOpacity(0.5),
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[],
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    (dokumenportal == null)
                                        ? Icon(Icons.downloading_rounded,
                                            color: FitnessAppTheme.grey)
                                        : new IconButton(
                                            icon: new Icon(
                                                Icons.downloading_rounded),
                                            color: Colors.green,
                                            onPressed: () {
                                              var splitDoc =
                                                  dokumenportal.split("/");
                                              var namedocExt =
                                                  splitDoc[splitDoc.length - 1]
                                                      .split(".");
                                              var namedoc = namedocExt[0];
                                              var docExt = namedocExt[1];
                                              print('nihtomboldownload2');

                                              Downloader.download(
                                                  BaseUrl.apiBaseUrlstorage +
                                                      dokumenportal,
                                                  namedoc.toString(),
                                                  "." + docExt.toString());
                                            }),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        'Download',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: FitnessAppTheme.fontName,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                          color: Colors.green.withOpacity(0.5),
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

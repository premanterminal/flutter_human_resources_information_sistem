import 'dart:convert';
import 'dart:ui';

import 'package:hrisv2/Network/baseUrl.dart';
import 'package:hrisv2/util/view_util.dart';
import 'package:intl/intl.dart';

import 'MapsClock.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class Attandance extends StatefulWidget {
  const Attandance({this.signedIn, this.signedOut});

  final signedIn;
  final signedOut;

  @override
  _AttandanceState createState() => _AttandanceState();
}

class _AttandanceState extends State<Attandance> {
  @override
  void initState() {
    super.initState();
    getPref();
    //fnLongLat();
    timecInOut();
  }

  fnLongLat() async {
    final response =
        await http.post(Uri.parse(BaseUrl.apiBaseUrlAtt + 'list_polygon.php '));
    final result = json.decode(response.body);
    final Map<int, List> dataLongLat = {};
    for (int i = 0; i < result.length; i++) {
      print(result[i]['titik1']);
      setState(() {
        dataLongLat[i] = [
          result[i]['titik1'],
          result[i]['titik2'],
          result[i]['titik3'],
          result[i]['titik4']
        ];
      });
    }
    print(dataLongLat);
  }

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
  var identityNo;
  var token;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
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
      identityNo = preferences.getString('identityNo');
    });
    dataclockin(token);
  }

  String keteranganin = '';

  String keteranganout = '';

  String statusclockin = '0';

  String signedIn_ = '';

  String signedOut_ = '';

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
            signedIn_ = data['signed_in'].toString();
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
              signedOut_ = data2['signed_out'].toString();
              print('testing ini lo');
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

  toMapAbsen(clockket) {
    if (clockket.isNotEmpty) {
      Navigator.of(context)
          .push(new MaterialPageRoute(builder: (BuildContext context) {
        return new MapsClock(
          clockket: clockket,
        );
      }));
    }
  }

  //String izinAbsen = '-1';
  String izinAbsen = '-1';
  String keteranganabsen = 'Anda belum bisa absen';
  String setInOut = '';
  String jamAbsen = '';
  Widget widKetAbsen = SizedBox();
  timecInOut() async {
    final response =
        await http.post(Uri.parse(BaseUrl.apiBaseUrlAtt + 'time_in_out.php'));
    final result = json.decode(response.body);
    print(result);

    if (response.statusCode == 200) {
      setState(() {
        izinAbsen = result[0]['status'];
        keteranganabsen = result[0]['keterangan'];
      });
      if (izinAbsen == '1') {
        print('absen 1');
        setState(() {
          if (widget.signedIn != null) {
            var dateAwal =
                DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.signedIn);
            jamAbsen = DateFormat.Hm().format(dateAwal).toString();
            keteranganabsen =
                'Terimakasih, Anda sudah melakukan absensi hari ini';
            widKetAbsen = ketSudahAbsen(keteranganabsen);
          } else {
            setInOut = "In";
            keteranganabsen =
                'Anda Belum Melakukan absen pada hari ini, \nSilahkan melakukan absensi';
            widKetAbsen = ketBelumAbsen(keteranganabsen, setInOut);
          }

          //testing belum absen
          // setInOut = "In";
          // keteranganabsen =
          //     'Anda Belum Melakukan absen pada hari ini, \nSilahkan melakukan absensi';
          // widKetAbsen = ketBelumAbsen(keteranganabsen, setInOut);
        });
        print(widget.signedIn);
      } else if (izinAbsen == '2') {
        setState(() {
          //dataclockin(token);
          print('absen 2');
          print(widget.signedOut);
          print(signedOut_);
          if (widget.signedOut != null) {
            var dateAwal =
                DateFormat("yyyy-MM-dd hh:mm:ss").parse(widget.signedOut);
            jamAbsen = DateFormat.Hm().format(dateAwal).toString();
            keteranganabsen =
                'Terimakasih, Anda sudah melakukan absensi Keluar hari ini';
            widKetAbsen = ketSudahAbsen(keteranganabsen);
          } else {
            setInOut = "Out";
            keteranganabsen =
                'Anda Belum Melakukan absen keluar pada hari ini, \nSilahkan melakukan absensi';
            widKetAbsen = ketBelumAbsen(keteranganabsen, setInOut);
          }
          // setInOut = "Out";
          // keteranganabsen =
          //     'Anda Belum Melakukan absen keluar pada hari ini, \nSilahkan melakukan absensi';
          // widKetAbsen = ketBelumAbsen(keteranganabsen, setInOut);
        });
      } else {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Perhatian'),
            content: const Text('Error Keterangan Absen'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Ok'),
                child: const Text('OK'),
              )
            ],
          ),
          //   {

          //   'message': 'Perhatian',
          //   'errors': {
          //     'exception': [keteranganabsen]
          //   }
          // }
        );
        // showToast(keteranganabsen);
      }
    } else {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Perhatian'),
          content: const Text('Error Response'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Ok'),
              child: const Text('OK'),
            )
          ],
        ),
        // {
        //   'message': 'Perhatian',
        //   'errors': {
        //     'exception': ["error respose"]
        //   }
        //}
      );
    }
  }

  void showToast(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/background.png"),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // appBar: AppBar(
          //   iconTheme: IconThemeData(color: Colors.red),
          //   backgroundColor: Colors.transparent,
          //   elevation: 0.0,
          //   actions: [
          //     Container(
          //       margin: EdgeInsets.all(5),
          //       decoration: new BoxDecoration(
          //         color: Colors.white,
          //         borderRadius: BorderRadius.circular(15),
          //       ),
          //       child: IconButton(
          //           onPressed: () {},
          //           icon: Image.asset(
          //             'assets/images/profile.png',
          //           )),
          //     ),
          //   ],
          // ),
          // drawer: Drawer(
          //   child: ListView(
          //     padding: EdgeInsets.zero,
          //     children: <Widget>[
          //       // DrawerHeader(
          //       //   child: Text('Drawer Header'),
          //       //   decoration: BoxDecoration(
          //       //     color: Colors.blue,
          //       //   ),
          //       // ),
          //       ListTile(
          //         title: Text('Item 1'),
          //         onTap: () {
          //           Navigator.pop(context);
          //         },
          //       ),
          //       ListTile(
          //         title: Text('Item 2'),
          //         onTap: () {
          //           Navigator.pop(context);
          //         },
          //       ),
          //     ],
          //   ),
          // ),
          body: SingleChildScrollView(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.topLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "I'm Here",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              DateFormat('EEEE, d MMMM y')
                                      .format(DateTime.now()) ??
                                  "",
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 30,
                      ),
                      widKetAbsen,
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget ketBelumAbsen(keteranganabsen, setInOut) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            keteranganabsen,
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
            style: TextStyle(fontSize: 25),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 20,
        ),
        GestureDetector(
          onTap: () {
            toMapAbsen(setInOut);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (BuildContext context) => SignUp(
            //       cameraDescription: cameraDescription,
            //     ),
            //   ),
            // );
          },
          child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                'Absensi Sekarang',
                style: TextStyle(fontSize: 18, color: Colors.white),
              )),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
            padding: EdgeInsets.only(left: 100),
            child: Image.asset(
              'assets/images/robot-absensi.png',
              height: 350,
            )),
      ],
    );
  }

  Widget ketSudahAbsen(keteranganabsen) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            child: Image.asset(
          'assets/images/hadir.png',
          height: 250,
        )),
        SizedBox(
          height: 8.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Text(
            keteranganabsen,
            overflow: TextOverflow.ellipsis,
            maxLines: 5,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 20,
        ),
        Container(
            child: Text(
          'Anda melakukan absen pukul',
          style: TextStyle(fontSize: 18, color: Colors.black),
        )),
        Container(
            child: Text(
          jamAbsen,
          style: TextStyle(
              fontSize: 60, color: Colors.red, fontWeight: FontWeight.bold),
        )),
      ],
    );
  }
}

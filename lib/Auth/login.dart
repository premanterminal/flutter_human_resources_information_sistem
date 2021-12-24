import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter_human_resources_information_sistem/network/baseUrl.dart';
import 'package:flutter_human_resources_information_sistem/util/view_util.dart';
import 'package:imei_plugin/imei_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_human_resources_information_sistem/ScreenHome/fitness_app_home_screen.dart';
import 'package:flutter_human_resources_information_sistem/ScreenHome/home_hrisv2_screen.dart';

import 'package:http/http.dart' as http;

import 'dart:convert';

//import 'Home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  late String email, password;
  bool loadingButton = false;
  bool _obscureTextLogin = true;
  final _key = new GlobalKey<FormState>();

  double getSmallDiameter = Get.width * 2 / 3;

  double getBigDiameter = Get.size.width * 7 / 8;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  checkLogin() {
    FocusScope.of(context).requestFocus(new FocusNode());
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      //showInSnackBar('email dan Password tidak sesuai');
      print('$email, $password');
      setState(() {
        loadingButton = true;
      });
      masuk();
    }
  }

  String hardware;
  String imeiNo;
  String modelName;
  String manufacturer;
  String host;
  getImei() async {
    imeiNo = await ImeiPlugin.getImei();
    // List<String> multiImei =
    //     await ImeiPlugin.getImeiMulti(); //for double-triple SIM phones
    // String uuid = await ImeiPlugin.getId();
    setState(() {});
    print(imeiNo);
  }

  getDeviceInfo() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on ${androidInfo.model}');
      setState(() {
        hardware = androidInfo.hardware.toString();
        modelName = androidInfo.model.toString();
        manufacturer = androidInfo.manufacturer.toString();
        host = androidInfo.host.toString();
      });
    } on PlatformException {
      print('Failed to get platform version.');
    }
  }

  masuk() async {
    print("disini loh we");
    try {
      FocusScope.of(context).requestFocus(new FocusNode());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final response =
          await http.post(Uri.parse(BaseUrl.apiBaseUrl + 'login'), body: {
        'email': email,
        'password': password,
        'model': modelName,
        'manufacturer': manufacturer,
        'hardware_id': hardware,
        'imei': imeiNo
      });

      final result = json.decode(response.body);
      print(result);

      if (response.statusCode == 201) {
        print('masuk sini benar apssword');
        final data = result['data'];
        final datauser = result['data']['user'];
        final datadept = result['data']['user']['departemen'];
        final dataemploye = result['data']['user']['employe'];

        setState(() {
          prefs.setString('photo', result['data']['photo']);
          prefs.setString('token', result['data']['token']);
          prefs.setString('isLogin', '1');
          prefs.setInt('id', datauser['id']);
          prefs.setString('name', dataemploye['fullname'].toString());
          prefs.setString('email', datauser['email'].toString());
          prefs.setString(
              'email_verified_at', datauser['email_verified_at'].toString());
          prefs.setString(
              'current_team_id', datauser['current_team_id'].toString());
          prefs.setString('profile_photo_path', datauser['profile_photo_path']);
          prefs.setString('created_at', datauser['created_at'].toString());
          prefs.setString('updated_at', datauser['updated_at'].toString());
          prefs.setString('role', datauser['role'].toString());
          prefs.setString('idDept', datauser['departemen_id'].toString());
          prefs.setString('dept', datadept['nama_department'].toString());
          prefs.setString(
              'employeeCode', dataemploye['employee_code'].toString());
          prefs.setString('nickname', dataemploye['nickname'].toString());
          prefs.setString('sex', dataemploye['sex'].toString());
          prefs.setString('identityNo', dataemploye['identity_no'].toString());
          prefs.setString('birthPlace', dataemploye['birth_place'].toString());
          prefs.setString('joinDate', dataemploye['join_date'].toString());
          prefs.setString(
              'mobilePhone', dataemploye['mobile_phone'].toString());
          prefs.setString(
              'bankAccountNo', dataemploye['bank_account_no'].toString());
        });
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (BuildContext context) {
          //return new FitnessAppHomeScreen();
          return new HomeHRISv2Screen();
        }));
      } else if (response.statusCode == 401) {
        print('masuk sini salah apssword');
        showErrorDialog({
          'message': 'Kesalahan',
          'errors': {
            'exception': [result['message']]
          }
        });
        setState(() {
          loadingButton = false;
        });
      } else {
        print('masuk sini salah apssword');
        showErrorDialog({
          'message': 'Kesalahan',
          'errors': {
            'exception': [result['message']]
          }
        });
        setState(() {
          loadingButton = false;
        });
      }
    } catch (e) {
      print('masuk sini salah apssword 1');
      //print(e);
      print('masuk sini salah apssword 2');
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Gagal Login'),
          content: const Text('Login Tidak Benar'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Ok'),
              child: const Text('OK'),
            )
          ],
        ),
      );
      // showErrorDialog({
      //   'message': 'Kesalahan',
      //   'errors': {
      //     'exception': ["Login tidak benar"]
      //   }
      // });
      print('masuk sini salah password 3');
      setState(() {
        loadingButton = false;
      });
      // showInSnackBar("Koneksi Gagal");
    }
  }

  void delsession() async {
    print('hapus session');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('isLogin', null);
  }

  @override
  void initState() {
    super.initState();
    delsession();
    getImei();
    getDeviceInfo();
  }

  Widget _buildEmailForm() {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty) {
          return 'Email tidak boleh kosong!';
        }
        return null;
      },
      controller: emailController,
      onSaved: (String val) {
        email = val;
      },
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black87)),
          prefixIcon: Icon(
            Icons.email,
            color: Colors.black87,
          ),
          labelText: 'Email Address',
          labelStyle: TextStyle(color: Colors.black87)),
      style: TextStyle(color: Colors.black87),
    );
  }

  Widget _buildPasswordForm() {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty) {
          return 'Kata sandi tidak boleh kosong!';
        }
        return null;
      },
      obscureText: _obscureTextLogin,
      onSaved: (String val) {
        password = val;
      },
      controller: passwordController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black87)),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureTextLogin = !_obscureTextLogin;
              });
            },
            child: Icon(
              _obscureTextLogin ? Icons.visibility_off : Icons.visibility,
              color: Colors.black87,
            ),
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: Colors.black87,
          ),
          labelText: 'Password',
          labelStyle: TextStyle(color: Colors.black87)),
      style: TextStyle(color: Colors.black87),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        key: _scaffoldKey,
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          )),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 120),
                      child: Align(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Text(hardware.toString()),
                            // Text(manufacturer.toString()),
                            // Text(imeiNo.toString()),
                            // Text(modelName.toString()),
                            // Text(host.toString()),
                            Image.asset(
                              'assets/logo/logo.png',
                              width: Get.width * 0.7,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Welcome To ',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'HRIS',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(5.0, 50, 5.0, 10),
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 25),
                        child: Card(
                          elevation: 6.0,
                          child: Form(
                            key: _key,
                            child: Column(
                              children: <Widget>[
                                _buildEmailForm(),
                                _buildPasswordForm()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: 40.0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                gradient: LinearGradient(
                                    colors: [Colors.black87, Colors.black],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10.0),
                                  onTap: () {
                                    print('masuk');
                                    checkLogin();
                                  },
                                  child: Center(
                                    child: loadingButton
                                        ? SizedBox(
                                            height: 30.0,
                                            width: 30.0,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.white),
                                            ),
                                          )
                                        : Text(
                                            'MASUK',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: Container(
                    //     margin: const EdgeInsets.only(left: 20.0, bottom: 20.0),
                    //     child: InkWell(
                    //       onTap: () {},
                    //       child: Text(
                    //         'Remember me',
                    //         style: TextStyle(color: Colors.black87),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.only(top: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text(
                            //'v1.1.1 (Beta)',
                            'v2.1.13 ',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Sistem Absensi Pegawai Online',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

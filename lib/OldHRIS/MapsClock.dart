import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter_human_resources_information_sistem/util/view_util.dart';
import 'package:flutter_human_resources_information_sistem/ScreenHome/fitness_app_home_screen.dart';
import 'package:flutter_human_resources_information_sistem/Screen/my_diary_screen.dart';
import 'package:flutter_human_resources_information_sistem/ScreenHome/home_hrisv2_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_utils/poly_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:camera/camera.dart';
import '../Network/baseUrl.dart';

class MapsClock extends StatefulWidget {
  final String clockket;
  MapsClock({required this.clockket});
  @override
  _MapsClockState createState() => _MapsClockState();
}

class _MapsClockState extends State<MapsClock> {
  late GoogleMapController _controller;
  //CameraDescription cameraDescription;
  bool _loading = false;
  Position? position;
  Widget? _child;
  bool aksesclockin = false;
  Future<void> getLocation() async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.location);

    if (permission == PermissionStatus.denied) {
      await PermissionHandler()
          .requestPermissions([PermissionGroup.locationAlways]);
    }

    var geolocator = Geolocator();

    GeolocationStatus geolocationStatus =
        await geolocator.checkGeolocationPermissionStatus();

    switch (geolocationStatus) {
      case GeolocationStatus.denied:
        showToast('denied');
        break;
      case GeolocationStatus.disabled:
        showToast('disabled');
        break;
      case GeolocationStatus.restricted:
        showToast('restricted');
        break;
      case GeolocationStatus.unknown:
        showToast('unknown');
        break;
      case GeolocationStatus.granted:
        showToast('Access granted');
        _getCurrentLocation();
    }
  }

  void _onLoading() {
    print("test masuk loading");
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              new CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
    new Future.delayed(new Duration(seconds: 3), () {
      Navigator.pop(context); //pop dialog
      // disini fungsi nya
      clockabsen(identityNo, nama, role, dept, longitudedef.toString(),
          latitudedef.toString());
    });
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    controller.setMapStyle(value);
  }

  // membuat marker lokasi
  Set<Marker> _createMarker() {
    return <Marker>[
      Marker(
          markerId: MarkerId('home'),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: 'Current Location'))
    ].toSet();
  }

  // alert akses GPS
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
  void initState() {
    getLocation();
    fnLongLat();
    super.initState();
    getPref();
  }

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
  var identityNo;
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
      identityNo = preferences.getString('identityNo');
    });
    print(token);
  }

  clockabsen(identityNo, nama, role, dept, long, lat) async {
    print(widget.clockket);
    print(identityNo);
    print(nama);
    print(role);
    print(dept);
    print(token);
    _loading = false;
    if (widget.clockket == 'In') {
      try {
        final response = await http.post(
            Uri.parse(BaseUrl.apiBaseUrl + 'attendance/check-in'),
            headers: {
              HttpHeaders.authorizationHeader: "Bearer " + token
            },
            body: {
              "nik": identityNo,
              "nama": nama,
              "jabatan": role,
              "departemen": dept
            });
        print(response.statusCode);
        if (response.statusCode == 201 || response.statusCode == 200) {
          final result = json.decode(response.body);
          print(result);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (BuildContext context) => SignUp(
          //       cameraDescription: cameraDescription,
          //     ),
          //   ),
          // );
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (BuildContext context) {
            //return new FitnessAppHomeScreen();
            //return new HomeHRISv2Screen();
            return new HomeHRISv2Screen();
          }));
        } else {
          showErrorDialog({
            'message': 'Perhatian',
            'errors': {
              'exception': ['Tidak bisa absen masuk']
            }
          });
        }
      } catch (e) {
        print(e);
        showErrorDialog({
          'message': 'Perhatian',
          'errors': {
            'exception': ['Tidak bisa absen masuk']
          }
        });
      }
    } else if (widget.clockket == 'Out') {
      try {
        final response1 = await http.post(
            Uri.parse(BaseUrl.apiBaseUrl + 'attendance/check-out'),
            headers: {
              HttpHeaders.authorizationHeader: "Bearer " + token
            },
            body: {
              "nik": identityNo,
              "nama": nama,
              "jabatan": role,
              "departemen": dept
            });
        print(response1.statusCode);
        if (response1.statusCode == 201 || response1.statusCode == 200) {
          final result1 = json.decode(response1.body);
          print(result1);
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (BuildContext context) {
            return new HomeHRISv2Screen();
          }));
        } else {
          showErrorDialog({
            'message': 'Perhatian',
            'errors': {
              'exception': ['Tidak bisa absen keluar']
            }
          });
        }
      } catch (e) {
        print(e);
        showErrorDialog({
          'message': 'Perhatian',
          'errors': {
            'exception': ['Tidak bisa absen keluar']
          }
        });
      }
      print(token);
    }
  }

  Map<PolygonId, Polygon> polygons = <PolygonId, Polygon>{};
  double latitudedef = -31.623060136389135;
  double longitudedef = -60.68669021129609;
  void _getCurrentLocation() async {
    Position res = await Geolocator().getCurrentPosition();
    setState(() {
      position = res;
      latitudedef = position.latitude;
      longitudedef = position.longitude;
      cekdalampoly(latitudedef, longitudedef);
    });
  }

  // cek lokasi dalam poligon
  cekdalampoly(latitudedef, longitudedef) async {
    Point point = Point(latitudedef, longitudedef);
    print(latitudedef.toString() + 'disni');

    //get Lat Long from DB
    final response =
        await http.post(Uri.parse(BaseUrl.apiBaseUrlAtt + 'list_polygon.php'));
    final result = json.decode(response.body);
    final Map<int, List<Point>> dataLongLat = {};
    List<bool> cekinPolygon = [];
    for (int i = 0; i < result.length; i++) {
      setState(() {
        dataLongLat[i] = [
          Point(double.parse(result[i]['titik1_lat']),
              double.parse(result[i]['titik1_long'])),
          Point(double.parse(result[i]['titik2_lat']),
              double.parse(result[i]['titik2_long'])),
          Point(double.parse(result[i]['titik3_lat']),
              double.parse(result[i]['titik3_long'])),
          Point(double.parse(result[i]['titik4_lat']),
              double.parse(result[i]['titik4_long'])),
        ];
        cekinPolygon.add(PolyUtils.containsLocationPoly(point, dataLongLat[i]));
      });
    }
    print(cekinPolygon);
    if (cekinPolygon.contains(true)) {
      setState(() {
        aksesclockin = true;
      });
    }
    _child = _mapWidget();
    // print('point is inside polygon?: $cekinPolygon');
  }

  void _addpolygon(pointsLongLat, int urut) {
    final int polygonCount = polygons.length;
    print(pointsLongLat);

    if (polygonCount == 12) {
      return;
    }

    final String polygonIdVal = 'polygon_id_' + urut.toString();
    final PolygonId polygonId = PolygonId(polygonIdVal);
    print(polygonId);

    final Polygon polygon = Polygon(
      polygonId: polygonId,
      consumeTapEvents: true,
      strokeColor: Colors.green[200],
      strokeWidth: 2,
      fillColor: Color.fromRGBO(161, 216, 112, 0.5),
      points: pointsLongLat,
    );

    setState(() {
      polygons[polygonId] = polygon;
    });
  }

  fnLongLat() async {
    final response =
        await http.post(Uri.parse(BaseUrl.apiBaseUrlAtt + 'list_polygon.php'));
    final result = json.decode(response.body);
    final Map<int, List<LatLng>> dataLongLat = {};
    for (int i = 0; i < result.length; i++) {
      setState(() {
        dataLongLat[i] = [
          _createLatLng(double.parse(result[i]['titik1_lat']),
              double.parse(result[i]['titik1_long'])),
          _createLatLng(double.parse(result[i]['titik2_lat']),
              double.parse(result[i]['titik2_long'])),
          _createLatLng(double.parse(result[i]['titik3_lat']),
              double.parse(result[i]['titik3_long'])),
          _createLatLng(double.parse(result[i]['titik4_lat']),
              double.parse(result[i]['titik4_long'])),
        ];
      });
    }
    print(dataLongLat);
    for (int ii = 0; ii < result.length; ii++) {
      _addpolygon(dataLongLat[ii], ii);
    }
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  Widget _mapWidget() {
    return Container(
      child: Stack(
        children: <Widget>[
          // Maps
          GoogleMap(
            mapType: MapType.normal,
            markers: _createMarker(),
            initialCameraPosition: CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 16.0,
            ),
            polygons: Set<Polygon>.of(polygons.values),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
              _setStyle(controller);
            },
          ),

          // button clock in
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 40,
              child: (aksesclockin == false)
                  ? Container(
                      color: Colors.grey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.location_off),
                          Text(
                            "Clock" + widget.clockket,
                            style: TextStyle(
                                fontSize: 18.0, color: Colors.grey[800]),
                          ),
                        ],
                      ))
                  : RaisedButton(
                      color: Colors.blue[200],
                      highlightColor: Colors.green[300],
                      onPressed: () {
                        //_onLoading();
                        clockabsen(identityNo, nama, role, dept,
                            longitudedef.toString(), latitudedef.toString());
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.location_on),
                          Text(
                            "Clock " + widget.clockket,
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     'Google Map',
        //     textAlign: TextAlign.center,
        //     style: TextStyle(color: CupertinoColors.white),
        //   ),
        // ),
        body: _child);
  }
}

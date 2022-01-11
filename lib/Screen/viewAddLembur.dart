import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_human_resources_information_sistem/Model/category.dart';
import 'package:flutter_human_resources_information_sistem/Theme/hotel_app_theme.dart';
import 'package:flutter_human_resources_information_sistem/Model/popular_filter_list.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_human_resources_information_sistem/util/view_util.dart';
import 'package:intl/intl.dart';
import 'package:flutter_human_resources_information_sistem/Network/baseUrl.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_human_resources_information_sistem/Screen/pengajuan_lembur_screen.dart';

class AddLembur extends StatefulWidget {
  @override
  _AddLemburState createState() => _AddLemburState();
}

class _AddLemburState extends State<AddLembur> {
  // SingingCharacter _character = SingingCharacter.kerja;
  String? ket,
      end_date,
      start_date,
      dropdownValue,
      newValue,
      pengajuan,
      _character;

  bool loadingButton = false;
  final format = DateFormat("dd-MM-yyyy HH:mm");
  final pengajuanSelected = TextEditingController();

  final _key = new GlobalKey<FormState>();

  String _selectedType = "";

  TextEditingController ketController = new TextEditingController();

  List<PopularFilterListData> popularFilterListData =
      PopularFilterListData.popularFList;
  List<PopularFilterListData> accomodationListData =
      PopularFilterListData.accomodationList;

  // List<String> typePengajuan = ["Hari Kerja", "Hari Libur"];

  void initState() {
    getPref();
    super.initState();

    // getType(token);
    // pengajuan = dataDefault;
  }

  var selectedValue;

  List typeList = [
    {
      "id": "1",
      "kode": "01",
      "type": "Hari Kerja",
      "created_at": "2021-04-10T05:20:43.057000Z",
      "updated_at": "2021-04-10T05:20:43.057000Z"
    },
    {
      "id": "2",
      "kode": "02",
      "type": "Hari Libur",
      "created_at": "2021-04-10T05:20:43.060000Z",
      "updated_at": "2021-04-10T05:20:43.060000Z"
    }
  ];
  // List typePengajuan = ["Hari Kerja", "Hari Libur"];
  // final List<String> typePengajuan = ["Hari Kerja", "Hari Libur"];

  var test;
  var dataDefault;
  var token;
  var tokenNew;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      token = preferences.getString('token');
    });
    // getProvinceList(token);
    // getType(token);
    tokenNew = token;
  }

  // var token = "210784|FYE1s02aorh1IGW20oNVFn3pVeKtrpDv0G4QIqz6";
  getType(token) async {
    print("test masuk type");
    // token = "210788|TVL1SEqKD8AisLLw7B2uA6pNrdj1b6oDZlmdCLfn";
    try {
      final response = await http.get(
          Uri.parse(BaseUrl.apiBaseUrl + 'tipe/pengajuan-lembur'),
          headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
      Map<String, dynamic> map = json.decode(response.body);
      if (response.statusCode == 200) {
        setState(() {
          // List<dynamic> typeList = map['data'];
          // print(typeList);
        });
      }
    } catch (e) {
      // print('masuk sini salah apssword 1');
      print(e);
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Failed'),
          content: const Text('Gagal Ambil Data'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Ok'),
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  masuk(tokenNew) async {
    print("disini loh we");
    print(token);
    try {
      FocusScope.of(context).requestFocus(new FocusNode());
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      final response =
          await http.post(Uri.parse(BaseUrl.apiBaseUrl + 'lembur'), headers: {
        HttpHeaders.authorizationHeader: "Bearer " + tokenNew
      }, body: {
        'start_date': start_date,
        'end_date': end_date,
        'tipe_pengajuan': _character,
        'keterangan': ket,
      });

      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Sukses'),
          content: const Text('Pengajuan Berhasil di Submit'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                  new MaterialPageRoute(builder: (BuildContext context) {
                //return new FitnessAppHomeScreen();
                return new PengajuanLemburScreen();
              })),
              child: const Text('OK'),
            )
          ],
        ),
      );
      setState(() {
        loadingButton = false;
      });

      print("sukses");
    } catch (e) {
      // print('masuk sini salah apssword 1');
      print(e);
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Failed'),
          content: const Text('Gagal Melakukan Pengajuan Lembur'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Ok'),
              child: const Text('OK'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HotelAppTheme.buildLightTheme().backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _key,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 16, bottom: 3),
                        child: Text(
                          'Waktu Mulai Pengajuan (${format.pattern})',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: MediaQuery.of(context).size.width > 360
                                  ? 14
                                  : 12,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: <Widget>[
                          DateTimeField(
                            decoration: new InputDecoration(
                              isDense: true, // Added this
                              // contentPadding: EdgeInsets.all(8), // Added this
                              border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(5.0)),
                            ),
                            format: format,
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime(1900),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.fromDateTime(
                                      currentValue ?? DateTime.now()),
                                );
                                if (time != null) {
                                  setState(() {
                                    currentValue =
                                        DateTimeField.combine(date, time);
                                    start_date = currentValue.toString();
                                  });
                                  print(currentValue);
                                }
                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
                            },
                          ),
                        ]),
                      ),
                      const Divider(
                        height: 1,
                      ),
                      popularFilter(),
                      const Divider(
                        height: 1,
                      ),
                      distanceViewUI(),
                      const Divider(
                        height: 1,
                      ),
                      allAccommodationUI()
                    ],
                  ),
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.red.shade300,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      print('ini dia apply lembur');
                      cek_filedLembur();
                    },
                    child: Center(
                      child: loadingButton
                          ? SizedBox(
                              height: 30.0,
                              width: 30.0,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : Text(
                              'Apply',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget allAccommodationUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Keterangan',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 14 : 12,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: TextFormField(
            controller: ketController,
            onSaved: (String? val) {
              ket = val;
            },
            keyboardType: TextInputType.multiline,
            minLines: 1, //Normal textInputField will be displayed
            maxLines: 5, // when user presses enter it will adapt to it
            decoration: new InputDecoration(
              labelText: 'Input Keterangan',
              border: OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(5.0)),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget distanceViewUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
          child: Text(
            'Pilih Type Pengajuan',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 14 : 12,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
          child: Column(children: <Widget>[
            //  ganti radio button
            ListTile(
              title: const Text('Hari Kerja'),
              leading: Radio(
                value: "01",
                groupValue: _character,
                onChanged: (value) {
                  setState(() {
                    _character = value as String?;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Hari Libur'),
              leading: Radio(
                value: "02",
                groupValue: _character,
                onChanged: (value) {
                  setState(() {
                    _character = value as String?;
                  });
                },
              ),
            ),
          ]),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget popularFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 0),
          child: Text(
            'Waktu Akhir Pengajuan (${format.pattern})',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 14 : 12,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            DateTimeField(
              decoration: new InputDecoration(
                isDense: true, // Added this
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
              format: format,
              onShowPicker: (context, currentValue2) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue2 ?? DateTime.now(),
                    lastDate: DateTime(2100));
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue2 ?? DateTime.now()),
                  );
                  if (time != null) {
                    setState(() {
                      currentValue2 = DateTimeField.combine(date, time);
                      end_date = currentValue2.toString();
                    });
                    print(currentValue2);
                  }
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue2;
                }
              },
            ),
          ]),
        ),
      ],
    );
  }

  Widget priceBarFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 3),
          child: Text(
            'Waktu Mulai Pengajuan (${format.pattern})',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 14 : 12,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            DateTimeField(
              decoration: new InputDecoration(
                isDense: true, // Added this
                // contentPadding: EdgeInsets.all(8), // Added this
                border: OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(5.0)),
              ),
              format: format,
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  if (time != null) {
                    setState(() {
                      currentValue = DateTimeField.combine(date, time);
                      start_date = currentValue.toString();
                    });
                    print(currentValue);
                  }
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
            ),
          ]),
        ),
      ],
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Form Lembur',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }

  cek_filedLembur() {
    FocusScope.of(context).requestFocus(new FocusNode());
    final form = _key.currentState;
    if (form!.validate()) {
      form.save();
      //showInSnackBar('email dan Password tidak sesuai');
      print('test');
      print(_character);
      setState(() {
        loadingButton = true;
      });

      if (start_date == null ||
          end_date == null ||
          _character == null ||
          ket == null) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Warning'),
            content: const Text('Silahkan Lengkapi Form Pengajuan Lembur !!'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, 'Ok'),
                child: const Text('OK'),
              )
            ],
          ),
        );
        setState(() {
          loadingButton = false;
        });
      } else {
        masuk(token);
      }
      // masuk(token);
      // getType(token);
      // getProvinceList(token);
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_human_resources_information_sistem/listview/range_slider_view.dart';
//import 'package:flutter_human_resources_information_sistem/listview/slider_view.dart';
import 'package:flutter_human_resources_information_sistem/Theme/hotel_app_theme.dart';
import 'package:flutter_human_resources_information_sistem/model/popular_filter_list.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
//import 'package:dropdownfield/dropdownfield.dart';

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final format = DateFormat("dd-MM-yyyy HH:mm");
  final pengajuanSelected = TextEditingController();

  String pengajuan = "";

  List<PopularFilterListData> popularFilterListData =
      PopularFilterListData.popularFList;
  List<PopularFilterListData> accomodationListData =
      PopularFilterListData.accomodationList;

  List<String> typePengajuan = [
    "Izin Additional",
    "Izin diBayarkan",
    "Izin Tidak Masuk",
    "Datang Terlambat Izin Atasan",
    "Datang Terlambat",
    "Cuti Pribadi",
    "Cuti Bersama",
    "Cuti Melahirkan",
    "Cuti Khusus"
  ];
  String _character, pilih, textPilih;
  RangeValues _values = const RangeValues(100, 600);
  double distValue = 50.0;

  void initState() {
    // getPref();
    super.initState();

    // getType(token);
    // pengajuan = dataDefault;
    // pilih = "test ada";
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
                child: Column(
                  children: <Widget>[
                    priceBarFilter(),
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
                      // Navigator.pop(context);
                      cek();
                    },
                    child: Center(
                      child: Text(
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
            'Type of Accommodation',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
              // children: getAccomodationListUI(),
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
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Type Pengajuan Cuti / Izin',
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
                title: (textPilih == null)
                    ? const Text('Pilih Type Pengajuan')
                    : Text(textPilih),
                onTap: () {
                  cek();
                }),
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
                  'Form Cuti dan Izin',
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

  cek() {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          int selectedRadio = 0;
          return SingleChildScrollView(
            child: AlertDialog(
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(children: <Widget>[
                    //  ganti radio button
                    ListTile(
                      dense: true,
                      title: const Text(
                        'Datang Terlambat Izin Atasan',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Radio(
                        value: "01",
                        groupValue: pilih,
                        onChanged: (value) => kasihnilai(context, value),
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text(
                        'Datang Terlambat',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Radio(
                        value: "02",
                        groupValue: pilih,
                        onChanged: (value) => kasihnilai(context, value),
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text(
                        'Izin Additional',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Radio(
                        value: "03",
                        groupValue: pilih,
                        onChanged: (value) => kasihnilai(context, value),
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text(
                        'Izin Dibayarkan',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Radio(
                        value: "04",
                        groupValue: pilih,
                        onChanged: (value) => kasihnilai(context, value),
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text(
                        'Izin Tidak Masuk (belum memiliki hak cuti)',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Radio(
                        value: "05",
                        groupValue: pilih,
                        onChanged: (value) => kasihnilai(context, value),
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text(
                        'Cuti Pribadi',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Radio(
                        value: "06",
                        groupValue: pilih,
                        onChanged: (value) => kasihnilai(context, value),
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text(
                        'Alpha/ Mangkir',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Radio(
                        value: "07",
                        groupValue: pilih,
                        onChanged: (value) => kasihnilai(context, value),
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text(
                        'Sakit dengan SKD',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Radio(
                        value: "08",
                        groupValue: pilih,
                        onChanged: (value) => kasihnilai(context, value),
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text(
                        'Sakit non SKD',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Radio(
                        value: "09",
                        groupValue: pilih,
                        onChanged: (value) => kasihnilai(context, value),
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text(
                        'Cuti Bersama Belum Punya Hak Cuti',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Radio(
                        value: "10",
                        groupValue: pilih,
                        onChanged: (value) => kasihnilai(context, value),
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text(
                        'Cuti Khusus',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Radio(
                        value: "11",
                        groupValue: pilih,
                        onChanged: (value) => kasihnilai(context, value),
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text(
                        'Cuti Melahirkan',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Radio(
                        value: "12",
                        groupValue: pilih,
                        onChanged: (value) => kasihnilai(context, value),
                      ),
                    ),
                    ListTile(
                      dense: true,
                      title: const Text(
                        'Cuti Bersama',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      leading: Radio(
                        value: "13",
                        groupValue: pilih,
                        onChanged: (value) => kasihnilai(context, value),
                      ),
                    ),
                  ]);
                },
              ),
              // actions: <Widget>[
              //   TextButton(
              //     onPressed: () {
              //       Navigator.pop(context);
              //       // kasihnilai(_character);
              //     },
              //     child: const Text('OK'),
              //   )
              // ],
            ),
          );
        });
  }

  void kasihnilai(BuildContext context, String value) {
    // ...

    setState(() {
      pilih = value;
      if (pilih == "01") {
        textPilih = "Datang Terlambat Izin Atasan";
      } else if (pilih == "02") {
        textPilih = "Datang Terlambat";
      } else if (pilih == "03") {
        textPilih = "Izin Additional";
      } else if (pilih == "04") {
        textPilih = "Izin Dibayarkan";
      } else if (pilih == "05") {
        textPilih = "Izin Tidak Masuk (belum memiliki hak cuti)";
      } else if (pilih == "06") {
        textPilih = "Cuti Pribadi";
      } else if (pilih == "07") {
        textPilih = "Alpha/ Mangkir";
      } else if (pilih == "08") {
        textPilih = "Sakit dengan SKD";
      } else if (pilih == "09") {
        textPilih = "Sakit non SKD";
      } else if (pilih == "10") {
        textPilih = "Cuti Bersama Belum Punya Hak Cuti";
      } else if (pilih == "11") {
        textPilih = "Cuti Khusus";
      } else if (pilih == "12") {
        textPilih = "Cuti Melahirkan";
      } else if (pilih == "13") {
        textPilih = "Cuti Bersama";
      }
    });
    Navigator.of(context).pop();
  }
}

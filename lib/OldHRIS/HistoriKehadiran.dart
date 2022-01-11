import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_human_resources_information_sistem/Network/baseUrl.dart';
import 'package:flutter_human_resources_information_sistem/util/view_util.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_human_resources_information_sistem/Screen/profilebig_screen.dart';

class HistoriKehadiran extends StatefulWidget {
  @override
  _HistoriKehadiranState createState() => _HistoriKehadiranState();
}

class _HistoriKehadiranState extends State<HistoriKehadiran> {
  int currentPage = 0;
  int to = 0;
  int total = 0;
  int from = 0;
  int lastPage = 0;
  int perPage = 0;
  String nextpageUrl = '';
  String prevpageUrl = '';
  late List dataKehadiran;
  fnDataKehadiran(token) async {
    final response = await http.get(Uri.parse(BaseUrl.apiBaseUrl + 'kehadiran'),
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
    final result = json.decode(response.body);
    setState(() {
      dataKehadiran = result['data'];
      currentPage = result['current_page'];
      to = result['to'];
      total = result['total'];
      from = result['from'];
      lastPage = result['last_page'];
      perPage = result['per_page'];
      nextpageUrl = result['next_page_url'];
      prevpageUrl = result['prev_page_url'];
    });
  }

  fnDataKehadiranNext(token, urlnext) async {
    if (urlnext == null) {
      showErrorDialog({
        'message': 'Perhatian',
        'errors': {
          'exception': ["Data tidak ada"]
        }
      });
      return;
    }
    setState(() {
      dataKehadiran;
    });
    final response = await http.get(urlnext,
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
    final result = json.decode(response.body);
    setState(() {
      dataKehadiran = result['data'];
      currentPage = result['current_page'];
      to = result['to'];
      total = result['total'];
      from = result['from'];
      lastPage = result['last_page'];
      perPage = result['per_page'];
      nextpageUrl = result['next_page_url'];
      prevpageUrl = result['prev_page_url'];
    });
  }

  fnDataKehadiranPrev(token, urlprev) async {
    if (urlprev == null) {
      showErrorDialog({
        'message': 'Perhatian',
        'errors': {
          'exception': ["Data tidak ada"]
        }
      });
      return;
    }
    setState(() {
      dataKehadiran;
    });
    final response = await http.get(urlprev,
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
    final result = json.decode(response.body);
    setState(() {
      dataKehadiran = result['data'];
      currentPage = result['current_page'];
      to = result['to'];
      total = result['total'];
      from = result['from'];
      lastPage = result['last_page'];
      perPage = result['per_page'];
      nextpageUrl = result['next_page_url'];
      prevpageUrl = result['prev_page_url'];
    });
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
  var codediv;
  var profilePhotoUrl;
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
      codediv = preferences.getString('codediv');
      profilePhotoUrl = preferences.getString('profile_photo_url');
    });
    print(token);
    fnDataKehadiran(token);
  }

  List open = [];
  var substr_time = 'dartlang';

  Widget colomData() {
    return ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: dataKehadiran.length,
        itemBuilder: (BuildContext context, int index) {
          Map loaddata = dataKehadiran[index];
          return Container(
            color: (index % 2 == 1) ? Colors.grey[300] : Colors.white,
            child: ExpansionTile(
                onExpansionChanged: (value) {
                  print(value);
                  setState(() {
                    if (value == true) {
                      open.add(index);
                    } else {
                      open.remove(index);
                    }
                  });
                },
                trailing: SizedBox(),
                leading: Container(
                  margin: EdgeInsets.all(8),
                  child: Image.asset(
                    (open.contains(index))
                        ? 'assets/icon/chevron2.png'
                        : 'assets/icon/chevron1.png',
                    width: 20,
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Container(
                          child: Text(loaddata['Date'] ?? "",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14))),
                    ),
                    Expanded(
                        child: Container(
                      child: Text(
                        loaddata['SignIn'] ?? "",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14),
                      ),
                    )),
                  ],
                ),
                children: <Widget>[
                  ListTile(
                    dense: false,
                    contentPadding: const EdgeInsets.all(0.0),
                    title: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Nomor Karyawan',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(loaddata['employeecode'] ?? "",
                                    style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Sign In',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(loaddata['SignIn'] ?? "",
                                    style: TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Sign Out',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      loaddata['SignOut'] ?? "",
                                      style: TextStyle(fontSize: 12),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
          );
        });
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/bg-list.png"),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: [
              Container(
                margin: EdgeInsets.all(5),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) {
                        return new ProfileBigScreen();
                      }));
                    },
                    icon: Image.asset(
                      'assets/images/profile.png',
                    )),
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'Catatan Kehadiran',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      color: Colors.white),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Container(
                            child: TextFormField(
                          minLines: 1,
                          maxLines: null,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.0),
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search',
                            labelText: 'Search',
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300,
                                fontSize: 12.0),
                          ),

                          //autofocus: true,
                          onChanged: (value) {},
                        )),
                        Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: new BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8))),
                            child: ExpansionTile(
                              trailing: SizedBox(),
                              leading: SizedBox(),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                        child: Text("Tanggal",
                                            style: TextStyle(fontSize: 14))),
                                  ),
                                  Spacer(),
                                  Expanded(
                                    child: Container(
                                        child: Text("Sign in",
                                            style: TextStyle(fontSize: 14))),
                                  ),
                                ],
                              ),
                            )),
                        (dataKehadiran == null)
                            ? Container(
                                margin: EdgeInsets.all(20),
                                child: CircularProgressIndicator())
                            : colomData(),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                child: Text(
                    'Showing 1 to ${perPage.toString()} of ${total.toString()} entries'),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Page '),
                    Container(
                      child: Text(currentPage.toString()),
                    ),
                    Text(' Of ${lastPage.toString()} '),
                    Container(
                      height: 30,
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                fnDataKehadiranNext(token, prevpageUrl);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_outlined,
                                size: 20,
                                color: Colors.white,
                              )),
                          IconButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                fnDataKehadiranNext(token, nextpageUrl);
                              },
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                                size: 20,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter_human_resources_information_sistem/ListView/title_view.dart';
import 'package:flutter_human_resources_information_sistem/ListView/listcuti_view.dart';
import 'package:flutter_human_resources_information_sistem/ListView/glass_view.dart';
import 'package:flutter/material.dart';

import 'package:flutter_human_resources_information_sistem/Theme/fitness_app_theme.dart';
import 'package:flutter_human_resources_information_sistem/Network/baseUrl.dart';
import 'package:flutter_human_resources_information_sistem/util/view_util.dart';

//import 'package:flutter_human_resources_information_sistem/Theme/fitness_app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class ListcutiScreen extends StatefulWidget {
  const ListcutiScreen({Key? key, required this.animationController})
      : super(key: key);

  final AnimationController animationController;
  @override
  _ListcutiScreenState createState() => _ListcutiScreenState();
}

class _ListcutiScreenState extends State<ListcutiScreen>
    with TickerProviderStateMixin {
  late Animation<double> topBarAnimation;

  int currentPage = 0;
  int to = 0;
  int total = 0;
  int from = 0;
  int lastPage = 0;
  int perPage = 0;
  String nextpageUrl = '';
  String prevpageUrl = '';
  late List dataCuti;
  fnDataCuti(token) async {
    final response = await http.get(Uri.parse(BaseUrl.apiBaseUrl + 'cuti'),
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
    final result = json.decode(response.body);
    setState(() {
      dataCuti = result['data'];
      currentPage = result['current_page'];
      to = result['to'];
      total = result['total'];
      from = result['from'];
      lastPage = result['last_page'];
      perPage = result['per_page'];
    });
  }

  fnDataCutiNext(token, urlnext) async {
    if (urlnext == null) {
      showErrorDialog({
        'message': 'Perhatian',
        'errors': {
          'exception': ["Data tidak ada"]
        }
      });
      return;
    }
    final response = await http.get(urlnext,
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
    final result = json.decode(response.body);
    setState(() {
      dataCuti = result['data'];
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

  fnDataCutiPrev(token, urlprev) async {
    if (urlprev == null) {
      showErrorDialog({
        'message': 'Perhatian',
        'errors': {
          'exception': ["Data tidak ada"]
        }
      });
      return;
    }
    final response = await http.get(urlprev,
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
    final result = json.decode(response.body);
    setState(() {
      dataCuti = result['data'];
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
    fnDataCuti(token);
  }

  List open = [];
  Widget colomData() {
    return ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: dataCuti.length,
        itemBuilder: (BuildContext context, int index) {
          Map loaddata = dataCuti[index];
          final offsset = loaddata['start_time'].timseZoneoffset;
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(margin: EdgeInsets.all(8), child: Text("")),
                    Container(
                        margin: EdgeInsets.all(8),
                        child: Text(
                          nama,
                          style: TextStyle(fontSize: 12),
                        )),
                    Container(
                        margin: EdgeInsets.all(8),
                        child: Text(
                          loaddata['kode_pengajuan'] ?? "",
                          style: TextStyle(fontSize: 12),
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
                                  'Mulai',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(loaddata['start_time'].add(offsset) ?? "",
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
                                  'Berakhir',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Text(loaddata['end_time'] ?? "",
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
                                  'Keterangan',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                Container(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      loaddata['keterangan'] ?? "",
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

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    addAllListData();

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  void addAllListData() {
    const int count = 5;

    listViews.add(
      TitleView(
        titleTxt: 'List Cuti Saya',
        subTxt: 'Download',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
        iconhere: Icons.add,
      ),
    );

    listViews.add(
      ListCutiView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );

    listViews.add(
      GlassView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 3, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/bg-home.png"),
        fit: BoxFit.cover,
      )),
      // /color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget? child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FitnessAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FitnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/fitness_app/logo.png',
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.fitHeight,
                                  alignment: Alignment.topLeft,
                                ),
                              ),
                              // child: Text(
                              //   'Logo',
                              //   textAlign: TextAlign.left,
                              //   style: TextStyle(
                              //     fontFamily: FitnessAppTheme.fontName,
                              //     fontWeight: FontWeight.w700,
                              //     fontSize: 22 + 6 - 6 * topBarOpacity,
                              //     letterSpacing: 1.2,
                              //     color: FitnessAppTheme.darkerText,
                              //   ),
                              // ),
                              //),
                            ),
                            // SizedBox(
                            //   height: 38,
                            //   width: 38,
                            //   child: InkWell(
                            //     highlightColor: Colors.transparent,
                            //     borderRadius: const BorderRadius.all(
                            //         Radius.circular(32.0)),
                            //     onTap: () {},
                            //     child: Center(
                            //       child: Icon(
                            //         Icons.notifications,
                            //         color: FitnessAppTheme.grey,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.exit_to_app_sharp,
                                    color: FitnessAppTheme.grey,
                                  ),
                                ),
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
          },
        )
      ],
    );
  }
}

import 'package:flutter_human_resources_information_sistem/ListView/ProfilWorkExperience_LV.dart';
import 'package:flutter_human_resources_information_sistem/ListView/glass_view.dart';
import 'package:flutter/material.dart';

import 'package:flutter_human_resources_information_sistem/Theme/fitness_app_theme.dart';
import 'package:flutter_human_resources_information_sistem/Network/baseUrl.dart';
import 'package:flutter_human_resources_information_sistem/util/view_util.dart';

import 'package:flutter_human_resources_information_sistem/Theme/fitness_app_theme.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_human_resources_information_sistem/Auth/login.dart';

class ProfilWorkExperienceScreen extends StatefulWidget {
  const ProfilWorkExperienceScreen(
      {Key? key, required this.animationController})
      : super(key: key);

  final AnimationController animationController;
  @override
  _ProfilWorkExperienceScreenState createState() =>
      _ProfilWorkExperienceScreenState();
}

class _ProfilWorkExperienceScreenState extends State<ProfilWorkExperienceScreen>
    with TickerProviderStateMixin {
  late Animation<double> topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

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
  // file screen login
  void delsession(token) async {
    print('hapus session');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('isLogin', 'null');
    preferences.setInt('id', 0);
    preferences.setString('name', 'null');
    preferences.setString('email', 'null');
    preferences.setString('email_verified_at', 'null');
    preferences.setString('current_team_id', 'null');
    preferences.setString('profile_photo_path', 'null');
    preferences.setString('created_at', 'null');
    preferences.setString('updated_at', 'null');
    preferences.setString('role', 'null');
    preferences.setString('idDept', 'null');
    preferences.setString('dept', 'null');
    try {
      final response =
          await http.get(Uri.parse(BaseUrl.apiBaseUrl + 'logout'), headers: {
        'Content-Type': 'application/json',
        HttpHeaders.authorizationHeader: "Bearer " + token
      });
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (BuildContext context) {
        //return new FitnessAppHomeScreen();
        return new Login();
      }));
      //Get.off(Login());
    } catch (e) {
      print(e);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (BuildContext context) {
        //return new FitnessAppHomeScreen();
        return new Login();
      }));
    }
  }

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
      ProfilWorkExperienceLV(
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
        image: AssetImage("assets/images/home-full.png"),
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
                                onTap: () {
                                  delsession(token);
                                },
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

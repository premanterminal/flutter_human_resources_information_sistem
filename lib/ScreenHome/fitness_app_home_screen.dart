import 'package:flutter_human_resources_information_sistem/Model/tabIcon_data.dart';
import 'package:flutter_human_resources_information_sistem/Screen/listlembur_screen.dart';
import 'package:flutter_human_resources_information_sistem/Screen/listkehadiran_screen.dart';
import 'package:flutter_human_resources_information_sistem/Screen/listcuti_screen.dart';
// import 'package:flutter_human_resources_information_sistem/Screen/training_screen.dart';
// import 'package:flutter_human_resources_information_sistem/Screen/list_tambah.dart';
// import 'package:flutter_human_resources_information_sistem/Screen/list_tambah_user.dart';
// import 'package:flutter_human_resources_information_sistem/Screen/gaji_screen.dart';
// import 'package:flutter_human_resources_information_sistem/Screen/more_salary_screen.dart';
import 'package:flutter_human_resources_information_sistem/OldHRIS/Attandance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_human_resources_information_sistem/ListView/bottom_bar_view.dart';
import 'package:flutter_human_resources_information_sistem/Theme/fitness_app_theme.dart';
import 'package:flutter_human_resources_information_sistem/Screen/my_diary_screen.dart';
// import 'package:flutter_human_resources_information_sistem/navigation_home_screen.dart';
// import 'package:flutter_human_resources_information_sistem/invite_friend_screen.dart';

class FitnessAppHomeScreen extends StatefulWidget {
  @override
  _FitnessAppHomeScreenState createState() => _FitnessAppHomeScreenState();
}

class _FitnessAppHomeScreenState extends State<FitnessAppHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: FitnessAppTheme.background,
  );

  @override
  void initState() {
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    tabBody = MyDiaryScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/fitness_app/bg-home.png"),
            fit: BoxFit.cover,
          )),
          child: Scaffold(
            //backgroundColor: Colors.transparent,
            body: FutureBuilder<bool>(
              future: getData(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox();
                } else {
                  return Stack(
                    children: <Widget>[
                      tabBody,
                      bottomBar(),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
    // return Container(
    //   color: FitnessAppTheme.background,
    //   child: Scaffold(
    //     //backgroundColor: Colors.transparent,
    //     body: FutureBuilder<bool>(
    //       future: getData(),
    //       builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
    //         if (!snapshot.hasData) {
    //           return const SizedBox();
    //         } else {
    //           return Stack(
    //             children: <Widget>[
    //               tabBody,
    //               bottomBar(),
    //             ],
    //           );
    //         }
    //       },
    //     ),
    //   ),
    // );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          addClick: () {},
          changeIndex: (int index) {
            if (index == 0) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      MyDiaryScreen(animationController: animationController);
                });
              });
            } else if (index == 2) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = ListlemburScreen(
                      animationController: animationController);
                });
              });
            } else if (index == 1) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = ListkehadiranScreen(
                      animationController: animationController);
                });
              });
            } else if (index == 3) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody =
                      ListcutiScreen(animationController: animationController);
                  //GajiScreen(animationController: animationController);
                  //MoreGajiScreen(animationController: animationController);
                });
              });
            } else if (index == 5) {
              animationController.reverse().then<dynamic>((data) {
                if (!mounted) {
                  return;
                }
                setState(() {
                  tabBody = Attandance();
                  //  ListtambahScreen(
                  //     animationController: animationController);
                  // //ListtambahForUserScreen(
                  //    animationController: animationController);
                });
              });
            }
          },
        ),
      ],
    );
  }
}

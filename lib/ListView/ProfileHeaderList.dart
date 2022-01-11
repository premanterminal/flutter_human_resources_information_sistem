// import 'package:flutter_human_resources_information_sistem/Screen/emptydata_screen.dart';
import 'package:flutter_human_resources_information_sistem/Theme/design_course_app_theme.dart';
//import 'package:flutter_human_resources_information_sistem/Model/category.dart';
import 'package:flutter_human_resources_information_sistem/Model/ProfileHeaderModel.dart';
import 'package:flutter_human_resources_information_sistem/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_human_resources_information_sistem/Screen/gaji_screen.dart';
import 'package:flutter_human_resources_information_sistem/Screen/KPIscreen.dart';
import 'package:flutter_human_resources_information_sistem/Screen/changepassword_screen.dart';

class ProfileHeaderListView extends StatefulWidget {
  const ProfileHeaderListView({Key? key, required this.callBack})
      : super(key: key);

  final Function callBack;
  @override
  _ProfileHeaderListViewState createState() => _ProfileHeaderListViewState();
}

class _ProfileHeaderListViewState extends State<ProfileHeaderListView>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        height: 134,
        width: double.infinity,
        child: FutureBuilder<bool>(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: ProfileHeaderModel.categoryList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count = ProfileHeaderModel.categoryList.length > 10
                      ? 10
                      : ProfileHeaderModel.categoryList.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController.forward();

                  return ProfileHeaderView(
                    category: ProfileHeaderModel.categoryList[index],
                    animation: animation,
                    animationController: animationController,
                    callback: () {
                      widget.callBack();
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class ProfileHeaderView extends StatelessWidget {
  const ProfileHeaderView(
      {Key? key,
      required this.category,
      required this.animationController,
      required this.animation,
      required this.callback})
      : super(key: key);

  final VoidCallback callback;
  final ProfileHeaderModel category;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                if (category.IDprofile == 1) {
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (BuildContext context) {
                    //return new EmptyDataScreen();
                    return new GajiScreen(
                        animationController: animationController);
                  }));
                }
                if (category.IDprofile == 2) {
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (BuildContext context) {
                    //return new KPIScreen();
                    return new KPIScreen(
                        animationController: animationController);
                  }));
                }
                if (category.IDprofile == 3) {
                  Navigator.of(context).push(
                      new MaterialPageRoute(builder: (BuildContext context) {
                    return new ChangePasswordScreen(
                        animationController: animationController);
                    //   return new GajiScreen(
                    //       animationController: animationController);
                  }));
                }
              },
              child: SizedBox(
                width: 280,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 48,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: HexColor('#F8FAFB'),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 48 + 24.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Text(
                                              category.title,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 25,
                                                letterSpacing: 0.27,
                                                color: DesignCourseAppTheme
                                                    .darkerText,
                                              ),
                                            ),
                                          ),
                                          const Expanded(
                                            child: SizedBox(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16, right: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: DesignCourseAppTheme
                                                        .nearlyBlue,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 4.8,
                                                            left: 25),
                                                    child: Icon(
                                                      Icons.arrow_right_rounded,
                                                      color:
                                                          DesignCourseAppTheme
                                                              .nearlyWhite,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 24, bottom: 24, left: 16),
                        child: Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16.0)),
                              child: AspectRatio(
                                  aspectRatio: 1.0,
                                  child: Image.asset(category.imagePath)),
                            )
                          ],
                        ),
                      ),
                    ),
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

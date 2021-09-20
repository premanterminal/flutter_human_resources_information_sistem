import 'package:hrisv2/Theme/fitness_app_theme.dart';
import 'package:flutter/material.dart';
// import 'package:hrisv2/Screen/portalpenting_screen.dart';
import 'package:hrisv2/OldHRIS/portal.dart';

class TitlePortalPentingView extends StatelessWidget {
  final IconData iconhere;
  final String titleTxt;
  final String subTxt;
  final AnimationController animationController;
  final Animation animation;

  const TitlePortalPentingView(
      {Key key,
      this.titleTxt: "",
      this.subTxt: "",
      this.animationController,
      this.iconhere,
      this.animation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: new Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation.value), 0.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        titleTxt,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: FitnessAppTheme.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          color: FitnessAppTheme.lightText,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (BuildContext context) {
                          return new Portal();
                        }));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 8),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.all(Radius.circular(
                                        5.0) //                 <--- border radius here
                                    ),
                              ),
                              child: Text(
                                subTxt,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: FitnessAppTheme.fontName,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                  color: FitnessAppTheme.nearlyWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // InkWell(
                    //   highlightColor: Colors.transparent,
                    //   borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    //   onTap: () {
                    //     // Navigator.of(context).push(new MaterialPageRoute(
                    //     //     builder: (BuildContext context) {
                    //     //   return new Attandance();
                    //     // }));
                    //   },
                    //   child: Padding(

                    //   ),
                    // )
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
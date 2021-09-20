import 'package:hrisv2/ScreenHome/home_design_course.dart';
//import 'package:hrisv2/ScreenHome/fitness_app_home_screen.dart';
import 'package:hrisv2/ScreenHome/home_hrisv2_screen.dart';
//import 'package:hrisv2/ScreenHome/home_hrisv2_screen.dart';
import 'package:hrisv2/ScreenHome/hotel_home_screen.dart';
import 'package:flutter/widgets.dart';

class HomeList {
  HomeList({
    this.navigateScreen,
    this.imagePath = '',
  });

  Widget navigateScreen;
  String imagePath;

  static List<HomeList> homeList = [
    HomeList(
      imagePath: 'assets/hotel/hotel_booking.png',
      navigateScreen: HotelHomeScreen(),
    ),
    HomeList(
      imagePath: 'assets/fitness_app/fitness_app.png',
      //navigateScreen: FitnessAppHomeScreen(),
      navigateScreen: HomeHRISv2Screen(),
    ),
    HomeList(
      imagePath: 'assets/design_course/design_course.png',
      navigateScreen: DesignCourseHomeScreen(),
    ),
  ];
}

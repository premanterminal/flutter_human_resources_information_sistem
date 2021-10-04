import 'package:flutter/material.dart';

class TabIconData {
  TabIconData({
    this.imagePath = '',
    this.index = 0,
    this.selectedImagePath = '',
    this.isSelected = false,
    this.animationController,
  });

  String imagePath;
  String selectedImagePath;
  bool isSelected;
  int index;

  AnimationController animationController;

  static List<TabIconData> tabIconsList = <TabIconData>[
    TabIconData(
      imagePath: 'assets/images/all_home.png',
      selectedImagePath: 'assets/images/b&w/all_home.png',
      index: 0,
      isSelected: true,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/images/b&w/all_Attendance.png',
      selectedImagePath: 'assets/images/attendance.png',
      index: 1,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/images/icon-HTRIS-all-KPI-black.png',
      selectedImagePath: 'assets/images/icon-HTRIS-all-KPI.png',
      index: 2,
      isSelected: false,
      animationController: null,
    ),
    TabIconData(
      imagePath: 'assets/images/icon-HTRIS-all-slip-gaji-black.png',
      selectedImagePath: 'assets/images/icon-HTRIS-all-slip-gaji.png',
      index: 3,
      isSelected: false,
      animationController: null,
    ),
  ];
}

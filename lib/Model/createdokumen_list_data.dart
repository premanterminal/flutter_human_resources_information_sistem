class CreateDokumenListData {
  CreateDokumenListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.meals,
    this.kacl = 0,
    this.linkscreen = '',
    this.ID = 0,
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  String linkscreen;
  List<String> meals;
  int kacl;
  int ID;

  static List<CreateDokumenListData> tabIconsList = <CreateDokumenListData>[
    CreateDokumenListData(
      ID: 1,
      imagePath: 'assets/images/buat-portal.png',
      titleTxt: 'Buat Portal',
      kacl: 0,
      meals: <String>[''],
      startColor: '#3fe0e0',
      endColor: '#005f73',
      linkscreen: 'TambahportalScreen()',
    ),
    CreateDokumenListData(
      ID: 2,
      imagePath: 'assets/images/ajukan-cuti.png',
      titleTxt: 'Ajukan Cuti',
      kacl: 0,
      meals: <String>[''],
      startColor: '#cc2b64',
      endColor: '#c92e5f',
      linkscreen: 'TambahcutiScreen()',
    ),
    CreateDokumenListData(
      ID: 3,
      imagePath: 'assets/images/ajukan-overtime.png',
      titleTxt: 'Ajukan Lembur',
      kacl: 0,
      meals: <String>[''],
      startColor: '#606c38',
      endColor: '#283618',
      linkscreen: 'TambahlemburScreen()',
    ),
    CreateDokumenListData(
      ID: 4,
      imagePath: 'assets/images/appr-cuti.png',
      titleTxt: 'Approval Cuti',
      kacl: 5,
      meals: <String>[''],
      startColor: '#FA7D82',
      endColor: '#d62828',
      linkscreen: 'HodCutiScreen()',
    ),
    CreateDokumenListData(
      ID: 5,
      imagePath: 'assets/images/employee_data.png',
      titleTxt: 'Approval Lembur',
      kacl: 2,
      meals: <String>[''],
      startColor: '#738AE6',
      endColor: '#5458ab',
      linkscreen: 'HodlemburScreen()',
    ),
  ];
}

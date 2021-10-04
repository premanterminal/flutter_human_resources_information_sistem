class ProfileHeaderModel {
  ProfileHeaderModel({
    this.title = '',
    this.imagePath = '',
    this.keterangan = '',
    this.IDprofile = 0,
    this.linkscreen = '',
  });

  String title;
  String imagePath;
  String keterangan;
  String linkscreen;
  int IDprofile;

  static List<ProfileHeaderModel> categoryList = <ProfileHeaderModel>[
    // ProfileHeaderModel(
    //   imagePath: 'assets/images/paybill.jpg',
    //   title: 'Slip Gaji',
    //   linkscreen: '',
    //   IDprofile: 1,
    // ),
    // ProfileHeaderModel(
    //   imagePath: 'assets/images/KPI.jpg',
    //   title: 'KPI',
    //   linkscreen: '',
    //   IDprofile: 2,
    // ),
    ProfileHeaderModel(
      imagePath: 'assets/images/ganti-pass-wd.jpg',
      title: 'Change Password',
      linkscreen: '',
      IDprofile: 3,
    ),
  ];

  static List<ProfileHeaderModel> popularCourseList = <ProfileHeaderModel>[
    ProfileHeaderModel(
      imagePath: 'assets/images/profil.png',
      title: 'Identitas Pribadi',
      linkscreen: '',
      IDprofile: 4,
    ),
    ProfileHeaderModel(
      imagePath: 'assets/images/family.png',
      title: 'Anggota Keluarga',
      linkscreen: '',
      IDprofile: 5,
    ),
    ProfileHeaderModel(
      imagePath: 'assets/images/pendidikan.png',
      title: 'Pendidikan',
      linkscreen: '',
      IDprofile: 6,
    ),
    ProfileHeaderModel(
      imagePath: 'assets/images/pengalaman-kerja.png',
      title: 'Pengalaman Kerja',
      linkscreen: '',
      IDprofile: 7,
    ),
  ];
}

import 'dart:convert';
import 'package:downloader/downloader.dart';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_human_resources_information_sistem/Network/baseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';
//import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:jiffy/jiffy.dart';

class Portal extends StatefulWidget {
  @override
  _PortalState createState() => _PortalState();
}

class _PortalState extends State<Portal> {
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
    fnDataPortal(token);
  }

  List dataPortalPenting;
  List dataPortalpengumuman;
  fnDataPortal(token) async {
    final response = await http.get(Uri.parse(BaseUrl.apiBaseUrl + 'portal'),
        headers: {HttpHeaders.authorizationHeader: "Bearer " + token});
    final result = json.decode(response.body);
    setState(() {
      dataPortalPenting = result['data']['y'];
      dataPortalpengumuman = result['data']['n'];
    });
    print(dataPortalPenting);
    print(dataPortalpengumuman.length);
  }

  @override
  void initState() {
    super.initState();
    getPref();
    Downloader.getPermission();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          //backgroundColor: Colors.grey[200],
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,

            leading: Container(
                margin: EdgeInsets.only(top: 8, left: 8),
                child: Image.asset('assets/logo/logo.png')),
            leadingWidth: 300,
            title: Text(
              '',
              style: TextStyle(color: Colors.black),
            ),
            // actions: [
            //   IconButton(
            //     onPressed: () {},
            //     icon: Icon(
            //       Icons.notifications_none_outlined,
            //       color: Colors.red,
            //       size: 30,
            //     ),
            //   ),
            //   IconButton(
            //       onPressed: () {},
            //       icon: Image.asset(
            //         'assets/images/profile.png',
            //       )),
            // ],
          ),
          body: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/home-full.png"))),
              ),
              SingleChildScrollView(
                  child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      // width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xffdc3545),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "Pengumuman Penting",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          (dataPortalPenting == null)
                              ? Container(
                                  margin: EdgeInsets.all(20),
                                  child: CircularProgressIndicator())
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: dataPortalPenting.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Map loaddataPenting =
                                        dataPortalPenting[index];
                                    // Date(loaddataPenting['created_at']);

                                    return timePanelPenting(
                                        loaddataPenting['judul'],
                                        loaddataPenting['body_portal'],
                                        loaddataPenting['author']['name'],
                                        Jiffy(loaddataPenting['created_at'])
                                            .fromNow(),
                                        loaddataPenting['pict_headline'],
                                        loaddataPenting['dokumen_portal']);
                                  }),
                          SizedBox(
                            height: 40,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TimelineTile(
                              alignment: TimelineAlign.start,
                              beforeLineStyle:
                                  LineStyle(color: Colors.grey, thickness: 6),
                              afterLineStyle:
                                  LineStyle(color: Colors.grey, thickness: 6),
                              indicatorStyle: IndicatorStyle(
                                  height: 0, width: 40, indicator: Container()),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xff28a745),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "Pengumuman",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            width: MediaQuery.of(context).size.width / 2,
                            child: TimelineTile(
                              alignment: TimelineAlign.start,
                              beforeLineStyle:
                                  LineStyle(color: Colors.grey, thickness: 6),
                              afterLineStyle:
                                  LineStyle(color: Colors.grey, thickness: 6),
                              indicatorStyle: IndicatorStyle(
                                  height: 0, width: 40, indicator: Container()),
                            ),
                          ),
                          (dataPortalpengumuman == null)
                              ? Container(
                                  margin: EdgeInsets.all(20),
                                  child: CircularProgressIndicator())
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: dataPortalpengumuman.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    Map loaddataPengumuman =
                                        dataPortalpengumuman[index];
                                    print(loaddataPengumuman['dokumen_portal']);
                                    return timePanelPengumuman(
                                        loaddataPengumuman['judul'],
                                        loaddataPengumuman['body_portal'],
                                        loaddataPengumuman['author']['name'],
                                        Jiffy(loaddataPengumuman['created_at'])
                                            .fromNow(),
                                        Jiffy(loaddataPengumuman['created_at'])
                                            .format('dd-MM-yyyy'),
                                        loaddataPengumuman['pict_headline'],
                                        loaddataPengumuman['dokumen_portal']);
                                  }),
                        ],
                      ))),
            ],
          )),
    );
  }

  Widget timePanelPenting(judul, body, author, jam, pictHeadline, dokumen,
      {bool islast = false}) {
    return SizedBox(
      child: TimelineTile(
        isLast: islast,
        alignment: TimelineAlign.start,
        endChild: Container(
          margin: EdgeInsets.only(left: 20, top: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(child: judulTag(author, jam)),
              Divider(
                color: Colors.grey[400],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(judul.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 16)),
                      ),
                      Container(
                        child: (pictHeadline == null)
                            ? SizedBox()
                            : CachedNetworkImage(
                                imageUrl:
                                    BaseUrl.apiBaseUrlstorage + pictHeadline ??
                                        "https://via.placeholder.com/300.png",
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                      ),

//ujicoba
                      // Expanded(
                      //   child: Html(
                      //     data: body.toString(),
                      //   ),
                      // ),
                      // Text(body.toString(),
                      //     style: TextStyle(color: Colors.black87, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                height: 30,
                child: (dokumen == null)
                    ? RaisedButton(
                        onPressed: () {},
                        child: Text(
                          'Unduh Dokumen',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.grey,
                      )
                    : RaisedButton(
                        onPressed: () {
                          var splitDoc = dokumen.split("/");
                          var namedocExt =
                              splitDoc[splitDoc.length - 1].split(".");
                          var namedoc = namedocExt[0];
                          var docExt = namedocExt[1];
                          print('masuk');
                          print(BaseUrl.apiBaseUrlstorage + dokumen);

                          Downloader.download(
                              BaseUrl.apiBaseUrlstorage + dokumen,
                              namedoc.toString(),
                              "." + docExt.toString());

                          print('keluar');
                        },
                        child: Text(
                          'Unduh Dokumen',
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.green,
                      ),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                height: 30,
                child: RaisedButton(
                  onPressed: () {},
                  child: Text(
                    'Selengkapnya',
                    style: TextStyle(color: Colors.white),
                  ),
                  //color: Colors.blue,
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ),
        beforeLineStyle: LineStyle(color: Colors.grey, thickness: 6),
        afterLineStyle: LineStyle(color: Colors.grey, thickness: 6),
        indicatorStyle: IndicatorStyle(
            height: 40,
            width: 40,
            color: Color(0xfffd7e14),
            indicator: Container(
                decoration: BoxDecoration(
                  color: Color(0xfffd7e14),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(Icons.chat_sharp))),
      ),
    );
  }

  Widget timePanelPengumuman(
      judul, body, author, jam, tanggal, pictHeadline, dokumen,
      {bool islast = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0xff001f3f),
            borderRadius: BorderRadius.circular(2),
          ),
          padding: EdgeInsets.all(8),
          child: Text(
            tanggal.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        SizedBox(
          child: TimelineTile(
            isLast: islast,
            alignment: TimelineAlign.start,
            endChild: Container(
              margin: EdgeInsets.only(left: 20, top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(child: judulTag(author, jam)),
                  Divider(
                    color: Colors.grey[400],
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(judul.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 16)),
                          ),
                          Container(
                            child: (pictHeadline == null)
                                ? SizedBox()
                                : CachedNetworkImage(
                                    imageUrl: BaseUrl.apiBaseUrlstorage +
                                            pictHeadline ??
                                        "https://via.placeholder.com/300.png",
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                          ),
                          // ujicoba
                          //   Expanded(
                          //     child: Html(
                          //       data: body.toString(),
                          //     ),
                          //     // Text(body.toString(),

                          //     //     style: TextStyle(color: Colors.black87, fontSize: 12)),
                          //   ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    height: 30,
                    child: (dokumen == null)
                        ? RaisedButton(
                            onPressed: () {},
                            child: Text(
                              'Unduh Dokumen',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.grey,
                          )
                        : RaisedButton(
                            onPressed: () {
                              var splitDoc = dokumen.split("/");
                              var namedocExt =
                                  splitDoc[splitDoc.length - 1].split(".");
                              var namedoc = namedocExt[0];
                              var docExt = namedocExt[1];

                              Downloader.download(
                                  BaseUrl.apiBaseUrlstorage + dokumen,
                                  namedoc.toString(),
                                  "." + docExt.toString());
                            },
                            child: Text(
                              'Unduh Dokumen',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.green,
                          ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    height: 30,
                    child: RaisedButton(
                      onPressed: () {},
                      child: Text(
                        'Selengkapnya',
                        style: TextStyle(color: Colors.white),
                      ),
                      //color: Colors.blue,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
            beforeLineStyle: LineStyle(color: Colors.grey, thickness: 6),
            afterLineStyle: LineStyle(color: Colors.grey, thickness: 6),
            indicatorStyle: IndicatorStyle(
                height: 40,
                width: 40,
                color: Color(0xfffd7e14),
                indicator: Container(
                    decoration: BoxDecoration(
                      color: Color(0xfffd7e14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.chat_sharp))),
          ),
        ),
        SizedBox(
          height: 30,
          width: MediaQuery.of(context).size.width / 2,
          child: TimelineTile(
            alignment: TimelineAlign.start,
            beforeLineStyle: LineStyle(color: Colors.grey, thickness: 6),
            afterLineStyle: LineStyle(color: Colors.grey, thickness: 6),
            indicatorStyle:
                IndicatorStyle(height: 0, width: 40, indicator: Container()),
          ),
        ),
      ],
    );
  }

  Widget judulTag(author, jam) {
    return Container(
        padding: EdgeInsets.only(top: 5, left: 8, right: 8),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                        text: author.toString() + ' ',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'mengirim sebuah postingan',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87))
                        ])),
              ),
              Container(
                margin: EdgeInsets.only(top: 5),
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
                width: MediaQuery.of(context).size.width / 4,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    Spacer(),
                    Text(jam.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 12))
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

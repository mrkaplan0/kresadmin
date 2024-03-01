// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/homepage_header.dart';
import 'package:kresadmin/common_widget/show_photo_widget.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/homepage-admin/add_criteria.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/add_announcement.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/calender_page.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/gallery_settings.dart';
import 'package:kresadmin/homepage-admin/personel_settings/personel_management.dart';
import 'package:kresadmin/homepage-admin/send_notification.dart';
import 'package:kresadmin/homepage-admin/student_settings/fast_rating_page.dart';
import 'package:kresadmin/homepage-admin/student_settings/student_list.dart';
import 'package:kresadmin/homepage-admin/student_settings/student_management.dart';
import 'package:kresadmin/homepage-admin/announcement_page.dart';
import 'package:kresadmin/homepage-admin/photo_gallery.dart';
import 'package:kresadmin/models/photo.dart';
import 'package:kresadmin/models/student.dart';
import 'package:kresadmin/services/messaging_services.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MessagingService _messagingService = MessagingService();
  List<Photo>? album = [];
  List<Map<String, dynamic>> announcements = [];
  Drawer myDrawer = const Drawer();

  String announceTitle = "Duyurular";

  String galleryTitle = "Fotograf Galerisi";

  String calendarTitle = "Etkinlik Takvimi";

  @override
  void initState() {
    super.initState();
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    userModel
        .getPhotoToMainGallery(
            userModel.users!.kresCode!, userModel.users!.kresAdi!)
        .then((value) {
      setState(() {
        album = value;
      });
    });
    userModel
        .getAnnouncements(userModel.users!.kresCode!, userModel.users!.kresAdi!)
        .then((value) {
      if (value.isNotEmpty) {
        setState(() {
          announcements = value;
        });
      }
    });

    _messagingService
        .initialize(onSelectNotification, context, userModel.users!)
        .then(
          (value) => firebaseCloudMessagingListeners(),
        );

    switchDrawer(userModel);
    super.initState();
  }

  void firebaseCloudMessagingListeners() async {
    MessagingService.onMessage
        .listen(_messagingService.invokeLocalNotification);
    MessagingService.onMessageOpenedApp.listen(_pageOpenForOnLaunch);
  }

  _pageOpenForOnLaunch(RemoteMessage remoteMessage) {
    final Map<String, dynamic> message = remoteMessage.data;

    onSelectNotification(jsonEncode(message));
  }

  Future onSelectNotification(String? payload) async {}

  switchDrawer(UserModel userModel) {
    switch (userModel.users!.position) {
      case 'Admin':
        return myDrawer = _adminDrawerMenu(context, userModel);
      case 'Teacher':
        return myDrawer = _teacherDrawerMenu(context, userModel);
      case 'visitor':
        return null;
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ClipOval(
          child: Image.asset(
            "assets/images/logo.png",
            width: 50,
            height: 50,
          ),
        ),
        centerTitle: true,
      ),
      drawer: myDrawer,
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: kdefaultPadding,
                  ),
                  _galleryPart(),
                  _calenderPart(),
                  announcementList(),
                ],
              ),
            )),
      ),
    );
  }

  Widget announcementList() {
    return Column(
      children: [
        HomepageHeader(
            headerTitle: announceTitle,
            onPressed: (() => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AnnouncementPage())))),
        const SizedBox(
          height: 10,
        ),
        announcements.isNotEmpty
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: announcements.length > 3 ? 3 : announcements.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "${announcements[i]['Duyuru Tarihi']}      ${announcements[i]['Duyuru Başlığı']}"),
                        IconButton(
                          icon: const Icon(
                              Icons.keyboard_double_arrow_right_outlined),
                          onPressed: () => _showAnnouncementDetail(
                              announcements[i]['Duyuru Başlığı'],
                              announcements[i]['Duyuru']),
                        )
                      ],
                    ),
                  );
                })
            : const Text("Henüz duyuru yok.")
      ],
    );
  }

  _showAnnouncementDetail(
      String announcementTitle, String? announcementDetail) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(announcementTitle),
            content: SingleChildScrollView(
              // ignore: prefer_if_null_operators
              child: Text(announcementDetail != null
                  ? announcementDetail
                  : "Detay Yok"),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Kapat'),
              )
            ],
          );
        });
  }

  Future<bool> _cikisyap(BuildContext context) async {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await userModel.signOut();
    return sonuc;
  }

  Drawer _adminDrawerMenu(BuildContext context, UserModel userModel) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _drawerHeaderWidget(userModel),
          ListTile(
            title: const Text('Personel Islemleri'),
            leading: const Icon(Icons.person),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PersonelManagement()));
            },
          ),
          ListTile(
            title: const Text('Öğrenci İşlemleri'),
            leading: const Icon(Icons.school_rounded),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StudentManagement()));
            },
          ),
          ListTile(
            title: const Text('Kriter Ekle'),
            leading: const Icon(Icons.star_half_rounded),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddCriteria()));
            },
          ),
          ListTile(
            title: const Text('Bildirim Gönder'),
            leading: const Icon(Icons.phone_android_outlined),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SendNotification()));
            },
          ),
          ListTile(
            title: const Text('Galeri İşlemleri'),
            leading: const Icon(Icons.photo_library),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GallerySettings()));
            },
          ),
          ListTile(
            title: const Text('Duyuru Ekle'),
            leading: const Icon(Icons.announcement),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddAnnouncement()));
            },
          ),
          ListTile(
            title: const Text('Cikis Yap'),
            leading: const Icon(Icons.logout),
            onTap: () {
              Navigator.pop(context);
              _cikisyap(context);
            },
          ),
        ],
      ),
    );
  }

  Drawer _teacherDrawerMenu(BuildContext context, UserModel userModel) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _drawerHeaderWidget(userModel),
          ListTile(
            title: const Text('Öğrenci Listesi'),
            leading: const Icon(Icons.people),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => StudentListPage()));
            },
          ),
          ListTile(
            title: const Text('Öğrenci Değerlendirme'),
            leading: const Icon(Icons.star_rate_outlined),
            onTap: () async {
              Navigator.pop(context);
              List<Student> stuList = [];
              await userModel
                  .getStudentFuture(
                      userModel.users!.kresCode!, userModel.users!.kresAdi!)
                  .then((value) => stuList = value);

              // ignore: use_build_context_synchronously
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => FastRating(stuList)));
            },
          ),
          ListTile(
            title: const Text('Bildirim Gönder'),
            leading: const Icon(Icons.phone_android_outlined),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SendNotification()));
            },
          ),
          ListTile(
            title: const Text('Galeri İşlemleri'),
            leading: const Icon(Icons.photo_library),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GallerySettings()));
            },
          ),
          ListTile(
            title: const Text('Duyuru Ekle'),
            leading: const Icon(Icons.announcement),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddAnnouncement()));
            },
          ),
          ListTile(
            title: const Text('Cikis Yap'),
            leading: const Icon(Icons.logout),
            onTap: () {
              Navigator.pop(context);
              _cikisyap(context);
            },
          ),
        ],
      ),
    );
  }

  DrawerHeader _drawerHeaderWidget(UserModel userModel) {
    return DrawerHeader(
      decoration: const BoxDecoration(
        color: Colors.blueGrey,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Opacity(
                opacity: 0.2,
                child: Icon(
                  Icons.manage_accounts,
                  size: 165,
                  color: Colors.grey.shade200,
                )),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Kreş Adı",
                  style: GoogleFonts.montserrat(
                      color: Colors.grey.shade300,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              Text("${userModel.users!.kresAdi}",
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              Text("Kreş Kodu",
                  style: GoogleFonts.montserrat(
                      color: Colors.grey.shade300,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
              Text("${userModel.users!.kresCode}",
                  style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _galleryPart() {
    return Column(
      children: [
        HomepageHeader(
            headerTitle: galleryTitle,
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PhotoGallery(album: album)))),
        const SizedBox(
          height: 10,
        ),
        _photoGalleryWidget(),
      ],
    );
  }

  Widget _photoGalleryWidget() {
    if (album!.isNotEmpty) {
      return SizedBox(
        height: 160,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: album!.length > 3 ? 3 : album!.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      height: 130,
                      width: 180,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: ExtendedImage.network(
                          album![i].photoUrl,
                          fit: BoxFit.cover,
                          mode: ExtendedImageMode.gesture,
                          cache: true,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      height: 130,
                      width: 180,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.grey.shade200.withOpacity(0.1),
                                Colors.black12.withOpacity(0.3),
                                Colors.black26.withOpacity(0.5),
                              ],
                              stops: const [
                                0.4,
                                0.8,
                                1,
                              ])),
                    ),
                    album![i].info != null
                        ? Positioned(
                            bottom: 35,
                            left: 13,
                            child: Text(
                              album![i].info!,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          )
                        : const Text(""),
                  ],
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ShowPhotoWidget(album![i].photoUrl);
                      });
                },
              );
            }),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 14.0, right: 14),
        child: Container(
          height: 200,
        ),
      );
    }
  }

  Widget _calenderPart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomepageHeader(headerTitle: calendarTitle, onPressed: null),
        GestureDetector(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CalenderPage())),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: SizedBox(
                  child: Image.asset(
                    "assets/images/calender.png",
                    width: 130,
                    height: 130,
                  ),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              const Text(
                "    Sie \n \n                       verfolgen \n \nActivities.",
                style: TextStyle(color: Colors.black26),
                overflow: TextOverflow.fade,
                softWrap: true,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}

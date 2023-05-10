import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/show_photo_widget.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/homepage-visitor/announcement_page.dart';
import 'package:kresadmin/homepage-visitor/photo_gallery.dart';
import 'package:kresadmin/models/photo.dart';

import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Photo>? album = [];
  List<Map<String, dynamic>> announcements = [];

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
        .getAnnouncements(
        userModel.users!.kresCode!, userModel.users!.kresAdi!)
        .then((value) {
      if (value.isNotEmpty) {setState(() {
        announcements = value;
      });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(

          automaticallyImplyLeading: false,
          title: Text(
            "${userModel.users!.kresAdi}",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          actions: [
            IconButton(
              onPressed: () => _cikisyap(context),
              icon: const Icon(Icons.logout),
            ),
          ]),
      body: SingleChildScrollView(
        child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: kdefaultPadding,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Fotoğraf Galerisi",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PhotoGallery(album: album)));
                        },
                        child: const Text(
                          "Tümünü Gör",
                          style: TextStyle(color: Colors.black26),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                photoGalleryWidget(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: GestureDetector(
                    child: Image.asset("assets/images/gallery7.png"),
                    onTap: () {},
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "Duyurular",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 11.0),
                      child: TextButton(
                        onPressed: () { Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AnnouncementPage()));},
                        child: const Text(
                          "Tümünü Gör",
                          style: TextStyle(color: Colors.black26),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: announcementList(),
                ),
              ],
            )),
      ),
    );
  }
  Widget announcementList() {
    if (announcements.isNotEmpty) {
      return ListView.builder(
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
                    icon: const Icon(Icons.keyboard_double_arrow_right_outlined),
                    onPressed: () => _showAnnouncementDetail(
                        announcements[i]['Duyuru Başlığı'],
                        announcements[i]['Duyuru']),
                  )
                ],
              ),
            );
          });
    } else {
      return const Text("Henüz duyuru yok.");
    }
  }
  Widget photoGalleryWidget() {
    if (album!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 15),
        child: SizedBox(
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
                            borderRadius: const BorderRadius.all(
                                 Radius.circular(8)),
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
        ),
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
  _showAnnouncementDetail(
      String announcementTitle, String? announcementDetail) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(announcementTitle),
            content: SingleChildScrollView(
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
}

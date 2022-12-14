import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/show_photo_widget.dart';
import 'package:kresadmin/constants.dart';
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
  @override
  void initState() {
    super.initState();
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    _userModel
        .getPhotoToMainGallery(
            _userModel.users!.kresCode!, _userModel.users!.kresAdi!)
        .then((value) {
      setState(() {
        album = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
          //centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            "${_userModel.users!.kresAdi}",
            style: Theme.of(context)
                .textTheme
                .headline6!
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
                        "Foto??raf Galerisi",
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PhotoGallery(album)));
                        },
                        child: const Text(
                          "T??m??n?? G??r",
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
                            .headline5!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 11.0),
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          "T??m??n?? G??r",
                          style: TextStyle(color: Colors.black26),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text("31.10.2021 - Ho??geldin Yeni Anasayfa!"),
                ),
              ],
            )),
      ),
    );
  }

  Widget photoGalleryWidget() {
    if (album!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 15),
        child: Container(
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
                                const Radius.circular(8)),
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
                              child: Text(
                                album![i].info!,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              bottom: 35,
                              left: 13,
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

  Future<bool> _cikisyap(BuildContext context) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await _userModel.signOut();
    return sonuc;
  }
}

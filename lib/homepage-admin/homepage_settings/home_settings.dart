import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/menu_items.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/add_announcement.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/image_crop.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/photo_editor.dart';
import 'package:kresadmin/homepage-visitor/home_page.dart';
import 'package:kresadmin/homepage-visitor/photo_gallery.dart';
import 'package:kresadmin/models/photo.dart';
import 'package:provider/provider.dart';

class HomeSettings extends StatefulWidget {
  const HomeSettings({Key? key}) : super(key: key);

  @override
  State<HomeSettings> createState() => _HomeSettingsState();
}

class _HomeSettingsState extends State<HomeSettings> {
/*  List<Photo>? album = [];

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
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Anasayfa İşlemleri",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kdefaultPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                shrinkWrap: true,
                children: [
                  MenuItems(
                    itemText: '  Galeriye \n Foto Ekle',
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ImageCrop()));
                    },
                    icon: Icons.person,
                  ),
                  MenuItems(
                    itemText: 'Galeriyi Düzenle',
                    onPress: () {


                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  const PhotoGallery()));
                    },
                    icon: Icons.person,
                  ),
                  MenuItems(
                    itemText: ' Duyuru Ekle',
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddAnnouncement()));
                    },
                    icon: Icons.school_rounded,
                  ),
                  MenuItems(
                    itemText: 'Anasayfa',
                    onPress: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    icon: Icons.star_half_rounded,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

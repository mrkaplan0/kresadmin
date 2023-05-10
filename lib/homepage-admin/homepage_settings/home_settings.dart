import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/menu_items.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/image_crop.dart';
import 'package:kresadmin/homepage-visitor/home_page.dart';
import 'package:kresadmin/homepage-visitor/photo_gallery.dart';
import 'package:kresadmin/models/photo.dart';
import 'package:provider/provider.dart';


class GallerySettings extends StatefulWidget {
  const GallerySettings({Key? key}) : super(key: key);

  @override
  State<GallerySettings> createState() => _GallerySettingsState();
}

class _GallerySettingsState extends State<GallerySettings> {
  List<Photo>? album = [];

@override
  void initState() {
  final UserModel userModel = Provider.of<UserModel>(context, listen: false);
  getPhoto(userModel);
    super.initState();
  }

void getPhoto(UserModel userModel) {
   userModel
      .getPhotoToMainGallery(
      userModel.users!.kresCode!, userModel.users!.kresAdi!)
      .then((value) {album = value;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Galeri İşlemleri",
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
                    icon: Icons.add_a_photo_outlined,
                  ),
                  MenuItems(
                    itemText: 'Galeriyi Düzenle',
                    onPress: () {


                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>  PhotoGallery(album:album,)));
                    },
                    icon: Icons.photo_library_outlined,
                  ),

                  MenuItems(
                    itemText: 'Anasayfa',
                    onPress: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    icon: Icons.home_outlined,
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

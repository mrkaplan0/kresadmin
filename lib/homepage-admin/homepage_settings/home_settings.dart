import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/menu_items.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/add_announcement.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/photo_editor.dart';
import 'package:kresadmin/homepage-visitor/home_page.dart';
import 'package:kresadmin/models/photo.dart';
import 'package:provider/provider.dart';

class HomeSettings extends StatelessWidget {
  const HomeSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Anasayfa İşlemleri",
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(kdefaultPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 5),
                children: [
                  MenuItems(
                    itemColor: itemColor1,
                    itemText: 'Galeriyi Düzenle',
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhotoEditor()));
                    },
                    icon: Icons.person,
                  ),
                  MenuItems(
                    itemColor: itemColor3,
                    itemText: ' Duyuru Ekle',
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddAnnouncement()));
                    },
                    icon: Icons.school_rounded,
                  ),
                  MenuItems(
                    itemColor: itemColor4,
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

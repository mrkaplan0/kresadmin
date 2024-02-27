import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/menu_items.dart';
import 'package:kresadmin/homepage-admin/add_criteria.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/gallery_settings.dart';
import 'package:kresadmin/homepage-admin/personel_settings/personel_management.dart';
import 'package:kresadmin/homepage-admin/send_notification.dart';
import 'package:kresadmin/homepage-admin/student_settings/student_management.dart';
import 'package:kresadmin/homepage-visitor/home_page.dart';
import 'package:provider/provider.dart';

import 'homepage_settings/add_announcement.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AdminHomepageState createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  double fabPaddingLeft = 135;

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            expandedHeight: 200,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Row(
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: visiblityFAB(context, true),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              centerTitle: true,
            ),
            actions: [
              TextButton.icon(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black38),
                ),
                onPressed: () => _cikisyap(context),
                icon: const Icon(Icons.logout),
                label: const Text("Çıkış"),
              ),
            ],
          ),
          bodyWidget(context),
        ],
      ),
    );
  }

  Widget visiblityFAB(BuildContext context, bool iamLeading) {
    if (iamLeading == true) {
      return SizedBox(
        height: 35,
        child: FloatingActionButton(
          mini: true,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
          tooltip: 'Anasayfa',
          elevation: 2,
          backgroundColor: Colors.amber,
          child: const Icon(Icons.home, size: 20, color: Colors.white54),
        ),
      );
    } else {
      return SizedBox(
        height: 70,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage()));
          },
          tooltip: 'Anasayfa',
          elevation: 2,
          backgroundColor: Colors.amber,
          child: const Icon(
            Icons.home,
            size: 40,
            color: Colors.white54,
          ),
        ),
      );
    }
  }

  Widget bodyWidget(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            primary: false,
            shrinkWrap: true,
            children: [
              MenuItems(
                itemText: 'Personel İşlemleri',
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PersonelManagement()));
                },
                icon: Icons.person,
              ),
              MenuItems(
                itemText: ' Öğrenci İşlemleri',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const StudentManagement()));
                },
                icon: Icons.school_rounded,
              ),
              MenuItems(
                itemText: 'Kriter Ekle',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddCriteria()));
                },
                icon: Icons.star_half_rounded,
              ),
              MenuItems(
                itemText: 'Bildirim Gönder',
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SendNotification()));
                },
                icon: Icons.phone_android_outlined,
              ),
              MenuItems(
                itemText: 'Galeri İşlemleri',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const GallerySettings()));
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
            ],
          ),
          Container(
            height: 50,
          )
        ],
      ),
    );
  }

  Future<bool> _cikisyap(BuildContext context) async {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await userModel.signOut();
    return sonuc;
  }
}

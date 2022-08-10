import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/menu_items.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/homepage-admin/add_criteria.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/home_settings.dart';
import 'package:kresadmin/homepage-admin/personel_settings/personel_management.dart';
import 'package:kresadmin/homepage-admin/send_notification.dart';
import 'package:kresadmin/homepage-admin/student_settings/student_management.dart';
import 'package:provider/provider.dart';

class AdminSettings extends StatefulWidget {
  const AdminSettings({Key? key}) : super(key: key);

  @override
  _AdminSettingsState createState() => _AdminSettingsState();
}

class _AdminSettingsState extends State<AdminSettings> {
  @override
  Widget build(BuildContext context) {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF68763),
        centerTitle: true,
        title: Text(
          "Yönetim Paneli",
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.bold),
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
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              infoKres(context, _userModel),
              Positioned(
                top: 200,
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.05,
                bottom: MediaQuery.of(context).size.height * 0.00001,
                child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  shrinkWrap: true,
                  children: [
                    MenuItems(
                      itemText: 'Personel İşlemleri',
                      onPress: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PersonelManagement()));
                      },
                      icon: Icons.person,
                    ),
                    MenuItems(
                      itemText: ' Öğrenci İşlemleri',
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => StudentManagement()));
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
                                builder: (context) =>
                                    const SendNotification()));
                      },
                      icon: Icons.phone_android_outlined,
                    ),
                    MenuItems(
                      itemText: 'Anasayfa İşlemleri',
                      onPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const HomeSettings()));
                      },
                      icon: Icons.person,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget infoKres(BuildContext context, UserModel _userModel) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 45),
      height: 230,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          color: Color(0xFFF68763),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(50))),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(35),
                bottomRight: Radius.circular(35))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            const Text(
              "Kreş Kodu ve Adı",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "${_userModel.users!.kresCode} - ${_userModel.users!.kresAdi}",
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
            const SizedBox(height: 35),
            const Text(
              "Yönetici",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              "${_userModel.users!.username}",
              style: const TextStyle(color: Colors.black, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _cikisyap(BuildContext context) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await _userModel.signOut();
    return sonuc;
  }
}

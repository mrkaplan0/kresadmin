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
              foregroundColor: MaterialStateProperty.all(Colors.black),
            ),
            onPressed: () => _cikisyap(context),
            icon: const Icon(Icons.logout),
            label: const Text("Çıkış"),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(kdefaultPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              infoKres(context, _userModel),
              const SizedBox(
                height: 35,
              ),
              ListView(
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
                              builder: (context) => const SendNotification()));
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
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget infoKres(BuildContext context, UserModel _userModel) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(6),
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 1.5),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: "Kreş Kodu :   ",
              children: [
                TextSpan(
                  text: "${_userModel.users!.kresCode}",
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 18),
                ),
              ],
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Kreş Adı    :   ",
              children: [
                TextSpan(
                  text: "${_userModel.users!.kresAdi}",
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 18),
                ),
              ],
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
          RichText(
            text: TextSpan(
              text: "Yönetici     :   ",
              children: [
                TextSpan(
                  text: "${_userModel.users!.username}",
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 18),
                ),
              ],
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _cikisyap(BuildContext context) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await _userModel.signOut();
    return sonuc;
  }
}

import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/menu_items.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/homepage-admin/add_criteria.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/home_settings.dart';
import 'package:kresadmin/homepage-admin/personel_settings/personel_management.dart';
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
          "Merhaba ${_userModel.users!.kresAdi};",
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton.icon(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.black),
            ),
            onPressed: () => _cikisyap(context),
            icon: Icon(Icons.logout),
            label: Text("Çıkış"),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(kdefaultPadding),
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
                    itemText: 'Personel İşlemleri',
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PersonelManagement()));
                    },
                    icon: Icons.person,
                  ),
                  MenuItems(
                    itemColor: itemColor3,
                    itemText: ' Öğrenci İşlemleri',
                    onPress: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StudentManagement()));
                    },
                    icon: Icons.school_rounded,
                  ),
                  MenuItems(
                    itemColor: itemColor4,
                    itemText: 'Kriter Ekle',
                    onPress: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddCriteria()));
                    },
                    icon: Icons.star_half_rounded,
                  ),
                  MenuItems(
                    itemColor: itemColor2,
                    itemText: 'Bildirim Gönder',
                    onPress: () {},
                    icon: Icons.phone_android_outlined,
                  ),
                  MenuItems(
                    itemColor: itemColor1,
                    itemText: 'Anasayfa İşlemleri',
                    onPress: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => HomeSettings()));
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

  Future<bool> _cikisyap(BuildContext context) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await _userModel.signOut();
    return sonuc;
  }
}

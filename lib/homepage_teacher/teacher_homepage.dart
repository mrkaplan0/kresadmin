import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/menu_items.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/homepage-admin/student_settings/student_list.dart';
import 'package:provider/provider.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({Key? key}) : super(key: key);

  @override
  _TeacherHomePageState createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
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
                    itemColor: itemColor2,
                    itemText: ' Öğrenci Listesi',
                    onPress: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StudentListPage()));
                    },
                    icon: Icons.school_rounded,
                  ),
                  MenuItems(
                    itemColor: Colors.orangeAccent,
                    itemText: 'Bildirim Gönder',
                    onPress: () {},
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

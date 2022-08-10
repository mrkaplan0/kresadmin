import 'package:flutter/material.dart';
import 'package:kresadmin/common_widget/menu_items.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/homepage-admin/personel_settings/add_teacher.dart';
import 'package:kresadmin/homepage-admin/personel_settings/teacher_list.dart';

class PersonelManagement extends StatelessWidget {
  const PersonelManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Personel Yönetim Ekranı",
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      resizeToAvoidBottomInset: true,
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
                    itemText: ' Öğretmen Ekle',
                    onPress: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddTeacher()));
                    },
                    icon: Icons.person_add_alt_1_rounded,
                  ),
                  MenuItems(
                    itemText: 'Öğretmen Listesi',
                    onPress: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TeacherListPage()));
                    },
                    icon: Icons.people_alt_rounded,
                  ),
                  MenuItems(
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
}

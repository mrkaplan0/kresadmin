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
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 5),
                children: [
                  MenuItems(
                    itemColor: itemColor4,
                    itemText: ' Öğretmen Ekle',
                    onPress: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddTeacher()));
                    },
                    icon: Icons.person_add_alt_1_rounded,
                  ),
                  MenuItems(
                    itemColor: itemColor2,
                    itemText: 'Öğretmen Listesi',
                    onPress: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TeacherListPage()));
                    },
                    icon: Icons.people_alt_rounded,
                  ),
                  MenuItems(
                    itemColor: itemColor3,
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

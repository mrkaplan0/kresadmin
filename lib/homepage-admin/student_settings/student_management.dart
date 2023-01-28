import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/menu_items.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/homepage-admin/student_settings/add_Student.dart';
import 'package:kresadmin/homepage-admin/student_settings/fast_rating_page.dart';
import 'package:kresadmin/homepage-admin/student_settings/student_list.dart';
import 'package:kresadmin/models/student.dart';
import 'package:provider/provider.dart';

class StudentManagement extends StatefulWidget {
  @override
  State<StudentManagement> createState() => _StudentManagementState();

  const StudentManagement();
}

class _StudentManagementState extends State<StudentManagement> {
  List<Student>? stuList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Öğrenci Yönetim Ekranı",
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
                    itemText: ' Öğrenci Ekle',
                    onPress: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AddStudent()));
                    },
                    icon: Icons.person_add_alt_1_rounded,
                  ),
                  MenuItems(
                    itemText: 'Öğrenci Listesi',
                    onPress: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StudentListPage()));
                    },
                    icon: Icons.school_rounded,
                  ),
                  MenuItems(
                    itemText: '      Öğrenci \n Değerlendirme',
                    onPress: () async {
                      final UserModel _userModel =
                          Provider.of<UserModel>(context, listen: false);

                      await _userModel
                          .getStudentFuture(_userModel.users!.kresCode!,
                              _userModel.users!.kresAdi!)
                          .then((value) => stuList = value);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FastRating(stuList!)));
                    },
                    icon: Icons.star_rate_outlined,
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

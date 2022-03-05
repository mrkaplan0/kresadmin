import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/homepage-admin/admin_settings.dart';
import 'package:kresadmin/homepage-visitor/home_page.dart';
import 'package:kresadmin/homepage_teacher/teacher_homepage.dart';
import 'package:provider/provider.dart';
import 'signin/login_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: true);

    if (_userModel.state == ViewState.idle) {
      if (_userModel.users == null) {
        return const LoginPage();
      } else {
        switch (_userModel.users!.position) {
          case 'Admin':
            return const AdminSettings();
          case 'Öğretmen':
            return const TeacherHomePage();
          case 'visitor':
            return HomePage();
          default:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      }
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/homepage-admin/home_page.dart';
import 'package:kresadmin/signin/teacher_approval_process.dart';
import 'package:provider/provider.dart';
import 'signin/login_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserModel>(context, listen: true);

    if (userModel.state == ViewState.idle) {
      if (userModel.users == null) {
        return const LoginPage();
      } else if (userModel.users!.isAdmin! == false) {
        return TeacherLandingPage(user: userModel.users!);
      } else {
        return const HomePage();
      }
    } else {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              SizedBox(
                  height: 150,
                  width: 150,
                  child: Image(image: AssetImage('assets/images/logo.png'))),
              CircularProgressIndicator()
            ],
          ),
        ),
      );
    }
  }
}

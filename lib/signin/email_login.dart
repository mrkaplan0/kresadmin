import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/social_button.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/hata_exception.dart';
import 'package:kresadmin/landing_page.dart';
import 'package:kresadmin/models/user.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({Key? key}) : super(key: key);

  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  late String _email, _sifre, firma;
  final String _buttonText = "Giriş";

  final _formKey = GlobalKey<FormState>();

  _formSubmit(BuildContext context) async {
    _formKey.currentState!.save();

    final _userModel = Provider.of<UserModel>(context, listen: false);

    try {
      MyUser _girisYapanUser =
          (await _userModel.signingWithEmailAndPassword(_email, _sifre))!;
      print("Giriş yapan Kullanıcı $_girisYapanUser");
      Navigator.popAndPushNamed(context, '/LandingPage');
    } catch (e) {
      debugPrint('Hata Giriş yaparken hata çıktı: ' + e.toString());
      Get.snackbar('Hata', 'HATA: ' + Hatalar.goster(e.toString()),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserModel _userModel = Provider.of<UserModel>(context);

    if (_userModel.state == ViewState.idle) {
      if (_userModel.users != null) {
        return LandingPage();
      }
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundColor,
        ),
        backgroundColor: backgroundColor,
        body: Container(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Giriş Yap",
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              _userModel.state == ViewState.idle
                  ? SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              initialValue: 'kaplan@kaplan.com',
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 20),
                                  labelText: 'E-mail',
                                  hintText: 'E-mailinizi giriniz...',
                                  errorText: _userModel.emailHataMesaj != null
                                      ? _userModel.emailHataMesaj
                                      : null,
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 10, 10, 10),
                                    child: Icon(Icons.mail_outline_rounded),
                                  )),
                              onSaved: (String? gelenMail) {
                                _email = gelenMail!;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              initialValue: "123456",
                              //obscureText: true,
                              decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 20),
                                  labelText: 'Şifre',
                                  hintText: 'Şifrenizi giriniz...',
                                  errorText: _userModel.sifreHataMesaj != null
                                      ? _userModel.sifreHataMesaj
                                      : null,
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0, 10, 10, 10),
                                    child: Icon(Icons.lock_outline_rounded),
                                  )),
                              onSaved: (String? gelenSifre) {
                                _sifre = gelenSifre!;
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 150,
                              child: SocialLoginButton(
                                btnText: _buttonText,
                                btnColor: Theme.of(context).primaryColor,
                                onPressed: () => _formSubmit(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            ],
          ),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/social_button.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/hata_exception.dart';
import 'package:kresadmin/models/user.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final String ogrNo;

  RegisterPage(this.ogrNo);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String _email, _sifre, _telefon;
  String _buttonText = "Kaydol";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final UserModel _userModel = Provider.of<UserModel>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backgroundColor,
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Kaydol",
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
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            veliTelefonTextForm(context),
                            SizedBox(
                              height: kdefaultPadding,
                            ),
                            emailTextForm(context),
                            SizedBox(
                              height: kdefaultPadding,
                            ),
                            ogrIDTextForm(context),
                            SizedBox(
                              height: kdefaultPadding,
                            ),
                            SocialLoginButton(
                              btnText: _buttonText,
                              btnColor: Theme.of(context).primaryColor,
                              onPressed: () => _formSubmit(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ));
  }

  Widget veliTelefonTextForm(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      initialValue: '123454546',
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Cep Telefonu',
          hintText: 'Cep no giriniz...',
          suffixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.person),
          )),
      onSaved: (String? tel) {
        _telefon = tel!;
      },
      validator: (String? tel) {
        if (tel!.length < 1) return 'Veli telefonu boş geçilemez!';
      },
    );
  }

  Widget ogrIDTextForm(BuildContext context) {
    return TextFormField(
      initialValue: "123456",
      //obscureText: true,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Şifre',
          hintText: 'Şifrenizi giriniz...',
          suffixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.lock_outline_rounded),
          )),
      onSaved: (String? gelenSifre) {
        _sifre = gelenSifre!;
      },
      validator: (String? ogrNo) {
        if (ogrNo!.length < 1)
          return 'Öğrenci numaranız olmadan kayıt olunamaz!';
      },
    );
  }

  Widget emailTextForm(BuildContext context) {
    final UserModel _userModel = Provider.of<UserModel>(context);
    return TextFormField(
      initialValue: 'kaplan@kaplan.com',
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'E-mail',
          hintText: 'E-Mailinizi giriniz...',
          errorText: _userModel.emailHataMesaj != null
              ? _userModel.emailHataMesaj
              : null,
          suffixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.mail_outline_rounded),
          )),
      onSaved: (String? gelenMail) {
        _email = gelenMail!;
      },
    );
  }

  _formSubmit(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        MyUser? _olusturulanUser =
            await _userModel.createUserEmailAndPassword(_email, widget.ogrNo);
        if (_olusturulanUser != null) {
          print("Giriş yapan Kullanıcı $_olusturulanUser");
          Navigator.popAndPushNamed(context, '/LandingPage');
        }
      } catch (e) {
        debugPrint('Hata Kullanıcı oluştururken hata çıktı: ' + e.toString());
        Get.snackbar('Hata', 'HATA: ' + Hatalar.goster(e.toString()),
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {}
  }
}

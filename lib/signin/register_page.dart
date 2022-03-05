import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/social_button.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/hata_exception.dart';
import 'package:kresadmin/models/user.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String _email, _sifre, _telefon, _username, _kresAdi;

  final _formKeyAdmin = GlobalKey<FormState>();
  final _formKeyTeacher = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final UserModel _userModel = Provider.of<UserModel>(context);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text(
                "Kaydol",
                style: TextStyle(fontSize: 24),
                textAlign: TextAlign.center,
              ),
              flexibleSpace: Container(
                color: Colors.orangeAccent.shade100,
              ),
              centerTitle: true,
              bottom: const TabBar(tabs: [
                Tab(
                  icon: Icon(Icons.school),
                  text: "Öğretmen",
                ),
                Tab(
                  icon: Icon(Icons.supervisor_account),
                  text: "Yönetici",
                ),
              ]),
            ),
            resizeToAvoidBottomInset: true,
            backgroundColor: backgroundColor,
            body: TabBarView(children: [
              teacherForm(context, _userModel),
              adminForm(context, _userModel)
            ])));
  }

  Widget adminForm(BuildContext context, UserModel _userModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 20,
        ),
        _userModel.state == ViewState.idle
            ? SingleChildScrollView(
                child: Form(
                  key: _formKeyAdmin,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        kresAdiTextForm(),
                        const SizedBox(
                          height: kdefaultPadding,
                        ),
                        usernameTextForm(),
                        const SizedBox(
                          height: kdefaultPadding,
                        ),
                        phoneTextForm(),
                        const SizedBox(
                          height: kdefaultPadding,
                        ),
                        emailTextForm(context),
                        const SizedBox(
                          height: kdefaultPadding,
                        ),
                        passwordTextForm(),
                        const SizedBox(
                          height: kdefaultPadding,
                        ),
                        SocialLoginButton(
                          btnText: "Kaydol",
                          btnColor: Theme.of(context).primaryColor,
                          onPressed: () => _formSubmit(context, _formKeyAdmin),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ],
    );
  }

  Widget teacherForm(BuildContext context, UserModel _userModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Kaydol",
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
        _userModel.state == ViewState.idle
            ? SingleChildScrollView(
                child: Form(
                  key: _formKeyTeacher,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        phoneTextForm(),
                        const SizedBox(
                          height: kdefaultPadding,
                        ),
                        emailTextForm(context),
                        const SizedBox(
                          height: kdefaultPadding,
                        ),
                        passwordTextForm(),
                        const SizedBox(
                          height: kdefaultPadding,
                        ),
                        SocialLoginButton(
                          btnText: "Kaydol",
                          btnColor: Theme.of(context).primaryColor,
                          onPressed: () =>
                              _formSubmit(context, _formKeyTeacher),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ],
    );
  }

  Widget phoneTextForm() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      initialValue: '123454546',
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Cep Telefonu',
          hintText: 'Cep no giriniz...',
          suffixIcon: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.phone_outlined),
          )),
      onSaved: (String? tel) {
        _telefon = tel!;
      },
      validator: (String? tel) {
        if (tel!.isEmpty) return 'Telefon boş geçilemez!';
        return null;
      },
    );
  }

  Widget passwordTextForm() {
    return TextFormField(
      initialValue: "123456",
      //obscureText: true,
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Şifre',
          hintText: 'Şifrenizi giriniz...',
          suffixIcon: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.lock_outline_rounded),
          )),
      onSaved: (String? gelenSifre) {
        _sifre = gelenSifre!;
      },
      validator: (String? pass) {
        if (pass!.isEmpty) return 'Şifre alanı boş bırakılamaz!';
        return null;
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
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'E-mail',
          hintText: 'E-Mailinizi giriniz...',
          errorText: _userModel.emailHataMesaj != null
              ? _userModel.emailHataMesaj
              : null,
          suffixIcon: const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.mail_outline_rounded),
          )),
      onSaved: (String? gelenMail) {
        _email = gelenMail!;
      },
    );
  }

  Widget usernameTextForm() {
    return TextFormField(
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Ad Soyad',
          hintText: 'Ad Soyad giriniz...',
          suffixIcon: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.person_outline),
          )),
      onSaved: (String? username) {
        _username = username!;
      },
    );
  }

  Widget kresAdiTextForm() {
    return TextFormField(
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Kreş Adı',
          hintText: 'Kreş Adı giriniz...',
          suffixIcon: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.school_outlined),
          )),
      onSaved: (String? kresAdi) {
        _kresAdi = kresAdi!;
      },
    );
  }

  _formSubmit(BuildContext context, GlobalKey<FormState> formkey) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      try {
        MyUser? _olusturulanUser =
            await _userModel.createUserEmailAndPassword(_email, _sifre);
        if (_olusturulanUser != null) {
          debugPrint("Giriş yapan Kullanıcı $_olusturulanUser");
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

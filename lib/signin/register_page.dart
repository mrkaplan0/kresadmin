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
  late String _email, _sifre, _phone, _username, _kresAdi;
  bool checkKresCode = false;
  final _formKeyAdmin = GlobalKey<FormState>();
  final _formKeyTeacher = GlobalKey<FormState>();
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              checkKresCode == false
                  ? checkKresCodeWidget(context)
                  : teacherForm(context),
              adminForm(context)
            ])));
  }

  Widget adminForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          Form(
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
        ],
      ),
    );
  }

  Widget teacherForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: kdefaultPadding,
          ),
          Form(
            key: _formKeyTeacher,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  kresAdiTextForm(kresAdi: _kresAdi),
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
                    onPressed: () => _formSubmit(context, _formKeyTeacher),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget checkKresCodeWidget(BuildContext context) {
    final UserModel _userModel = Provider.of<UserModel>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "     Lütfen çalıştığınız kreşin kodunu giriniz.",
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(
            height: kdefaultPadding,
          ),
          Row(
            children: [
              Expanded(flex: 3, child: kresCodeTextForm(context)),
              Expanded(
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_rounded),
                  onPressed: () async {
                    _kresAdi = await _userModel.queryKresList(_controller.text);
                    debugPrint(_kresAdi);

                    if (_kresAdi.isNotEmpty) {
                      checkKresCode = true;
                    } else {
                      Get.defaultDialog(
                          title: 'HATA',
                          middleText:
                              "Kreş Kodu yanlış! Lütfen tekrar deneyin.");

                      checkKresCode = false;
                    }
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ],
      ),
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
        _phone = tel!;
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

  Widget kresAdiTextForm({String? kresAdi}) {
    return TextFormField(
      initialValue: kresAdi,
      readOnly: kresAdi != null ? true : false,
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

  Widget kresCodeTextForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: TextFormField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            labelText: 'Kreş Kodu',
            suffixIcon: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
              child: Icon(Icons.school_outlined),
            )),
      ),
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
          _olusturulanUser.kresAdi = _kresAdi;
          _olusturulanUser.username = _username;
          _olusturulanUser.phone = _phone;

          if (formkey == _formKeyAdmin) {
           
            _olusturulanUser.position = 'Admin';
            _olusturulanUser.isAdmin = true;
          } else {
            _olusturulanUser.position = 'Teacher';
            _olusturulanUser.isAdmin = false;
            _olusturulanUser.kresCode = _controller.text;
            _olusturulanUser.kresAdi = _kresAdi;
          }
          bool result = await _userModel.updateUser(_olusturulanUser);
        
          if (result == true) {
            debugPrint("Giriş yapan Kullanıcı $_olusturulanUser");
            Navigator.popAndPushNamed(context, '/LandingPage');
          } else {
            _userModel.deleteUser(_olusturulanUser);
            Get.snackbar('HATA', 'Hata Kullanıcı oluştururken hata çıktı.',
                snackPosition: SnackPosition.BOTTOM);
          }
        }
      } catch (e) {
        debugPrint('Hata Kullanıcı oluştururken hata çıktı: ' + e.toString());
        Get.snackbar('Hata', 'HATA: ' + Hatalar.goster(e.toString()),
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}

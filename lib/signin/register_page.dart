// ignore_for_file: library_private_types_in_public_api, prefer_if_null_operators, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/social_button.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/hata_exception.dart';
import 'package:kresadmin/models/user.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:provider/provider.dart';

enum RegisterType { admin, teacher }

RegisterType registerType = RegisterType.admin;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String _email, _sifre, _phone, _username, _kresAdi;

  final _formKeyInfo2 = GlobalKey<FormState>();
  final _formKeyInfo = GlobalKey<FormState>();
  late TextEditingController _controller, _kresAdiController;
  final FocusNode _focusNode = FocusNode();
  late PageController _pageController;
  final _currentPageNotifier = ValueNotifier<int>(0);
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _kresAdiController = TextEditingController();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _kresAdiController.dispose();
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Kaydol",
            style: TextStyle(fontSize: 24),
          )),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Image(image: AssetImage('assets/images/logo.png')),
          Container(
            color: Colors.white.withOpacity(0.9),
          ),
          PageView(
            allowImplicitScrolling: true,
            scrollDirection: Axis.horizontal,
            controller: _pageController,
            onPageChanged: (number) {
              setState(() {
                _currentPageNotifier.value = number;
              });
            },
            children: [
              isTeacherOrAdmin(context, _pageController),
              checkKresCodeWidget(context, _pageController, _focusNode),
              kresAdiTextForm(_pageController),
              informationsForm(context, _pageController),
              informationsForm2(context, _pageController)
            ],
          ),
          _buildCircleIndicator()
        ],
      ),
    );
  }

  _buildCircleIndicator() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CirclePageIndicator(
          selectedSize: 11,
          itemCount: 5,
          currentPageNotifier: _currentPageNotifier,
        ),
      ),
    );
  }

  Widget informationsForm2(
      BuildContext context, PageController pageController) {
    return SingleChildScrollView(
      child: Form(
        key: _formKeyInfo2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: kdefaultPadding * 15,
              ),
              emailTextForm(context),
              const SizedBox(
                height: kdefaultPadding,
              ),
              passwordTextForm(),
              const SizedBox(
                height: kdefaultPadding,
              ),
              CustomButton(
                btnText: "Kaydol",
                btnColor: Theme.of(context).primaryColor,
                onPressed: () {
                  if (_formKeyInfo2.currentState!.validate()) {
                    _formKeyInfo2.currentState!.save();

                    _formSubmit(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget informationsForm(BuildContext context, PageController pageController) {
    return SingleChildScrollView(
      child: Form(
        key: _formKeyInfo,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: kdefaultPadding * 15,
              ),
              usernameTextForm(),
              const SizedBox(
                height: kdefaultPadding,
              ),
              phoneTextForm(),
              const SizedBox(
                height: kdefaultPadding,
              ),
              CustomButton(
                btnText: "Ileri",
                btnColor: Theme.of(context).primaryColor,
                onPressed: () {
                  if (_formKeyInfo.currentState!.validate()) {
                    _formKeyInfo.currentState!.save();

                    pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget checkKresCodeWidget(BuildContext context,
      PageController pageController, FocusNode focusNode) {
    final UserModel userModel = Provider.of<UserModel>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Lütfen çalıştığınız kreşin kodunu giriniz.",
          ),
          const SizedBox(
            height: kdefaultPadding,
          ),
          kresCodeTextForm(context),
          const SizedBox(
            height: kdefaultPadding,
          ),
          CustomButton(
              btnText: "Ileri",
              btnColor: Theme.of(context).primaryColor,
              onPressed: () async {
                _kresAdi = await userModel.queryKresList(_controller.text);
                debugPrint(_kresAdi);

                if (_kresAdi.isNotEmpty) {
                  pageController.animateToPage(3,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Kreş Kodu yanlış! Lütfen tekrar deneyin."),
                  ));
                }
              }),
        ],
      ),
    );
  }

  Widget phoneTextForm() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Cep Telefonu',
          hintText: 'Cep no giriniz...',
          suffixIcon: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(
              Icons.phone_outlined,
              color: primarySwatch,
            ),
          )),
      onSaved: (String? tel) {
        _phone = tel!;
      },
      validator: (String? tel) {
        if (tel!.isEmpty) return 'Bu alan boş bırakılamaz!';
        final pattern = RegExp(r'[a-zA-Z]');

        if (pattern.hasMatch(tel)) return "Telefon numarasi harf iceremez.";
        return null;
      },
    );
  }

  Widget passwordTextForm() {
    final UserModel userModel = Provider.of<UserModel>(context);
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'Şifre',
          hintText: 'Şifrenizi giriniz...',
          errorText: userModel.sifreHataMesaj != null
              ? userModel.sifreHataMesaj
              : null,
          suffixIcon: const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(
              Icons.lock_outline_rounded,
              color: primarySwatch,
            ),
          )),
      onSaved: (String? gelenSifre) {
        _sifre = gelenSifre!;
      },
      validator: (String? pass) {
        if (pass!.isEmpty) return 'Bu alan boş bırakılamaz!';

        return null;
      },
    );
  }

  Widget emailTextForm(BuildContext context) {
    final UserModel userModel = Provider.of<UserModel>(context);
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          labelText: 'E-mail',
          hintText: 'E-Mailinizi giriniz...',
          errorText: userModel.emailHataMesaj != null
              ? userModel.emailHataMesaj
              : null,
          suffixIcon: const Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(
              Icons.mail_outline_rounded,
              color: primarySwatch,
            ),
          )),
      onSaved: (String? gelenMail) {
        _email = gelenMail!;
      },
      validator: (String? email) {
        if (email!.isEmpty || !email.contains("@")) {
          return 'Bu alan boş bırakılamaz!';
        }
        return null;
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
            child: Icon(
              Icons.person_outline,
              color: primarySwatch,
            ),
          )),
      onSaved: (String? username) {
        _username = username!;
      },
      validator: (String? pass) {
        if (pass!.isEmpty) return 'Bu alan boş bırakılamaz!';
        return null;
      },
    );
  }

  Widget kresAdiTextForm(PageController pageController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _kresAdiController,
            decoration: const InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                labelText: 'Kreş Adı',
                hintText: 'Kreş Adı giriniz...',
                suffixIcon: Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                  child: Icon(
                    Icons.school_outlined,
                    color: primarySwatch,
                  ),
                )),
            onSaved: (String? kresAdi) {
              _kresAdi = kresAdi!;
            },
            validator: (String? pass) {
              if (pass!.trim().isEmpty || pass.length < 2) {
                return 'Bu alan boş bırakılamaz!';
              }
              return null;
            },
          ),
          const SizedBox(height: kdefaultPadding),
          CustomButton(
            btnText: "Ileri",
            btnColor: Theme.of(context).primaryColor,
            onPressed: () {
              switch (_kresAdiController.text.length) {
                case 0:
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Kreş Adi bos birakilamaz."),
                  ));
                  break;
                case 1:
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Kreş Adi cok kisa."),
                  ));
                  break;

                default:
                  _kresAdi = _kresAdiController.text;

                  pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget kresCodeTextForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: TextFormField(
        focusNode: _focusNode,
        controller: _controller,
        decoration: const InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            labelText: 'Kreş Kodu',
            suffixIcon: Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
              child: Icon(
                Icons.school_outlined,
                color: primarySwatch,
              ),
            )),
      ),
    );
  }

  _formSubmit(BuildContext context) async {
    final userModel = Provider.of<UserModel>(context, listen: false);

    try {
      MyUser? olusturulanUser =
          await userModel.createUserEmailAndPassword(_email, _sifre);

      if (olusturulanUser != null) {
        olusturulanUser.kresAdi = _kresAdi;
        olusturulanUser.username = _username;
        olusturulanUser.phone = _phone;

        if (registerType == RegisterType.admin) {
          olusturulanUser.position = 'Admin';
          olusturulanUser.isAdmin = true;
        } else {
          olusturulanUser.position = 'Teacher';
          olusturulanUser.isAdmin = false;
          olusturulanUser.kresCode = _controller.text;
          olusturulanUser.kresAdi = _kresAdi;
        }
        bool result = await userModel.updateUser(olusturulanUser);

        if (result == true) {
          debugPrint("Giriş yapan Kullanıcı $olusturulanUser");

          Navigator.popAndPushNamed(context, '/LandingPage');
        } else {
          userModel.deleteUser(olusturulanUser);

          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Kullanıcı oluştururken hata çıktı.'),
          ));
        }
      }
    } catch (e) {
      debugPrint('Hata Kullanıcı oluştururken hata çıktı: $e');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(Hatalar.goster(e.toString())),
      ));
    }
  }
}

Widget isTeacherOrAdmin(BuildContext context, PageController pageController) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Ben ..."),
          const SizedBox(height: kdefaultPadding),
          CustomButton(
              btnText: "Bir Ögretmenim.",
              btnColor: primaryColor,
              onPressed: () {
                registerType = RegisterType.teacher;
                pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              }),
          const SizedBox(height: kdefaultPadding),
          CustomButton(
              btnText: "Yeni Bir Anaokulunun Idarecisiyim.",
              btnColor: primaryColor,
              onPressed: () {
                registerType = RegisterType.admin;
                pageController.animateToPage(2,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              }),
          const SizedBox(
            height: kdefaultPadding * 14,
          ),
        ],
      ),
    ),
  );
}

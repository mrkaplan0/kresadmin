import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/social_button.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/hata_exception.dart';
import 'package:kresadmin/models/user.dart';
import 'package:kresadmin/signin/register_page.dart';
import 'package:provider/provider.dart';

class ResearchStudent extends StatefulWidget {
  @override
  _ResearchStudentState createState() => _ResearchStudentState();
}

class _ResearchStudentState extends State<ResearchStudent> {
  late String _ogrNo;
  String _buttonText = "Sorgula";
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
              "Öğrenci Numarası Giriniz.",
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

  Widget ogrIDTextForm(BuildContext context) {
    return TextFormField(
      initialValue: "123456",
      //obscureText: true,
      decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          // labelText: 'Şifre',
          hintText: 'Öğrenci No...',
          suffixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
            child: Icon(Icons.school_rounded),
          )),
      onSaved: (String? gelenNo) {
        _ogrNo = gelenNo!;
      },
      validator: (String? ogrNo) {
        if (ogrNo!.length < 1)
          return 'Öğrenci numaranız olmadan kayıt olunamaz!';
      },
    );
  }

  _formSubmit(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        print(_ogrNo);
        bool sonuc = await _userModel.ogrNoControl(_ogrNo);

        if (sonuc == true) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RegisterPage(_ogrNo)));
        } else {
          Get.snackbar('HATA',
              'HATA: Geçerli öğrenci şifresi olmadan kayıt olamazsınız. Yönetici ile irtibata geçiniz.  ',
              snackPosition: SnackPosition.TOP);
        }
      } catch (e) {
        debugPrint('Hata Kullanıcı oluştururken hata çıktı: ' + e.toString());
        Get.snackbar('Hata', 'HATA: ' + Hatalar.goster(e.toString()),
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {}
  }
}

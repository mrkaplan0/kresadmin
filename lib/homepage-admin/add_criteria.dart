import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/criteria_widget.dart';
import 'package:kresadmin/constants.dart';
import 'package:provider/provider.dart';

class AddCriteria extends StatefulWidget {
  const AddCriteria({Key? key}) : super(key: key);

  @override
  _AddCriteriaState createState() => _AddCriteriaState();
}

class _AddCriteriaState extends State<AddCriteria> {
  late TextEditingController kriterController;

  @override
  void initState() {
    super.initState();
    kriterController = TextEditingController();
  }

  @override
  void dispose() {
    kriterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Kriter Ekle"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: kriterController,
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  _addButton(kriterController.text),
                ],
              ),
            ),
            const SizedBox(
              height: kdefaultPadding,
            ),
            Wrap(
              children: [...criteriaItemBuild()],
            ),
            const SizedBox(
              height: kdefaultPadding,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Kriterleriniz",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
            ),
            Expanded(child: dynamicCriteriaList()),
            const SizedBox(
              height: kdefaultPadding,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> criteriaItemBuild() {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    List<Widget> ll = [];

    for (int i = 0; i < dataList.length; i++) {
      ll.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: CriteriaWidget(
          dataList[i],
          () async {
            await _userModel.addCriteria(_userModel.users!.kresCode!,
                _userModel.users!.kresAdi!, dataList[i]);
            setState(() {});
          },
        ),
      ));
    }
    return ll;
  }

  List<String> dataList = [
    'Beslenme',
    'Sınıf İçi Uyum',
    'Etkinliklere Katılım',
    'Sağlık',
    'Tuvalet Alışkanlığı',
    'Uyku'
  ];

  Widget _addButton(String criteria) {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    return InkWell(
      onTap: () async {
        if (kriterController.text.isNotEmpty) {
          var sonuc = await _userModel.addCriteria(_userModel.users!.kresCode!,
              _userModel.users!.kresAdi!, kriterController.text);
          if (sonuc) {
            kriterController.clear();
            FocusScope.of(context).unfocus();
            setState(() {});
          }
        } else {
          Get.snackbar('Hata', 'Lütfen kriter girin.');
        }
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget dynamicCriteriaList() {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    return FutureBuilder<List<String>>(
        future: _userModel.getCriteria(
            _userModel.users!.kresCode!, _userModel.users!.kresAdi!),
        builder: (context, sonuc) {
          if (sonuc.hasData) {
            var criteriaList = sonuc.data!;
            if (criteriaList.isNotEmpty) {
              return SizedBox(
                width: double.infinity,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: criteriaList.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Card(
                          child: ListTile(
                            title: Text(
                              criteriaList[i],
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            tileColor: itemColor3,
                            trailing: InkWell(
                                child: const Icon(Icons.remove_circle),
                                onTap: () {
                                  deleteCriteria(context, criteriaList[i]);
                                }),
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return const Center(
                child: Text("Kriter ekleyin."),
              );
            }
          } else {
            return const Center(
              child: Text("Kriter ekleyin."),
            );
          }
        });
  }

  deleteCriteria(BuildContext context, String criteria) async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);

    var sonuc = await _userModel.deleteCriteria(
        _userModel.users!.kresCode!, _userModel.users!.kresAdi!, criteria);

    if (sonuc == true) {
      setState(() {});
    }
  }
}

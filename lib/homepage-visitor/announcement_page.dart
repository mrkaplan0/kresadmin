import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:provider/provider.dart';

class AnnouncementPage extends StatelessWidget {
  const AnnouncementPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Duyurular"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: announcementList(context),
      ),
    );
  }

  Widget announcementList(BuildContext context) {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    return FutureBuilder<List<Map<String, dynamic>>>(
        future: _userModel.getAnnouncements(
            _userModel.users!.kresCode!, _userModel.users!.kresAdi!),
        builder: (context, sonuc) {
          if (sonuc.hasData) {
            var announceList = sonuc.data!;
            if (announceList.length > 0) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: announceList.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "${announceList[i]['Duyuru Tarihi']}      ${announceList[i]['Duyuru Başlığı']}"),
                          /*  Text(
                            "Detayı Gör",
                            style: TextStyle(
                                // fontStyle: FontStyle.italic,
                                color: Colors.black26),
                          )*/
                          IconButton(
                            icon: const Icon(
                                Icons.keyboard_double_arrow_right_outlined),
                            onPressed: () => _showAnnouncementDetail(
                                context,
                                announceList[i]['Duyuru Başlığı'],
                                announceList[i]['Duyuru']),
                          )
                        ],
                      ),
                    );
                  });
            } else {
              return const Text("Henüz duyuru yok.");
            }
          } else
            return const Center(
              child: Text("Henüz duyuru yok."),
            );
        });
  }

  _showAnnouncementDetail(BuildContext context, String announcementTitle,
      String? announcementDetail) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(announcementTitle),
            content: SingleChildScrollView(
              child: Text(announcementDetail != null
                  ? announcementDetail
                  : "Detay Yok"),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Kapat'),
              )
            ],
          );
        });
  }
}

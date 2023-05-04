import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/menu_items.dart';
import 'package:kresadmin/homepage-admin/add_criteria.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/home_settings.dart';
import 'package:kresadmin/homepage-admin/personel_settings/personel_management.dart';
import 'package:kresadmin/homepage-admin/send_notification.dart';
import 'package:kresadmin/homepage-admin/student_settings/student_management.dart';
import 'package:kresadmin/homepage-visitor/home_page.dart';
import 'package:kresadmin/services/messaging_services.dart';
import 'package:provider/provider.dart';

import 'homepage_settings/add_announcement.dart';

class AdminHomepage extends StatefulWidget {
  const AdminHomepage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AdminHomepageState createState() => _AdminHomepageState();
}

class _AdminHomepageState extends State<AdminHomepage> {
  final MessagingService _messagingService = MessagingService();
 late ScrollController _scrollController;
  double fabPaddingLeft=135;

  @override
  void initState() {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);

    _messagingService
        .initialize(onSelectNotification, context, userModel.users!)
        .then(
          (value) => firebaseCloudMessagingListeners(),
        );
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  void firebaseCloudMessagingListeners() async {
    MessagingService.onMessage
        .listen(_messagingService.invokeLocalNotification);
    MessagingService.onMessageOpenedApp.listen(_pageOpenForOnLaunch);
  }
  _pageOpenForOnLaunch(RemoteMessage remoteMessage) {
    final Map<String, dynamic> message = remoteMessage.data;

    onSelectNotification(jsonEncode(message));
  }
  Future onSelectNotification(String? payload) async {}


  void _scrollListener() {
    if (_scrollController.offset == _scrollController.position.maxScrollExtent) {
      setState(() {
fabPaddingLeft=_scrollController.offset;
      });
    } else {
      setState(() {
        fabPaddingLeft=_scrollController.offset;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color(0xFFF68763),
      resizeToAvoidBottomInset: true,
      body: CustomScrollView( controller: _scrollController,
        slivers: [
          SliverAppBar(automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            expandedHeight: 200,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [

                  Stack(
                    children: [

                      Align(alignment: Alignment.bottomRight,
                        child: Opacity(
                            opacity: 0.6,
                            child: Icon(
                              Icons.manage_accounts,
                              size: 220,
                              color: Colors.grey.shade200,
                            )),
                      ),
                    ],
                  ),

                ],
              ),

              title: Row(
                children: [Align(alignment: Alignment.bottomCenter,child: visiblityFAB(context,true),),

                  const SizedBox(width: 10,),
                  Column(mainAxisAlignment: MainAxisAlignment.end,crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Kreş Adı",style:  GoogleFonts.montserrat(color: Colors.grey.shade300, fontSize: 12,)
                  ),
                      Text(
                        "${userModel.users!.kresCode} - ${userModel.users!.kresAdi}",
                        style:  GoogleFonts.montserrat(color: Colors.black, fontSize: 16,)
                      ),
                    ],
                  ),
                ],
              ),
              centerTitle: true,
            ),
            actions: [
            fabPaddingLeft==(_scrollController.hasClients?_scrollController.position.maxScrollExtent:0)? const SizedBox.shrink(): TextButton.icon(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black38),
                ),
                onPressed: () => _cikisyap(context),
                icon: const Icon(Icons.logout),
                label: const Text("Çıkış"),
              ),
            ],
          ),
          bodyWidget(context),
        ],
      ),
    );
  }



Widget visiblityFAB(BuildContext context, bool iamLeading){

     if(iamLeading==true) {
       return SizedBox(
height: 35,
      child: fabPaddingLeft==(_scrollController.hasClients?_scrollController.position.maxScrollExtent:150)? FloatingActionButton(mini: true,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomePage()));
        },
        tooltip: 'Anasayfa',
        elevation: 2,
        backgroundColor: Colors.amber,
        child: const Icon(Icons.home,size: 20,color: Colors.white54),
      ):null,
    );
     } else {
       return SizedBox(
       height: 70,
       child: fabPaddingLeft<(_scrollController.hasClients? _scrollController.position.maxScrollExtent:136)? Padding(
         padding: EdgeInsets.only(left:135-(_scrollController.hasClients?fabPaddingLeft:0),right: 135+(_scrollController.hasClients?fabPaddingLeft:0)),
         child: FloatingActionButton(
           onPressed: () {
             Navigator.push(context,
                 MaterialPageRoute(builder: (context) => HomePage()));
           },
           tooltip: 'Anasayfa',
           elevation: 2,
           backgroundColor: Colors.amber,
           child: const Icon(Icons.home,size: 40,color: Colors.white54,),
         ),
       ):null,
     );
     }
}


Widget bodyWidget(BuildContext context) {

  return SliverToBoxAdapter(
    child: Column(
      children: [

       visiblityFAB(context,false),
        GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          primary: false,
          shrinkWrap: true,
          children: [
            MenuItems(
              itemText: 'Personel İşlemleri',
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PersonelManagement()));
              },
              icon: Icons.person,
            ),
            MenuItems(
              itemText: ' Öğrenci İşlemleri',
              onPress: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const StudentManagement()));
              },
              icon: Icons.school_rounded,
            ),
            MenuItems(
              itemText: 'Kriter Ekle',
              onPress: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddCriteria()));
              },
              icon: Icons.star_half_rounded,
            ),
            MenuItems(
              itemText: 'Bildirim Gönder',
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SendNotification()));
              },
              icon: Icons.phone_android_outlined,
            ),
            MenuItems(
              itemText: 'Galeri İşlemleri',
              onPress: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const GallerySettings()));
              },
              icon: Icons.person,
            ),
            MenuItems(
              itemText: ' Duyuru Ekle',
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddAnnouncement()));
              },
              icon: Icons.school_rounded,
            ),
          ],
        ),
        Container(height:50,)
      ],
    ),
  );
}
Future<bool> _cikisyap(BuildContext context) async {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await userModel.signOut();
    return sonuc;
  }
}
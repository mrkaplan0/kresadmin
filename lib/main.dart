import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kresadmin/homepage-admin/student_settings/student_list.dart';
import 'package:kresadmin/homepage-admin/student_settings/student_management.dart';
import 'package:kresadmin/landing_page.dart';
import 'package:kresadmin/services/admob_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'View_models/user_model.dart';
import 'constants.dart';

import 'locator.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setupLocator();
  AdmobService.adMobinitialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider(
            create: (context) => UserModel(),
            child: GetMaterialApp(
              routes: {
                '/LandingPage': (context) => const LandingPage(),
                '/StudentManagement': (context) => const StudentManagement(),
                '/StudentListPage': (context) => StudentListPage(),
              },
              theme: ThemeData(
                  primarySwatch: primarySwatch,
                  primaryColor: primaryColor,
                  textTheme: GoogleFonts.montserratTextTheme(
                      Theme.of(context).textTheme),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: TextButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.all(kdefaultPadding),
                    ),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    border: textFieldBorder,
                    enabledBorder: textFieldBorder,
                    focusedBorder: textFieldBorder,
                  ),
                  appBarTheme: const AppBarTheme(
                      backgroundColor: Colors.white, elevation: 0)),
              debugShowCheckedModeBanner: false,
              home: const LandingPage(),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Container(
            color: Colors.white, child: const CircularProgressIndicator());
      },
    );
  }
}

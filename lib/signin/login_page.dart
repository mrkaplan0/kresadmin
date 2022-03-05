import 'package:flutter/material.dart';
import 'package:kresadmin/constants.dart';
import 'package:kresadmin/signin/email_login.dart';
import 'package:kresadmin/signin/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
            image: AssetImage('assets/images/splash.png'),
          ),
          const SizedBox(height: 100),
          const Image(
            alignment: Alignment.topCenter,
            image: AssetImage('assets/images/logo.png'),
          ),
          const SizedBox(
            height: 250,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                          fullscreenDialog: true),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orangeAccent.shade100,
                    ),
                    child: const Text("Kaydol"),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: kdefaultPadding),
                  child: SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmailLogin(),
                              fullscreenDialog: true)),
                      style: TextButton.styleFrom(
                        elevation: 0,
                        backgroundColor:
                            Colors.orangeAccent.shade100.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.orangeAccent.shade100),
                        ),
                      ),
                      child: Text(
                        "Giriş Yap",
                        style: TextStyle(color: Colors.orangeAccent.shade200),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 200),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

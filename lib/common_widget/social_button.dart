import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
  final String btnText;
  final Color btnColor;
  final Color? textColor;
  final double radius;
  final double? yukseklik;
  final Widget? btnIcon;
  final VoidCallback onPressed;

  const SocialLoginButton(
      {required this.btnText,
      required this.btnColor,
      this.textColor: Colors.white,
      this.radius: 10,
      this.yukseklik,
      this.btnIcon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          btnText,
          style: TextStyle(color: textColor),
        ),
        style: TextButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.orangeAccent.shade100,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.orangeAccent),
          ),
        ),
      ),
    );
  }
}

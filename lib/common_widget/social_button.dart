import 'package:flutter/material.dart';
import 'package:kresadmin/constants.dart';

class CustomButton extends StatelessWidget {
  final String btnText;
  final Color btnColor;
  final Color? textColor;
  final double radius;
  final double? yukseklik;
  final Widget? btnIcon;
  final VoidCallback onPressed;

  const CustomButton(
      {super.key,
      required this.btnText,
      required this.btnColor,
      this.textColor = Colors.white,
      this.radius = 10,
      this.yukseklik,
      this.btnIcon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 2,
        ),
        child: Text(
          btnText,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}

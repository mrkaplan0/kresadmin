import 'package:flutter/material.dart';

class CriteriaWidget extends StatelessWidget {
  final String kriter;
  final GestureTapCallback onPress;

  // ignore: prefer_const_constructors_in_immutables
  CriteriaWidget(this.kriter, this.onPress, {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.black),
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
      child: Text(kriter),
    );
  }
}

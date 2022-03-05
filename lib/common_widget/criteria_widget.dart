import 'package:flutter/material.dart';

class CriteriaWidget extends StatelessWidget {
  final String kriter;
  final GestureTapCallback onPress;

  CriteriaWidget(this.kriter, this.onPress);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      child: Text(kriter),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.black),
        backgroundColor: MaterialStateProperty.all(Colors.white),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MenuItems extends StatelessWidget {
  final String itemText;
  final Image? itemImage;

  final IconData icon;
  final GestureTapCallback onPress;

  MenuItems({
    required this.onPress,
    required this.itemText,
    required this.icon,
    this.itemImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: Colors.orangeAccent.shade100,
        onTap: onPress,
        title: Text(itemText),
        trailing: Icon(icon),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MenuItems extends StatelessWidget {
  final Color? itemColor;
  final String itemText;
  final Image? itemImage;
  final double? boxHeight;
  final double? boxWidth;
  final IconData icon;
  final GestureTapCallback onPress;

  MenuItems(
      {required this.onPress,
      required this.itemColor,
      required this.itemText,
      required this.icon,
      this.itemImage,
      this.boxHeight: 150,
      this.boxWidth: 150});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: onPress,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                child: Container(
                  alignment: Alignment.bottomRight,
                  width: boxWidth,
                  height: boxHeight,
                  decoration: BoxDecoration(
                    color: itemColor,
                  ),
                  child: Icon(
                    icon,
                    size: 145,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              itemText,
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

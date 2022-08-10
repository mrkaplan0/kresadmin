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
    return Column(
      children: [
        GestureDetector(
          child: Container(
            width: 130,
            height: 130,
            decoration: const BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 40,
                ),
                const SizedBox(height: 10),
                Text(itemText)
              ],
            ),
          ),
          onTap: onPress,
        )
      ],
    );
  }
}

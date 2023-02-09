import 'package:flutter/material.dart';

class MenuItems extends StatelessWidget {
  final String itemText;
  final Image? itemImage;

  final IconData icon;
  final GestureTapCallback onPress;

  const MenuItems({super.key,
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
          onTap: onPress,
          child: Container(
            width: 130,
            height: 130,
            decoration: const BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 0.8,spreadRadius:0.5,blurStyle: BlurStyle.outer)],
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
                Center(child: Text(itemText))
              ],
            ),
          ),
        )
      ],
    );
  }
}

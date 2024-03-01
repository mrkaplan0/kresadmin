// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class HomepageHeader extends StatelessWidget {
  final String headerTitle;
  final VoidCallback? onPressed;
  final String seeAll = "Tümünü Gör";

  const HomepageHeader({
    Key? key,
    required this.headerTitle,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          headerTitle,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            seeAll,
            style: TextStyle(
                color: onPressed == null ? Colors.white : Colors.black26),
          ),
        ),
      ],
    );
  }
}

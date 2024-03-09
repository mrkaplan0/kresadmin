import 'package:flutter/material.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/calender_page.dart';

class HomeStudentWidget extends StatelessWidget {
  const HomeStudentWidget({
    super.key,
    required this.context,
    required this.childProfileTitle,
  });

  final BuildContext context;
  final String childProfileTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CalenderPage())),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40), bottomRight: Radius.circular(20)),
            child: Container(
              color: Colors.brown.shade200,
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Image.asset(
                    "assets/images/kind2.jpg",
                    fit: BoxFit.cover,
                    width: 160,
                    height: 130,
                  ),
                  Container(
                    color: Colors.white.withOpacity(0.2),
                    width: 160,
                    height: 130,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(childProfileTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

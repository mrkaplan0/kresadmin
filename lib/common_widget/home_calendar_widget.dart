import 'package:flutter/material.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/calender_page.dart';

class HomeCalendarWidget extends StatelessWidget {
  const HomeCalendarWidget({
    super.key,
    required this.calendarTitle,
  });

  final String calendarTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CalenderPage())),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(40), bottomLeft: Radius.circular(20)),
            child: Container(
              color: Colors.brown.shade200,
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Image.asset(
                    "assets/images/calendar2.png",
                    fit: BoxFit.fill,
                    width: 160,
                    height: 130,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Text(
                        calendarTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
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

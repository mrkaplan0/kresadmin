import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ShowPhotoWidget extends StatelessWidget {
  final String photoUrl;
  late DragStartDetails startVerticalDragDetails;
  late DragUpdateDetails updateVerticalDragDetails;
  ShowPhotoWidget(this.photoUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: AlertDialog(
        content: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white),
          child: ExtendedImage.network(
            photoUrl,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
      onVerticalDragStart: (dragDetails) {
        startVerticalDragDetails = dragDetails;
      },
      onVerticalDragUpdate: (dragDetails) {
        updateVerticalDragDetails = dragDetails;

        double dx = updateVerticalDragDetails.globalPosition.dx -
            startVerticalDragDetails.globalPosition.dx;
        double dy = updateVerticalDragDetails.globalPosition.dy -
            startVerticalDragDetails.globalPosition.dy;
        double? velocity = dragDetails.primaryDelta;

        //Convert values to be positive
        if (dx < 0) dx = -dx;
        if (dy < 0) dy = -dy;

        if (velocity! < 0) {
          Navigator.of(context).pop();
        }
      },
    );
  }
}

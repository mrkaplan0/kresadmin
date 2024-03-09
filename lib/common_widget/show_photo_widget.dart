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
    return Dismissible(
      direction: DismissDirection.vertical,
      onDismissed: (_) {
        Navigator.of(context).pop();
      },
      key: const Key("key"),
      child: Dialog(
        child: ExtendedImage.network(
          mode: ExtendedImageMode.gesture,
          photoUrl,
        ),
      ),
    );
  }
}

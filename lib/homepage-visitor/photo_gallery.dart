import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:kresadmin/common_widget/show_photo_widget.dart';
import 'package:kresadmin/models/photo.dart';

class PhotoGallery extends StatefulWidget {
  final List<Photo>? album;

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();

  PhotoGallery(this.album);
}

class _PhotoGalleryState extends State<PhotoGallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fotoğraf Galerisi",
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: photoGalleryWidget(),
    );
  }

  Widget photoGalleryWidget() {
    if (widget.album!.length > 0)
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 15),
        child: GridView.builder(
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: widget.album!.length,
          itemBuilder: (context, i) {
            return GestureDetector(
                child: Container(
                  margin: EdgeInsets.all(6),
                  height: 130,
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: ExtendedImage.network(
                      widget.album![i].photoUrl,
                      fit: BoxFit.cover,
                      mode: ExtendedImageMode.gesture,
                      cache: true,
                    ),
                  ),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ShowPhotoWidget(widget.album![i].photoUrl);
                      });
                });
          },
        ),
      );
    else
      return Padding(
        padding: const EdgeInsets.only(left: 14.0, right: 14),
        child: Container(
          height: 200,
        ),
      );
  }
}

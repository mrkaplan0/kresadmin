import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:kresadmin/common_widget/show_photo_widget.dart';
import 'package:kresadmin/models/photo.dart';

class HomepagePhotoGalleryWidget extends StatefulWidget {
  const HomepagePhotoGalleryWidget({
    super.key,
    required this.album,
  });

  final List<Photo>? album;

  @override
  State<HomepagePhotoGalleryWidget> createState() =>
      _HomepagePhotoGalleryWidgetState();
}

class _HomepagePhotoGalleryWidgetState
    extends State<HomepagePhotoGalleryWidget> {
  int _current = 1;

  @override
  Widget build(BuildContext context) {
    if (widget.album!.isNotEmpty && widget.album!.length > 2) {
      var items = List<Widget>.generate(
          3,
          (i) => GestureDetector(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      height: 130,
                      width: 180,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: ExtendedImage.network(
                          widget.album![i].photoUrl,
                          fit: BoxFit.cover,
                          mode: ExtendedImageMode.gesture,
                          cache: true,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      height: 130,
                      width: 180,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.grey.shade200.withOpacity(0.1),
                                Colors.black12.withOpacity(0.3),
                                Colors.black26.withOpacity(0.5),
                              ],
                              stops: const [
                                0.4,
                                0.8,
                                1,
                              ])),
                    ),
                    widget.album![i].info != null
                        ? Positioned(
                            bottom: 35,
                            left: 13,
                            child: Text(
                              widget.album![i].info!,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          )
                        : const Text(""),
                  ],
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ShowPhotoWidget(widget.album![i].photoUrl);
                      });
                },
              ));

      return Column(
        children: [
          CarouselSlider(
              items: items,
              options: CarouselOptions(
                initialPage: _current,
                height: 130,
                viewportFraction: 0.58,
                enableInfiniteScroll: false,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
                enlargeCenterPage: false,
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: items.asMap().entries.map((entry) {
              return Container(
                width: _current == entry.key ? 12 : 10,
                height: _current == entry.key ? 12 : 10,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.brown)
                        .withOpacity(_current == entry.key ? 0.9 : 0.4)),
              );
            }).toList(),
          ),
        ],
      );

      /* SizedBox(
        height: 160,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.album!.length > 3 ? 3 : widget.album!.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      height: 130,
                      width: 180,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8)),
                        child: ExtendedImage.network(
                          widget.album![i].photoUrl,
                          fit: BoxFit.cover,
                          mode: ExtendedImageMode.gesture,
                          cache: true,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 12),
                      height: 130,
                      width: 180,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.grey.shade200.withOpacity(0.1),
                                Colors.black12.withOpacity(0.3),
                                Colors.black26.withOpacity(0.5),
                              ],
                              stops: const [
                                0.4,
                                0.8,
                                1,
                              ])),
                    ),
                    widget.album![i].info != null
                        ? Positioned(
                            bottom: 35,
                            left: 13,
                            child: Text(
                              widget.album![i].info!,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          )
                        : const Text(""),
                  ],
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ShowPhotoWidget(widget.album![i].photoUrl);
                      });
                },
              );
            }),
      );*/
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 14.0, right: 14),
        child: Container(
          height: 200,
        ),
      );
    }
  }
}

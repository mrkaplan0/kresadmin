import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/show_photo_widget.dart';
import 'package:kresadmin/models/photo.dart';
import 'package:kresadmin/models/student.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class StudentPage extends StatefulWidget {
  final Student student;

  StudentPage(this.student);

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  bool isExpanded = false;
  DateTime dateTime = DateTime.now();
  List<Map<String, dynamic>> allRatings = [];
  Map<String, dynamic> lastRating = {};
  List<Photo> album = [];

  @override
  void initState() {
    super.initState();
    getRatingsMethod().then((value) => setState(() {}));
    getIndividualPhotos().then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverAppBar(
            centerTitle: true,

            expandedHeight: 250.0,
            // floating: true,
            stretch: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(widget.student.adiSoyadi,
                    style: TextStyle(
                      color: widget.student.fotoUrl != null
                          ? Colors.white
                          : Colors.black,
                      fontSize: 16.0,
                    )),
                background: widget.student.fotoUrl != null
                    ? ExtendedImage.network(
                        widget.student.fotoUrl!,
                        fit: BoxFit.cover,
                        cache: true,
                      )
                    : Container(
                        color: Colors.orangeAccent.shade200,
                        child: Icon(
                          Icons.person,
                          size: 145,
                          color: widget.student.cinsiyet == "Erkek"
                              ? Colors.blue
                              : Colors.pink,
                        ),
                      )),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 15),
                  lastRating.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text("Son De??erlendirme Tarihi:",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold)),
                              Text(lastRating['Son De??erlendirme'].toString(),
                                  style: const TextStyle(fontSize: 18.0)),
                            ],
                          ),
                        )
                      : const SizedBox(height: 10),
                  lastRating.isNotEmpty ? lastRatingWidget() : Container(),
                  lastRating['??zel Not'] != null
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("??zel Not: \n" +
                                  lastRating['??zel Not'].toString())),
                        )
                      : Container(),
                  if (lastRating.isEmpty) ...[
                    const Text("Son 4 g??n i??inde de??erlendirme yap??lmad??.")
                  ],
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Ki??isel Galeri",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                  ),
                  album.isNotEmpty
                      ? photoGalleryWidget()
                      : const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Galeride hen??z foto??raf yok!"),
                        ),
                ])
          ]))
        ],
      ),
    );
  }

  Widget photoGalleryWidget() {
    if (album.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 15),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: album.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              child: Container(
                margin: const EdgeInsets.all(6),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  child: ExtendedImage.network(
                    album[i].photoUrl,
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
                      return ShowPhotoWidget(album[i].photoUrl);
                    });
              },
            );
          },
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 14.0, right: 14),
        child: Container(
          height: 200,
        ),
      );
    }
  }

  Future getRatingsMethod() async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
//bug??n de??erlendirme yap??lmam????sa,Son 4 g??n i??inde de??erlendirme yap??lm????sa al, g??ster.
    allRatings = await _userModel.getRatings(_userModel.users!.kresCode!,
        _userModel.users!.kresAdi!, widget.student.ogrID);
    String formattedTime = formatter.format(dateTime);

    var ss = allRatings
        .where((m) => m['Son De??erlendirme'].startsWith(formattedTime));

    if (ss.isEmpty) {
      DateTime d1 = dateTime.subtract(const Duration(days: 1));
      String formattedTime = formatter.format(d1);
      var tt = allRatings
          .where((m) => m['Son De??erlendirme'].startsWith(formattedTime));
      if (tt.isEmpty) {
        DateTime d2 = dateTime.subtract(const Duration(days: 2));
        String formattedTime = formatter.format(d2);
        var uu = allRatings
            .where((m) => m['Son De??erlendirme'].startsWith(formattedTime));
        if (uu.isEmpty) {
          DateTime d3 = dateTime.subtract(const Duration(days: 3));
          String formattedTime = formatter.format(d3);
          var vv = allRatings
              .where((m) => m['Son De??erlendirme'].startsWith(formattedTime));
          if (vv.isEmpty) {
            DateTime d4 = dateTime.subtract(const Duration(days: 4));
            String formattedTime = formatter.format(d4);

            var yy = allRatings
                .where((m) => m['Son De??erlendirme'].startsWith(formattedTime));
            lastRating = yy.first;

            print(lastRating.toString() + "444");
          } else {
            lastRating = vv.first;
          }
        } else {
          lastRating = uu.first;
        }
      } else {
        lastRating = tt.first;
      }
    } else {
      lastRating = ss.first;
    }
  }

  Widget lastRatingWidget() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: lastRating.keys.length,
        itemBuilder: (context, i) {
          if (lastRating.keys.elementAt(i) != 'Son De??erlendirme' &&
              lastRating.keys.elementAt(i) != '??zel Not') {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        lastRating.keys.elementAt(i),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: RatingBar(
                        initialRating: lastRating.values.elementAt(i),
                        ignoreGestures: true,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        ratingWidget: RatingWidget(
                          full: const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          half: const Icon(
                            Icons.star_half_rounded,
                            color: Colors.amber,
                          ),
                          empty: const Icon(
                            Icons.star_border_rounded,
                            color: Colors.amber,
                          ),
                        ),
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        onRatingUpdate: (rating) {},
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox();
          }
        });
  }

  Future getIndividualPhotos() async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    album = await _userModel.getPhotoToSpecialGallery(
        _userModel.users!.kresCode!,
        _userModel.users!.kresAdi!,
        widget.student.ogrID);
  }
}

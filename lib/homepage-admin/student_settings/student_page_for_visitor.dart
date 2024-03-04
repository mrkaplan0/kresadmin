import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/show_photo_widget.dart';
import 'package:kresadmin/common_widget/show_rating_details.dart';
import 'package:kresadmin/common_widget/social_button.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/image_crop.dart';
import 'package:kresadmin/homepage-admin/student_settings/student_ratings_page.dart';
import 'package:kresadmin/models/photo.dart';
import 'package:kresadmin/models/student.dart';
import 'package:provider/provider.dart';

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
  bool isEditButtonClicked = false;
  List<bool>? _isChanged;
  List<Photo> willBeDeletedUrlList = [];

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
              expandedHeight: MediaQuery.of(context).size.height * 4 / 8,
              //floating: true,
              stretch: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: studentProfile(context))),
          SliverList(
              delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 15),
                    CustomButton(
                        btnText: 'Değerlendir',
                        btnColor: Theme.of(context).primaryColor,
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    StudentRating(widget.student),
                                fullscreenDialog: true))),
                    const SizedBox(height: 15),
                    CustomButton(
                        btnText: 'Foto Ekle',
                        btnColor: Theme.of(context).primaryColor,
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ImageCrop(student: widget.student)))),
                    const SizedBox(height: 15),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Performans Değerlendirmeleri",
                          style: TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                    ),
                    allRatings.isNotEmpty
                        ? const SizedBox(height: 10)
                        : const Text(
                            "Henüz değerlendirme yok!",
                          ),
                    allRatings.isNotEmpty ? last3Ratings() : Container(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Kişisel Galeri",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(
                          width: 70,
                        ),
                        ...editingButtonForAdmin(),
                      ],
                    ),
                    album.isNotEmpty
                        ? photoGalleryWidget()
                        : const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Galeride henüz fotoğraf yok!"),
                          ),
                  ]),
            )
          ]))
        ],
      ),
    );
  }

  Widget studentProfile(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 28),
        Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 4 / 8,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.amberAccent,
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.elliptical(75, 55)),
              ),
              child: Stack(
                children: [
                  SizedBox.fromSize(
                      size: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height * 3 / 8 + 45),
                      child: stuProfileImage(context)),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: const EdgeInsets.only(right: 12),
                      height: MediaQuery.of(context).size.height * 1 / 8,
                      width: MediaQuery.of(context).size.width + 2,
                      decoration: BoxDecoration(
                        color: ThemeData().scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.elliptical(70, 50)),
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                widget.student.adiSoyadi,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 26,
                                ),
                              ),
                              RichText(
                                  text: TextSpan(children: [
                                const TextSpan(
                                    text: '(Veli)  ',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12)),
                                TextSpan(
                                    text: widget.student.veliAdiSoyadi!,
                                    style:
                                        const TextStyle(color: Colors.black)),
                              ])),
                              RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: widget.student.dogumTarihi!,
                                    style:
                                        const TextStyle(color: Colors.black)),
                                const TextSpan(text: '  '),
                                TextSpan(
                                    text: widget.student.cinsiyet!,
                                    style: const TextStyle(color: Colors.black))
                              ])),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget stuProfileImage(BuildContext context) => Container(
        decoration: const BoxDecoration(
          borderRadius:
              BorderRadius.only(bottomRight: Radius.elliptical(75, 55)),
        ),
        child: widget.student.fotoUrl != null
            ? ExtendedImage.network(
                widget.student.fotoUrl!,
                fit: BoxFit.cover,
                mode: ExtendedImageMode.gesture,
                cache: true,
              )
            : const Center(
                child: Icon(
                Icons.person,
                size: 250,
                color: Colors.black45,
              )),
      );

  Widget studentProfileName() => Align(
        alignment: Alignment.topRight,
        child: Text(
          widget.student.adiSoyadi,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      );

  Widget photoGalleryWidget() {
    if (album.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 15),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: album.length,
          itemBuilder: (context, i) {
            return GestureDetector(
              child: Stack(
                children: [
                  Container(
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
                  if (isEditButtonClicked == true) ...[
                    //if Admin wants to delete Photos, he can use this CheckBox.
                    Checkbox(
                      value: _isChanged![i],
                      onChanged: (v) {
                        setState(() {
                          _isChanged![i] = v!;
                          if (v == true) {
                            willBeDeletedUrlList.add(album[i]);
                            debugPrint(willBeDeletedUrlList.toString());
                          } else {
                            willBeDeletedUrlList.remove(album[i]);
                            debugPrint(willBeDeletedUrlList.toString());
                          }
                        });
                        debugPrint("${_isChanged![i]}");
                      },
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(4.0),
                        ),
                      ),
                    )
                  ]
                ],
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
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);

    allRatings = await userModel.getRatings(userModel.users!.kresCode!,
        userModel.users!.kresAdi!, widget.student.ogrID);
    debugPrint(allRatings.toString());
  }

  Widget last3Ratings() {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 8),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 5,
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allRatings.length > 3 ? 3 : allRatings.length,
            itemBuilder: (context, i) {
              return GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: singleRatingWidgetMini(allRatings[i]),
                ),
                onTap: () {
                  _showRatingDetails(allRatings[i]);
                },
              );
            }),
      ),
    );
  }

  Widget singleRatingWidgetMini(Map<String, dynamic> ratingDaily) {
    String date =
        ratingDaily['Değerlendirme Tarihi'].toString().substring(0, 11);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        if (ratingDaily['Özel Not'] != null) ...[
          const Positioned(
            right: -10,
            top: -10,
            child: Icon(
              Icons.star_outlined,
              color: Colors.black,
            ),
          )
        ],
        Container(
          height: 150,
          width: 140,
          decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: const BorderRadius.all(Radius.circular(8))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    date,
                    style: const TextStyle(color: Colors.black, fontSize: 10),
                  ),
                ),
              ),
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ratingDaily.keys.length,
                    itemBuilder: (context, i) {
                      if (ratingDaily.keys.elementAt(i) !=
                              'Değerlendirme Tarihi' &&
                          ratingDaily.keys.elementAt(i) != 'Özel Not') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.0, horizontal: 2.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    ratingDaily.keys.elementAt(i),
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 8),
                                  ),
                                ),
                                Expanded(
                                  child: RatingBar(
                                    itemSize: 8,
                                    initialRating:
                                        ratingDaily.values.elementAt(i),
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
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 1.0),
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
                    }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future getIndividualPhotos() async {
    final UserModel _userModel = Provider.of<UserModel>(context, listen: false);
    album = await _userModel.getPhotoToSpecialGallery(
        _userModel.users!.kresCode!,
        _userModel.users!.kresAdi!,
        widget.student.ogrID);
    if (album.isNotEmpty) {
      _isChanged = List<bool>.filled(album.length, false);
    }
  }

  void _showRatingDetails(Map<String, dynamic> rating) {
    showDialog(
        context: context,
        builder: (context) {
          return RatingDetailsWidget(rating);
        });
  }

  List<Widget> editingButtonForAdmin() {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    return [
      if (isEditButtonClicked == true) ...[
        IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Silmek istediğinizden emin misiniz?'),
                action: SnackBarAction(
                    label: "Evet",
                    onPressed: () {
                      userModel
                          .deletePhoto(
                              userModel.users!.kresCode!,
                              userModel.users!.kresAdi!,
                              '',
                              willBeDeletedUrlList)
                          .then((value) {
                        if (value) {
                          setState(() {
                            isEditButtonClicked = false;
                            _isChanged = List<bool>.filled(album.length, false);
                          });
                        }
                      });
                    }),
              ));
            },
            icon: const Icon(Icons.check_rounded)),
        IconButton(
            onPressed: () {
              setState(() {
                willBeDeletedUrlList.clear();
                _isChanged = List<bool>.filled(album.length, false);
                isEditButtonClicked = false;
              });
            },
            icon: const Icon(Icons.clear_rounded)),
      ],
      if (isEditButtonClicked == false) ...[
        IconButton(
            onPressed: () {
              setState(() {
                isEditButtonClicked = true;
              });
            },
            icon: const Icon(Icons.mode_edit_outline_rounded))
      ],
    ];
  }
}

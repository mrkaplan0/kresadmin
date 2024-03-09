// ignore_for_file: library_private_types_in_public_api

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/common_widget/show_photo_widget.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/image_crop.dart';
import 'package:kresadmin/models/photo.dart';
import 'package:provider/provider.dart';

class PhotoGallery extends StatefulWidget {
  final List<Photo>? album;

  @override
  _PhotoGalleryState createState() => _PhotoGalleryState();

  const PhotoGallery({this.album, super.key});
}

class _PhotoGalleryState extends State<PhotoGallery> {
  List<Photo> album = [];
  bool isEditButtonClicked = false;
  List<bool>? _isChanged;
  List<Photo> willBeDeletedUrlList = [];

  @override
  void initState() {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);

    userModel
        .getPhotoToMainGallery(
            userModel.users!.kresCode!, userModel.users!.kresAdi!)
        .then((value) {
      album.addAll(value);
      if (album.isNotEmpty) {
        _isChanged = List<bool>.filled(album.length, false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fotoğraf Galerisi",
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        actions: actionButtonForAdmin(),
      ),
      floatingActionButton: userModel.users!.position == 'Admin' ||
              userModel.users!.position == 'Teacher'
          ? FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ImageCrop())),
            )
          : null,
      body: userModel.users!.position == 'Admin' ||
              userModel.users!.position == 'Teacher'
          ? photoGallery()
          : photoGalleryWidget(),
    );
  }

  List<Widget> actionButtonForAdmin() {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    return [
      //approve deleting wıth dialog button
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

        //cancel button
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
      //edit button
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

  Widget photoGalleryWidget() {
    if (widget.album!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 15),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemCount: widget.album!.length,
          itemBuilder: (context, i) {
            return GestureDetector(
                child: Container(
                  margin: const EdgeInsets.all(6),
                  height: 130,
                  width: 200,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
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
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 14.0, right: 14),
        child: Container(
          height: 200,
        ),
      );
    }
  }

  Widget photoGallery() {
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 15),
      child: StreamBuilder<List<Photo>>(
          stream: userModel
              .getPhotoToMainGallery(
                  userModel.users!.kresCode!, userModel.users!.kresAdi!)
              .asStream(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(6),
                            height: 130,
                            width: 200,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              child: ExtendedImage.network(
                                snapshot.data![i].photoUrl,
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
                                    willBeDeletedUrlList.add(snapshot.data![i]);
                                    debugPrint(willBeDeletedUrlList.toString());
                                  } else {
                                    willBeDeletedUrlList
                                        .remove(snapshot.data![i]);
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
                        if (isEditButtonClicked == true) {
                          setState(() {
                            _isChanged![i] = !_isChanged![i];
                            if (_isChanged![i] == true) {
                              willBeDeletedUrlList.add(snapshot.data![i]);
                              debugPrint(willBeDeletedUrlList.toString());
                            } else {
                              willBeDeletedUrlList.remove(snapshot.data![i]);
                              debugPrint(willBeDeletedUrlList.toString());
                            }
                          });
                          debugPrint("${_isChanged![i]}");
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return ShowPhotoWidget(
                                    snapshot.data![i].photoUrl);
                              });
                        }
                      });
                },
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(left: 14.0, right: 14),
                child: Container(
                  height: 200,
                ),
              );
            }
          }),
    );
  }
}

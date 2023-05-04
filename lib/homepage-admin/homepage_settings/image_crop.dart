import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kresadmin/View_models/user_model.dart';
import 'package:kresadmin/homepage-admin/homepage_settings/photo_editor.dart';
import 'package:kresadmin/models/student.dart';
import 'package:provider/provider.dart';

const int maxFailedLoadAttempts = 3;

class ImageCrop extends StatefulWidget {
  final Student? student;

  const ImageCrop({
    Key? key,
    this.student,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ImageCropState createState() => _ImageCropState();
}

class _ImageCropState extends State<ImageCrop> {
  XFile? _pickedFile;
  CroppedFile? _croppedFile;
  int uploadCounts = 0;
  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  static const AdRequest request = AdRequest(
    keywords: <String>['çocuk', 'kreş', 'eğitim', 'okul'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,

  );

  @override
  void initState() {
    super.initState();
    final UserModel userModel = Provider.of<UserModel>(context, listen: false);
    userModel
        .getUploadCounts(userModel.users!.kresCode!, userModel.users!.kresAdi!)
        .then((value) {
      setState(() {
        uploadCounts = value;
      });
      if (uploadCounts == 0) {

        _createRewardedAd();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: !kIsWeb
          ? AppBar(
              title: const Text("Resim Yükle"),
              centerTitle: true,
            )
          : null,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (kIsWeb)
            Padding(
              padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
              child: Text(
                "Resim Yükle",
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Theme.of(context).highlightColor),
              ),
            ),
          counter(),
          Expanded(child: _body()),
        ],
      ),
    );
  }

  Widget counter() {
    if (uploadCounts > 0) {
      return Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Kalan  Foto Yükleme Hakkı: ",
            style: TextStyle(fontSize: 18),
          ),
          Text(
            " $uploadCounts",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ));
    } else {
      return Column(
        children: [
          const Center(
              child: Text(
            "Foto Yükleme Hakkınız doldu. ",
            style: TextStyle(fontSize: 18),
          )),
          const SizedBox(height: 5),
          const Center(
              child: Text(
            "Haklarınızı güncellemek için tıklayın.",
            style: TextStyle(fontSize: 18),
          )),
          const SizedBox(height: 15),
          ElevatedButton(onPressed: () {
            final UserModel userModel = Provider.of<UserModel>(context, listen: false);
            _showRewardedAd();
            userModel
                .getUploadCounts(userModel.users!.kresCode!, userModel.users!.kresAdi!)
        .then((value) {
    setState(() {
    uploadCounts = value;
    });});
          }, child: const Text("Hak Kazan"))
        ],
      );
    }
  }

  Widget _body() {
    if (_croppedFile != null || _pickedFile != null) {
      return _imageCard();
    } else {
      return _uploaderCard();
    }
  }

  Widget _imageCard() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: kIsWeb ? 24.0 : 16.0),
            child: Card(
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(kIsWeb ? 24.0 : 16.0),
                child: _image(),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          _menu(),
        ],
      ),
    );
  }

  Widget _image() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    if (_croppedFile != null) {
      final path = _croppedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else if (_pickedFile != null) {
      final path = _pickedFile!.path;
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 0.8 * screenWidth,
          maxHeight: 0.7 * screenHeight,
        ),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _menu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FloatingActionButton(
          heroTag: 'Sil',
          onPressed: () {
            _clear();
          },
          backgroundColor: Colors.redAccent,
          tooltip: 'Sil',
          child: const Icon(Icons.delete),
        ),
        if (_croppedFile == null)
          FloatingActionButton(
            heroTag: 'Crop',
            onPressed: () {
              _cropImage();
            },
            backgroundColor: const Color(0xFFBC764A),
            tooltip: 'Düzenle',
            child: const Icon(Icons.crop),
          ),
        FloatingActionButton(
          heroTag: 'Approve',
          onPressed: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PhotoEditor(
                      editedPhoto: File(_pickedFile!.path),
                      student: widget.student != null ? widget.student : null,
                    )));
          },
          backgroundColor: Colors.green,
          tooltip: 'Onayla',
          child: const Icon(Icons.check_rounded),
        ),
      ],
    );
  }

  Widget _uploaderCard() {
    return Center(
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SizedBox(
          width: kIsWeb ? 380.0 : 340.0,
          height: 320.0,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image,
                          color: Theme.of(context).highlightColor,
                          size: 80.0,
                        ),
                        const SizedBox(height: 24.0),
                        Text(
                          'Lütfen foto yükleyin',
                          style: kIsWeb
                              ? Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                      color: Theme.of(context).highlightColor)
                              : Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      color: Theme.of(context).highlightColor),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: ElevatedButton(
                        onPressed: uploadCounts > 0
                            ? () {
                                _uploadFromCamera();
                              }
                            : null,
                        child: const Text('Foto Çek'),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: ElevatedButton(
                        onPressed: uploadCounts > 0
                            ? () {
                                _uploadFromGallery();
                              }
                            : null,
                        child: const Text('Galeriden Yükle'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = croppedFile;
        });
      }
    }
  }

  Future<void> _uploadFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

  Future<void> _uploadFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedFile = pickedFile;
      });
    }
  }

  void _clear() {
    setState(() {
      _pickedFile = null;
      _croppedFile = null;
    });
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3940256099942544/5224354917'
            : 'ca-app-pub-3940256099942544~3347511713',
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd() {

    if (_rewardedAd == null) {
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
         debugPrint('********************************ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        debugPrint('$ad **********************************************onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        debugPrint('************************************$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async{
          debugPrint('***********************************************$ad with reward ${RewardItem(
              reward.amount,reward.type).toString()}');
          final UserModel userModel = Provider.of<UserModel>(context, listen: false);
        await  userModel.updateUploadCounts(userModel.users!.kresCode!, userModel.users!.kresAdi!);
    });
    _rewardedAd = null;
  }
}

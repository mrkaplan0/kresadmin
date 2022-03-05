class Photo {
  final String photoUrl;
  String? ogrID;
  String? info;
  String time;
  bool? isShowed;

  Photo(
      {required this.photoUrl,
      this.ogrID,
      this.info,
      required this.time,
      this.isShowed});

  Map<String, dynamic> toMap() {
    return {
      'photoUrl': photoUrl,
      'ogrID': ogrID,
      'info': info,
      'time': time,
      'isShowed': isShowed ?? false,
    };
  }

  Photo.fromMap(Map<String, dynamic> map)
      : photoUrl = map['photoUrl'],
        ogrID = map['ogrID'],
        info = map['info'],
        time = map['time'],
        isShowed = map['isShowed'];

  @override
  String toString() {
    return 'Photo{photoUrl: $photoUrl, ogrID: $ogrID, info: $info, time: $time, isShowed: $isShowed}';
  }
}

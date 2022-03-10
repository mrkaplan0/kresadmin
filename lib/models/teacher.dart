class Teacher {
  String teacherID;
  String adiSoyadi;
  String? telefonNo;
  String? position;
  String? kresAdi;
  String? kresCode;
  String? sinifi;
  String? fotoUrl;
  bool? authorisation;

  Teacher(
      {required this.teacherID,
      required this.adiSoyadi,
      this.telefonNo,
      this.position,
      this.kresAdi,
      this.kresCode,
      this.sinifi,
      this.fotoUrl,
      this.authorisation});

  Map<String, dynamic> toMap() {
    return {
      'teacherID': teacherID,
      'adiSoyadi': adiSoyadi,
      'telefonNo': telefonNo,
      'position': position ?? 'Öğretmen',
      'kresAdi': kresAdi,
      'kresCode': kresCode,
      'sinifi': sinifi ?? 'A',
      'fotoUrl': fotoUrl,
      'authorisation': authorisation ?? false,
    };
  }

  Teacher.fromMap(Map<String, dynamic> map)
      : teacherID = map['teacherID'],
        adiSoyadi = map['adiSoyadi'],
        telefonNo = map['telefonNo'],
        position = map['position'],
        kresAdi = map['kresAdi'],
        kresCode = map['kresCode'],
        sinifi = map['sinifi'],
        fotoUrl = map['fotoUrl'],
        authorisation = map['authorisation'];

  @override
  String toString() {
    return 'Teacher {teacherID: $teacherID, adiSoyadi: $adiSoyadi, telefonNo: $telefonNo, position: $position, kresAdi: $kresAdi, kresCode: $kresCode, sinifi: $sinifi, fotoUrl: $fotoUrl, authorisation: $authorisation}';
  }
}

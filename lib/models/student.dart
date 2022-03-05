class Student {
  String ogrID;
  String adiSoyadi;
  String? dogumTarihi;
  String? cinsiyet;
  String? veliAdiSoyadi;
  String? veliTelefonNo;
  String? sinifi;
  String? fotoUrl;

  Student(
      {required this.ogrID,
      required this.adiSoyadi,
      this.dogumTarihi,
      this.cinsiyet,
      this.veliAdiSoyadi,
      this.veliTelefonNo,
      this.sinifi,
      this.fotoUrl});

  Map<String, dynamic> toMap() {
    return {
      'ogrID': ogrID,
      'adiSoyadi': adiSoyadi,
      'dogumTarihi': dogumTarihi,
      'cinsiyet': cinsiyet,
      'veliAdiSoyadi': veliAdiSoyadi,
      'veliTelefonNo': veliTelefonNo,
      'sinifi': sinifi ?? 'A',
      'fotoUrl': fotoUrl,
    };
  }

  Student.fromMap(Map<String, dynamic> map)
      : ogrID = map['ogrID'],
        adiSoyadi = map['adiSoyadi'],
        dogumTarihi = map['dogumTarihi'],
        cinsiyet = map['cinsiyet'],
        veliAdiSoyadi = map['veliAdiSoyadi'],
        veliTelefonNo = map['veliTelefonNo'],
        sinifi = map['sinifi'],
        fotoUrl = map['fotoUrl'];

  @override
  String toString() {
    return 'Student {ogrID: $ogrID, adiSoyadi: $adiSoyadi, dogumTarihi: $dogumTarihi, cinsiyet: $cinsiyet, veliAdiSoyadi: $veliAdiSoyadi, veliTelefonNo: $veliTelefonNo, sinifi: $sinifi, fotoUrl: $fotoUrl}';
  }
}

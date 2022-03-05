class Hatalar {
  static String goster(String hataKodu) {
    switch (hataKodu) {
      case 'user-not-found':
        return 'Hesabınız yok ya da email adresi yanlış';
      case 'email-already-in-use':
        return 'Bu e-mail adresi zaten kullanımda, lütfen giriş yapın.';

      default:
        return 'Bir hata oluştu';
    }
  }
}


import 'package:flutter_test/flutter_test.dart';
import 'package:simple_application/models/ogrenci.dart';
import 'package:simple_application/repository/ogrenciler_repository.dart';

void main(){
  test("sevdiğim öğrenci seviyor olarak görüyor mu", (){
    final ogrencilerRepository = OgrencilerRepository();

    final yeniOgrenci = Ogrenci("test ad", "test soyad",15, "erkek");
    ogrencilerRepository.ogrenciler.add(yeniOgrenci);
    expect(ogrencilerRepository.seviyorMuyum(yeniOgrenci), false);
    ogrencilerRepository.sev(yeniOgrenci, true);
    expect(ogrencilerRepository.seviyorMuyum(yeniOgrenci), true);
    ogrencilerRepository.sev(yeniOgrenci, false);
    expect(ogrencilerRepository.seviyorMuyum(yeniOgrenci), false);
    ogrencilerRepository.sev(yeniOgrenci, false);
    expect(ogrencilerRepository.seviyorMuyum(yeniOgrenci), false);

    ogrencilerRepository.ogrenciler.remove(yeniOgrenci);
    expect(ogrencilerRepository.seviyorMuyum(yeniOgrenci), false);
  });
}
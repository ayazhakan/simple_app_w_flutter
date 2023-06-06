import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_application/models/ogretmen.dart';

class DataService {
  final String baseUrl = 'https://644bee604bdbc0cc3a9e4c53.mockapi.io/';
  int sayac=1;
  Future<Ogretmen> ogretmenIndir() async {

    final response = await http.get(Uri.parse('$baseUrl/ogretmen/$sayac'));
    sayac++;
    if (response.statusCode == 200) {

      return Ogretmen.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Öğretmen indirlemedi ${response.statusCode}');
    }

  }

  Future<void> ogretmenEkle(Ogretmen ogretmen) async {
   await FirebaseFirestore.instance.collection('ogretmenler').add(ogretmen.toMap());


    final response =await http.post(
      Uri.parse('$baseUrl/ogretmen'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(ogretmen.toMap()),
    );
    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception('Öğretmen eklenemedi. ${response.statusCode}');
    }
  }

 Future<List<Ogretmen>> ogretmenleriGetir() async {
   final querySnapshot = await FirebaseFirestore.instance.collection('ogretmenler').get();
   return querySnapshot.docs.map((e) => Ogretmen.fromMap(e.data())).toList();
    final response = await http.get(Uri.parse('$baseUrl/ogretmen'));
    sayac++;
    if (response.statusCode == 200) {
final l =jsonDecode(response.body);
return l.map<Ogretmen>((e)=> Ogretmen.fromMap(e)).toList();

    } else {
      throw Exception('Öğretmen indirlemedi ${response.statusCode}');
    }
  }
}

final dataServiceProvider = Provider((ref) {
  return DataService();
});



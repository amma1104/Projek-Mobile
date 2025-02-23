import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tugasteori1/app/modules/berita/models/berita_model.dart';

class BeritaService {
  static var client = http.Client();

  static Future<List<BeritaModel>> fetchBerita() async {

    var response = await client.get(Uri.parse('https://newsapi.org/v2/everything?q=finance&language=id&sortBy=publishedAt&apiKey=9a6a879f8a224ce39b508daeb89b8449'));

    if (response.statusCode == 200) {
      var jsonString = response.body;
      var jsonMap = json.decode(jsonString);
      List<dynamic> beritaList = jsonMap['articles'];
      return beritaList.map((article) => BeritaModel.fromJson(article)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}

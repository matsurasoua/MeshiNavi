// ホットペッパーAPI取得

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Apifech {
  // APIkey取得
  String key = dotenv.get('API_KEY');
  // URL取得
  String url = dotenv.get('URL');

  Future<dynamic> printapi(double lat, double lng, int range, int count) async {
    url =
        '$url?key=$key&lat=$lat&lng=$lng&range=$range&count=$count&format=json';
    print(url);
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    final jsonData = utf8.decode(response.bodyBytes);
    final jsondataText = json.decode(jsonData);

    if (response.statusCode == 200) {
      return jsondataText;
    } else {
      throw Exception("取得失敗");
    }
  }
}

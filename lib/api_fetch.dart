import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Apifech {
  String key = dotenv.get('API_KEY');
  String url = dotenv.get('URL');

  void printapi(double lat, double lng, int range) async {
    url = '$url?key=$key&lat=$lat&lng=$lng&range=$range&format=json';
    print(url);
    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    final jsonData = utf8.decode(response.bodyBytes);
    final jsonData_text = json.decode(jsonData);
    print(response.statusCode);
    print(jsonData_text);

    // if (response.statusCode == 200) {
    //   // print(response.statusCode);
    //   print('取得成功');
    //   return jsonData_text;
    // } else {
    //   print(response.statusCode);
    //   throw Exception("取得失敗");
    // }
  }
}

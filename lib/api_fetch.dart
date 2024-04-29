// ホットペッパーAPI取得

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Apifech {
  // APIkey取得
  String key = dotenv.get('API_KEY');
  // URL取得
  String url = dotenv.get('URL');
  // 値段取得
  String url_budget = dotenv.get('BUDGET_API');
  // ジャンル取得
  String url_genre = dotenv.get('GENRE_API');

  Stream<dynamic> printapi(
      double lat, double lng, int range, int count) async* {
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
    // レスポンスコードが200の時(成功)
    if (response.statusCode == 200) {
      yield jsondataText;
      // 何らかの原因で失敗している時
    } else {
      throw Exception("取得失敗");
    }
  }

// ジャンルと値段取得s
  Future<List> Api_list() async {
    final response_budget = await http.get(
      Uri.parse(url_budget),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    // 値段json
    final jsonData_budget = utf8.decode(response_budget.bodyBytes);
    final jsonbudget = json.decode(jsonData_budget);

    final response_genre = await http.get(
      Uri.parse(url_genre),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    // ジャンルjson
    final jsonData_genre = utf8.decode(response_genre.bodyBytes);
    final jsongenre = json.decode(jsonData_genre);

    dynamic budget = jsonbudget['results']['budget'];
    dynamic genre = jsongenre['results']['genre'];

    // print(budget);
    // print(genre);

    return [budget, genre];
  }
}

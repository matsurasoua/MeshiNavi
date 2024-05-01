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

  Future<dynamic> printapi(double lat, double lng, int count, int range,
      String budgetcode, String genreCode) async {
    // 全てを選択した際の'　'を''に変換
    if (budgetcode == ' ') budgetcode = '';
    if (genreCode == ' ') genreCode = '';

    url =
        '$url?key=$key&lat=$lat&lng=$lng&count=$count&range=$range&budget=$budgetcode&genre=$genreCode&format=json';
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
      return jsondataText;
      // 何らかの原因で失敗している時
    } else {
      throw Exception("取得失敗");
    }
  }

// ジャンルと値段取得
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

    List budget = jsonbudget['results']['budget'];
    budget.insert(0, {'code': ' ', 'name': 'すべて'});
    List genre = jsongenre['results']['genre'];
    genre.insert(0, {'code': ' ', 'name': 'すべて'});

    // print(budget);
    // print(genre);

    return [budget, genre];
  }
}

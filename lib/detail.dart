import 'package:flutter/material.dart';
import 'package:meshinavi/settingcolor.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.info});
  final dynamic info;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    var info = widget.info;
    // print(info);
    // 店名
    String name = info['name'];
    // 画像Lサイズ
    String photo = info['photo']['mobile']['l'];
    // ジャンル
    String genre = info['genre']['name'];
    // キャッチコピー
    String catches = info['genre']['catch'];
    // 住所
    String address = info['address'];
    // open時間
    String time = info['open'];
    // 緯度
    double lat = info['lat'];
    // 経度
    double lng = info['lng'];

    print(photo);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(Setting_Color.setting_gray)),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Image.network(
              photo,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}

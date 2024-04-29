// 詳細画面
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:meshinavi/settingcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.info});
  final dynamic info;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    // MAPkey取得
    String map_key = dotenv.get('MAP_KEY');
    // 店情報json形式
    var info = widget.info;
    // 店名
    String name = info['name'];
    // 画像Lサイズ
    String photo = info['photo']['pc']['l'];
    // ジャンル
    String genre = info['genre']['name'];
    // キャッチコピー
    String catches = info['genre']['catch'];
    // 値段
    String price = info['budget']['name'];
    // 住所
    String address = info['address'];
    // open時間
    String time = info['open'];
    // アクセス
    String access = info['mobile_access'];
    // 緯度
    double lat = info['lat'];
    // 経度
    double lng = info['lng'];
    // URL
    String shop_url = info['urls']['pc'];

    return Scaffold(
      backgroundColor: Color(Setting_Color.setting_background),
      appBar: AppBar(
        title: Text(
          '詳細',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: Color(Setting_Color.setting_brown).withOpacity(0.9),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 店の画像
            Container(
              width: double.infinity,
              height: 280,
              child: Image.network(
                photo,
                fit: BoxFit.fitWidth,
              ),
            ),
            // ジャンル
            Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '$genre / $catches',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(
                      Setting_Color.setting_gray,
                    ),
                  ),
                ),
              ),
            ),
            // 名前
            Container(
              margin: EdgeInsets.only(left: 10, right: 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
            // 値段
            Container(
              margin: EdgeInsets.only(top: 10, right: 5, bottom: 10),
              child: Align(
                alignment: Alignment.topRight,
                child: Text(
                  price,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(Setting_Color.setting_red),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // 住所
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // 枠線の色
                  width: 0.6, // 枠線の幅
                ),
              ),
              child: ListTile(
                tileColor: Colors.white,
                leading: Icon(
                  Icons.location_on_outlined,
                  size: 20,
                  color: Colors.red,
                ),
                title: Text(
                  address,
                  style: TextStyle(fontSize: 13),
                ),
                dense: true,
              ),
            ),
            // 営業時間
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // 枠線の色
                  width: 0.6, // 枠線の幅
                ),
              ),
              child: ListTile(
                tileColor: Colors.white,
                leading: Icon(
                  Icons.access_time,
                  size: 20,
                  color: Colors.green,
                ),
                title: Text(
                  time,
                  style: TextStyle(fontSize: 13),
                ),
                dense: true,
              ),
            ),
            // アクセス
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // 枠線の色
                  width: 0.6, // 枠線の幅
                ),
              ),
              child: ListTile(
                tileColor: Colors.white,
                leading: Icon(
                  Icons.directions_walk,
                  size: 20,
                  color: Colors.deepOrange,
                ),
                title: Text(
                  access,
                  style: TextStyle(fontSize: 13),
                ),
                dense: true,
              ),
            ),
            // Map文字列
            Container(
              margin: EdgeInsets.only(top: 40),
              child: Text(
                'Map',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            // マップ
            Container(
              height: 400,
              margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 15),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // 枠線の色
                  width: 1, // 枠線の幅
                ),
              ),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(
                    lat,
                    lng,
                  ),
                  initialZoom: 17,
                  // 拡大倍率上限
                  maxZoom: 20,
                  //縮小倍率上限
                  minZoom: 12,
                ),
                children: [
                  TileLayer(
                    // z:ズーム倍率、x:lat、y:lng
                    urlTemplate:
                        'https://api.maptiler.com/maps/jp-mierune-streets/256/{z}/{x}/{y}.png?key=$map_key',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: LatLng(lat, lng),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 40,
                        ),
                        rotate: true,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 30, bottom: 30),
              child: Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                    onTap: () {
                      final url = Uri.parse(shop_url);
                      launchUrl(url);
                    },
                    child: const Text(
                      '公式ページ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(Setting_Color.setting_blue),
                        decoration: TextDecoration.underline,
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

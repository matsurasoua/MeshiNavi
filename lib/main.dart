// メイン画面

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meshinavi/currentlocation.dart';
import 'package:meshinavi/result.dart';
import 'package:meshinavi/settingcolor.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  const app = MyApp();
  const scope = ProviderScope(child: app);
  runApp(scope);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
// ECCの緯度経度
  double lat2 = 34.706388;
  double lng2 = 135.5010759;
  // double lat2 = 34.3854287;
  // double lng2 = 135.3721289;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Setting_Color.setting_background),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 145),
            child: Center(
              child: Text(
                'めしナビ',
                style: TextStyle(
                    color: Color(Setting_Color.setting_brown),
                    fontWeight: FontWeight.bold,
                    fontSize: 35),
              ),
            ),
          ),
          Container(
            width: 220,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(Setting_Color.setting_brown),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10) //こちらを適用
                    ),
              ),
              child: const Text('検索'),
              onPressed: () async {
                // 緯度経度取得
                Position currentlocation = await position();
                double lat = currentlocation.latitude;
                double lng = currentlocation.longitude;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResultPage(
                            lat: lat2,
                            lng: lng2,
                          ),
                      fullscreenDialog: true),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

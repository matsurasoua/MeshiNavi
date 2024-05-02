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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(Setting_Color.setting_brown),
      body: Container(
        margin: EdgeInsets.only(top: 200, bottom: 200),
        color: Color(Setting_Color.setting_background),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 70),
              child: Center(
                child: Text(
                  'めしナビ',
                  style: TextStyle(
                      color: Color(Setting_Color.setting_brown),
                      fontWeight: FontWeight.bold,
                      fontSize: 60),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 100, bottom: 20),
              child: Text(
                '近くの飲食店を見つけるのをサポートします！',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(Setting_Color.setting_brown),
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
                child: const Text('近くのレストランを探す！'),
                onPressed: () async {
                  try {
                    Position currentlocation = await position();
                    double lat = currentlocation.latitude;
                    double lng = currentlocation.longitude;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResultPage(
                                lat: lat,
                                lng: lng,
                              ),
                          fullscreenDialog: true),
                    );
                  } catch (e) {
                    print(e);
                  }
                  // 緯度経度取得
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

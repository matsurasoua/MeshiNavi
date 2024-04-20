// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meshinavi/api_fetch.dart';
import 'package:meshinavi/settingcolor.dart';

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
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
      backgroundColor: Color(Setting_Color.setting_background),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 145),
            child: Center(
              child: Text(
                "めしナビ",
                style: TextStyle(
                    color: Color(Setting_Color.setting_brown),
                    fontWeight: FontWeight.bold,
                    fontSize: 35),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          print(dotenv.get('API_KEY'));
          // 現在地取得して検索
          Apifech().printapi(34.38666, 135.37279, 5);
        },
      ),
    );
  }
}

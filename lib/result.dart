import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:meshinavi/api_fetch.dart';
import 'package:meshinavi/detail.dart';
import 'package:meshinavi/settingcolor.dart';
// ignore_for_file: prefer_const_constructors

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(250, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(250, 255, 255, 255),
        title: const Text(
          '検索結果',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Color(Setting_Color.setting_gray)),
      ),
      // 右下のFAB
      floatingActionButton: SpeedDial(
          // 押す前のアイコン
          icon: Icons.tune,
          // 押し後のアイコン
          activeIcon: Icons.close,
          childPadding: const EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          backgroundColor: Color(Setting_Color.setting_brown),
          children: [
            SpeedDialChild(
              onTap: () async {
                await showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  enableDrag: true,
                  barrierColor: Colors.black.withOpacity(0.5),
                  builder: (context) {
                    return _BottomSheet();
                  },
                );
              },
              child: const Icon(
                Icons.filter_alt,
                color: Color(Setting_Color.setting_brown),
              ),
              label: "絞り込み",
            ),
            SpeedDialChild(
              child: const Icon(
                Icons.sort,
                color: Color(Setting_Color.setting_brown),
              ),
              label: "並び替え",
            ),
          ]),
      body: FutureBuilder(
          future: Apifech().printapi(35.6493601, 139.6732812, 5, 7),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final infos = snapshot.data;
              List<String> names = [];
              List<String> logoImages = [];
              List<String> catches = [];
              List<String> genre = [];
              List<String> access = [];
              List<String> budget = [];

              /**
            * 取得した情報を配列に格納
              names:店名
              logoImages:店のロゴ画像
              catches:キャッチコピー
              genre:ジャンル
              budget:金額
              access:アクセス情報(モバイル)
            */
              for (var i = 0; i < infos['results']['shop'].length; i++) {
                names.add(infos['results']['shop'][i]['name']);
                logoImages.add(infos['results']['shop'][i]['logo_image']);
                catches.add(infos['results']['shop'][i]['catch']);
                genre.add(infos['results']['shop'][i]['genre']['name']);
                budget.add(infos['results']['shop'][i]['budget']['name']);
                access.add(infos['results']['shop'][i]['mobile_access']);
              }
              int length = infos['results']['shop'].length;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(left: 10, top: 10),
                            child: Text(
                              '$length件',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                        ),
                      ],
                    ),
                    for (int i = 0; i < length; i++) ...{
                      // 結果表示
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(info: infos['results']['shop'][i]),
                            ),
                          );
                        },
                        child: Container(
                          height: 150,
                          margin: EdgeInsets.only(left: 10, right: 10, top: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Color(Setting_Color.setting_gray), // 枠線の色
                              width: 0.5, // 枠線の幅
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26, // 影の色
                                spreadRadius: 0.1, // 影の大きさ
                                blurRadius: 5.0, // 影の不透明度
                                offset: Offset(1, 3), // x軸、y軸をどれだけずらすか
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              // logo画像
                              Container(
                                margin: EdgeInsets.only(left: 2, top: 2),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Image.network(
                                    logoImages[i],
                                    width: 90,
                                    height: 90,
                                  ),
                                ),
                              ),
                              // 名前
                              Container(
                                margin: EdgeInsets.only(
                                    left: 95, right: 10, top: 10),
                                child: Text(
                                  overflow: TextOverflow.ellipsis,
                                  names[i],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                  ),
                                ),
                              ),
                              // 金額
                              Container(
                                margin: EdgeInsets.only(
                                    left: 95, right: 10, top: 50),
                                child: Text(
                                  budget[i],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Color(Setting_Color.setting_red)),
                                ),
                              ),
                              // キャッチコピー
                              Container(
                                margin: EdgeInsets.only(left: 95, top: 80),
                                child: Text(
                                  // キャッチコピーがない場合'キャッチコピー'出力
                                  catches[i] != '' ? catches[i] : "",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              // ジャンル
                              Container(
                                width: 80,
                                margin: EdgeInsets.only(top: 80, left: 5),
                                child: Center(
                                  child: Text(
                                    genre[i],
                                    style: TextStyle(
                                        fontSize: 11,
                                        color:
                                            Color(Setting_Color.setting_gray)),
                                  ),
                                ),
                              ),
                              // アクセス文章
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  margin: EdgeInsets.only(top: 130, right: 5),
                                  child: Text(
                                    access[i],
                                    style: TextStyle(
                                        fontSize: 11,
                                        color:
                                            Color(Setting_Color.setting_gray)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    },
                    // 最後までスクロールした時に被らないようにmargin
                    Container(
                      margin: EdgeInsets.only(top: 110),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  double _currentVal = 50;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      margin: EdgeInsets.only(top: 80),
    );
  }
}

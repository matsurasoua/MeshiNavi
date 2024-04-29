//検索結果表示
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meshinavi/api_fetch.dart';
import 'package:meshinavi/detail.dart';
import 'package:meshinavi/s1.dart';
import 'package:meshinavi/settingcolor.dart';

class ResultPage extends ConsumerWidget {
  const ResultPage({super.key, required this.lat, required this.lng});
  final double lat;
  final double lng;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 状態管理をしている値を取得するプロパティ(デフォは１)
    final s1 = ref.watch(s1NotifierProvider);
    print('s1:$s1');

    print('lat:$lat,lng:$lng');
    return Scaffold(
      backgroundColor: Color(Setting_Color.setting_background),
      appBar: AppBar(
        backgroundColor: Color(Setting_Color.setting_brown),
        title: const Text(
          '検索結果',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      // 右下のFAB
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(Setting_Color.setting_brown),
        foregroundColor: Colors.white,
        onPressed: () async {
          await showModalBottomSheet<bool>(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            enableDrag: true,
            barrierColor: Colors.black.withOpacity(0.5),
            builder: (context) => _BottomSheet(),
          );
        },
        icon: Icon(
          Icons.filter_alt,
          // size: 30,
        ),
        label: Text(
          '絞り込み',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
          stream: Apifech().printapi(lat, lng, s1, 100),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                print('接続中・・・・・');
              case ConnectionState.none:
                print('未接続・・・・・');
              case ConnectionState.active:
                print('通信中・・・・・');
              case ConnectionState.done:
                print('接続完了！！！！');
            }
            if (snapshot.hasData) {
              final infos = snapshot.data;
              // 取得データの数
              int length = infos['results']['shop'].length;
              // 件数が0ならのメッセージ表示
              if (length == 0) {
                return Center(
                  child: Text(
                    '近くにレストランが無いようです',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(Setting_Color.setting_gray)),
                  ),
                );
                // 取得データが1件以上ある場合の店一覧表示画面
              } else {
                /**
                * 
                  names:店名
                  logoImages:店のロゴ画像
                  catches:キャッチコピー
                  genre:ジャンル
                  access:アクセス情報(モバイル)
                  budget:金額
                */
                List<String> names = [];
                List<String> logoImages = [];
                List<String> catches = [];
                List<String> genre = [];
                List<String> budget = [];
                List<String> access = [];
                // 取得情報を配列に代入
                for (var i = 0; i < length; i++) {
                  names.add(infos['results']['shop'][i]['name']);
                  logoImages
                      .add(infos['results']['shop'][i]['photo']['pc']['l']);
                  catches.add(infos['results']['shop'][i]['genre']['catch']);
                  genre.add(infos['results']['shop'][i]['genre']['name']);
                  budget.add(infos['results']['shop'][i]['budget']['name']);
                  access.add(infos['results']['shop'][i]['mobile_access']);
                }
                print(names);

                return SingleChildScrollView(
                  child: Column(
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
                      for (int i = 0; i < length; i++) ...{
                        // 結果表示
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                    info: infos['results']['shop'][i]),
                              ),
                            );
                          },
                          child: Container(
                            height: 150,
                            margin:
                                EdgeInsets.only(left: 10, right: 10, top: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color:
                                    Color(Setting_Color.setting_gray), // 枠線の色
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
                                  margin: EdgeInsets.only(left: 4, top: 4),
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
                                      left: 100, right: 10, top: 10),
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
                                      left: 100, right: 10, top: 50),
                                  child: Text(
                                    budget[i],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color:
                                            Color(Setting_Color.setting_red)),
                                  ),
                                ),
                                // キャッチコピー
                                Container(
                                  margin: EdgeInsets.only(left: 100, top: 80),
                                  child: Text(
                                    // キャッチコピーがない場合'キャッチコピー'出力
                                    catches[i] != '' ? catches[i] : "",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                // ジャンル
                                Container(
                                  width: 90,
                                  margin: EdgeInsets.only(top: 100, left: 5),
                                  child: Center(
                                    child: Text(
                                      genre[i],
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Color(
                                              Setting_Color.setting_gray)),
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
                                          color: Color(
                                              Setting_Color.setting_gray)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      },
                      // 最後までスクロールした時にFABと被らないようにmargin
                      Container(
                        margin: EdgeInsets.only(top: 110),
                      ),
                    ],
                  ),
                );
              }
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

// FAB押した時の絞り込み画面＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
class _BottomSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // s2には状態管理している値が入っている
    final s2 = ref.watch(s2NotifierProvider);
    print('s2:$s2');
    final _intValue = ref.watch(s2NotifierProvider.notifier);

    return FutureBuilder(
      future: Apifech().Api_list(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final infos = snapshot.data;
          // 値段情報
          dynamic budget = infos?[0];
          // ジャンル情報
          dynamic genre = infos?[1];
          print(genre);
          // 金額個数
          int budget_length = budget.length;
          int genre_length = genre.length;

          return Container(
            height: 700,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // タイトル
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      '絞り込み',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  // 値段
                  Container(
                    margin: EdgeInsets.only(left: 15, top: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '値段',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  // 値段スクロール
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        children: [
                          for (int i = 0; i < budget_length; i++) ...{
                            Container(
                              width: 130,
                              margin: EdgeInsets.only(left: 3, right: 3),
                              child: OutlinedButton(
                                child: Text(
                                  budget[i]['name'],
                                  style: TextStyle(
                                    color: Color(
                                      Setting_Color.setting_gray,
                                    ),
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  primary: Colors.blue,
                                  side: const BorderSide(
                                    color: Color(
                                      Setting_Color.setting_gray,
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          },
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, top: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '距離',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  // ラジオボタン
                  Container(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Radio(
                              value: 1,
                              groupValue: s2, // 状態を表示する.
                              onChanged: (value) {
                                _intValue.state = value!; // 状態を操作する.
                              },
                            ),
                            Text('300m'),
                            Radio(
                              value: 2,
                              groupValue: s2, // 状態を表示する.
                              onChanged: (value) {
                                _intValue.state = value!; // 状態を操作する.
                              },
                            ),
                            Text('500m'),
                            Radio(
                              value: 3,
                              groupValue: s2, // 状態を表示する.
                              onChanged: (value) {
                                _intValue.state = value!; // 状態を操作する.
                              },
                            ),
                            Text('1000m'),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 4,
                              groupValue: s2, // 状態を表示する.
                              onChanged: (value) {
                                _intValue.state = value!; // 状態を操作する.
                              },
                            ),
                            Text('2000m'),
                            Radio(
                                value: 5,
                                groupValue: s2,
                                onChanged: (value) {
                                  _intValue.state = value!;
                                }),
                            Text('3000m'),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15, top: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'ジャンル',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 5, right: 5, top: 5),
                    child: GridView.count(
                      // grid固定
                      controller: new ScrollController(keepScrollOffset: false),
                      // Columnで表示するための
                      shrinkWrap: true,
                      // スペース
                      mainAxisSpacing: 1,
                      // スペース
                      crossAxisSpacing: 1,
                      // 列表示数
                      crossAxisCount: 3,
                      // 縦の比率
                      childAspectRatio: 3,
                      children: List.generate(
                        genre_length,
                        (index) {
                          return Container(
                            child: Center(
                              child: Text(
                                genre[index]['name'],
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color:
                                    Color(Setting_Color.setting_gray), // 枠線の色
                                width: 1, // 枠線の幅
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // リセットボタンとokボタン
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 40),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.bottomLeft,
                          // キャンセルボタン
                          child: Container(
                            width: 130,
                            height: 40,
                            child: OutlinedButton(
                              child: const Text(
                                'キャンセル',
                                style: TextStyle(
                                  color: Color(
                                    Setting_Color.setting_red,
                                  ),
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor:
                                    Color(Setting_Color.setting_red_backbround),
                                primary: Colors.black,
                                side: const BorderSide(
                                  color: Color(
                                    Setting_Color.setting_red,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          // OKボタン
                          child: Container(
                            width: 130,
                            height: 40,
                            child: OutlinedButton(
                              child: const Text(
                                'OK',
                                style: TextStyle(
                                  color: Color(
                                    Setting_Color.setting_blue,
                                  ),
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Color(
                                    Setting_Color.setting_blue_background),
                                primary: Colors.black,
                                side: const BorderSide(
                                  color: Color(
                                    Setting_Color.setting_blue,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                final notifier =
                                    ref.read(s1NotifierProvider.notifier);
                                print(notifier.state);
                                await notifier.updateState(s2);
                                print(notifier.state);
                                Navigator.pop(context, true);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

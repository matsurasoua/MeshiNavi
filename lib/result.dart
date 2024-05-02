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
    // 状態管理(範囲　デフォは3)
    final s1 = ref.watch(s1NotifierProvider);
    // 状態管理(ラジオボタン　デフォは3)
    final s2 = ref.watch(s2NotifierProvider);
    // 状態管理(値段　デフォは'')
    final s3 = ref.watch(s3NotifierProvider);
    // 状態管理(ジャンル　デフォは'')
    final s4 = ref.watch(s4NotifierProvider);
    // 状態管理(ジャンル　デフォは'')
    final s5 = ref.watch(s5NotifierProvider);
    // 状態管理(ジャンル　デフォは'')
    final s6 = ref.watch(s6NotifierProvider);
    // 状態管理(ジャンル　デフォは0)
    final s7 = ref.watch(s7NotifierProvider);
    // 状態管理(ジャンル　デフォは0)
    final s8 = ref.watch(s8NotifierProvider);
    // 状態管理(ジャンル　デフォは0)
    final s9 = ref.watch(s9NotifierProvider);
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

      body: FutureBuilder(
          future: Apifech().printapi(lat, lng, 100, s1, s3, s5),
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
                    '近くに飲食店が無いようです',
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
      // 右下のFAB
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(Setting_Color.setting_brown),
        foregroundColor: Colors.white,
        onPressed: () async {
          final notifier2 = ref.read(s2NotifierProvider.notifier);
          await notifier2.updateState(3);
          final notifier4 = ref.read(s4NotifierProvider.notifier);
          await notifier4.updateState('');
          final notifier6 = ref.read(s6NotifierProvider.notifier);
          await notifier6.updateState('');
          await showModalBottomSheet<bool>(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            enableDrag: false,
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
    );
  }
}

// FAB押した時の絞り込み画面＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
class _BottomSheet extends ConsumerWidget {
  List<bool> budgetState = List.filled(14, false);
  List<bool> genreButtonStates = List.filled(18, false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 状態管理(範囲　デフォは3)
    final s1 = ref.watch(s1NotifierProvider);
    // 状態管理(ラジオボタン　デフォは3)
    final s2 = ref.watch(s2NotifierProvider);
    // 状態管理(値段　デフォは'')
    final s3 = ref.watch(s3NotifierProvider);
    // 状態管理(ジャンル　デフォは'')
    final s4 = ref.watch(s4NotifierProvider);
    // 状態管理(ジャンル　デフォは'')
    final s5 = ref.watch(s5NotifierProvider);
    // 状態管理(ジャンル　デフォは'')
    final s6 = ref.watch(s6NotifierProvider);
    // 状態管理(ジャンル　デフォは'')
    final s7 = ref.watch(s7NotifierProvider);
    // 状態管理(ジャンル　デフォは'')
    final s8 = ref.watch(s8NotifierProvider);
    // 状態管理(ジャンル　デフォは'')
    final s9 = ref.watch(s9NotifierProvider);
    // ラジオボタン
    final Value2 = ref.watch(s2NotifierProvider.notifier);
    // 値段
    final Value4 = ref.watch(s4NotifierProvider.notifier);
    // ジャンル
    final Value6 = ref.watch(s6NotifierProvider.notifier);
    // 値段ボタンon,off　添字が入る
    final Value8 = ref.watch(s8NotifierProvider.notifier);
    // 値段ボタンon,off　添字が入る
    final Value9 = ref.watch(s9NotifierProvider.notifier);

    print('***********************');
    print('s1range:$s1');
    print('s2range:$s2');
    print('s3budget:$s3');
    print('s4budget:$s4');
    print('s5genre:$s5');
    print('s6genre:$s6');
    // print('s7最終値i:$s7');
    // print('s8今の値i:$s8');
    // print('s9前の値i:$s9');
    print('***********************');
    return FutureBuilder(
      future: Apifech().Api_list(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final infos = snapshot.data;
          // 値段情報
          List budget = infos?[0];
          print(budget.length);
          // ジャンル情報
          List genre = infos?[1];
          // 金額個数
          int budget_length = budget.length;
          // ジャンル個数
          int genre_length = genre.length;

          return Container(
            height: 700,
            decoration: BoxDecoration(
              color: Color(Setting_Color.setting_background),
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
                              width: 140,
                              margin: EdgeInsets.only(left: 3, right: 3),
                              child: OutlinedButton(
                                child: Text(
                                  budget[i]['name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 13),
                                ),
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.all(0),
                                  backgroundColor: budgetState[i]
                                      ? Color(
                                          Setting_Color.setting_blue_background)
                                      : Colors.white,
                                  foregroundColor: Colors.blue,
                                  side: BorderSide(
                                    color: Color(
                                      Setting_Color.setting_gray,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  //オンオフ切り替え
                                  budgetState[i] = !budgetState[i];
                                  // false->trueなら　新しく押した時の処理
                                  if (budgetState[i]) {
                                    budgetState =
                                        List.filled(budget_length, false);
                                    budgetState[i] = true;
                                    Value4.state = '';
                                    Value4.state = budget[i]['code'];
                                  }
                                },
                              ),
                            ),
                          },
                        ],
                      ),
                    ),
                  ),

                  // 距離
                  Container(
                    margin: EdgeInsets.only(left: 15, top: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        '距離(デフォルトは1000m)',
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
                                Value2.state = value!; // 状態を操作する.
                              },
                            ),
                            Text('300m',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            Radio(
                              value: 2,
                              groupValue: s2, // 状態を表示する.
                              onChanged: (value) {
                                Value2.state = value!; // 状態を操作する.
                              },
                            ),
                            Text('500m',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            Radio(
                              value: 3,
                              groupValue: s2, // 状態を表示する.
                              onChanged: (value) {
                                Value2.state = value!; // 状態を操作する.
                              },
                            ),
                            Text('1000m',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                              value: 4,
                              groupValue: s2, // 状態を表示する.
                              onChanged: (value) {
                                Value2.state = value!; // 状態を操作する.
                              },
                            ),
                            Text('2000m',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
                            Radio(
                                value: 5,
                                groupValue: s2,
                                onChanged: (value) {
                                  Value2.state = value!;
                                }),
                            Text('3000m',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                )),
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
                        (i) {
                          return Container(
                            width: 130,
                            child: OutlinedButton(
                              child: Text(
                                genre[i]['name'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.all(0),
                                backgroundColor: genreButtonStates[i]
                                    ? Color(
                                        Setting_Color.setting_blue_background)
                                    : Colors.white,
                                foregroundColor: Colors.blue,
                                side: BorderSide(color: Colors.black),
                              ),
                              onPressed: () {
                                // 押したボタン以外元に戻す
                                genreButtonStates =
                                    List.filled(genre_length, false);
                                //
                                genreButtonStates[i] = !genreButtonStates[i];
                                Value6.state = genre[i]['code'];
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // リセットボタンとokボタン
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30, top: 15),
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
                                'リセット',
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
                              onPressed: () async {
                                // ボタンリセット
                                budgetState = List.filled(14, false);
                                // ボタンリセット
                                genreButtonStates = List.filled(18, false);
                                final notifier2 =
                                    ref.read(s2NotifierProvider.notifier);
                                await notifier2.updateState(3);
                                final notifier4 =
                                    ref.read(s4NotifierProvider.notifier);
                                await notifier4.updateState('');
                                final notifier6 =
                                    ref.read(s6NotifierProvider.notifier);
                                await notifier6.updateState('');
                                // Navigator.pop(context);
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
                                final notifier1 =
                                    ref.read(s1NotifierProvider.notifier);
                                await notifier1.updateState(s2);
                                final notifier3 =
                                    ref.read(s3NotifierProvider.notifier);
                                await notifier3.updateState(s4);
                                final notifier5 =
                                    ref.read(s5NotifierProvider.notifier);
                                await notifier5.updateState(s6);
                                final notifier7 =
                                    ref.read(s7NotifierProvider.notifier);
                                await notifier7.updateState(s8);

                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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

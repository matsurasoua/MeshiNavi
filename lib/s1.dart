import 'package:riverpod_annotation/riverpod_annotation.dart';
part 's1.g.dart';

// 範囲の状態管理
@riverpod
class S1Notifier extends _$S1Notifier {
  @override
  int build() {
    // rangeの数値デフォルトは1
    return 3;
  }

  // データを変更する関数
  updateState(value) {
    state = value;
  }
}

// ラジオボタンの状態管理
@riverpod
class S2Notifier extends _$S2Notifier {
  @override
  int build() {
    // ラジオボタンの初期値(1:300m)
    return 3;
  }

  // データを変更する関数
  updateState(value) {
    state = value;
  }
}

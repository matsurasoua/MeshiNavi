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

// 範囲の値保持
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

// 値段の状態管理
@riverpod
class S3Notifier extends _$S3Notifier {
  @override
  String build() {
    // 初期値
    return '';
  }

  // データを変更する関数
  updateState(value) {
    state = value;
  }
}

// 値段のデータ保持
@riverpod
class S4Notifier extends _$S4Notifier {
  @override
  String build() {
    // 初期値
    return '';
  }

  // データを変更する関数
  updateState(value) {
    state = value;
  }
}

// ジャンルの状態管理
@riverpod
class S5Notifier extends _$S5Notifier {
  @override
  String build() {
    // 初期値
    return '';
  }

  // データを変更する関数
  updateState(value) {
    state = value;
  }
}

// ジャンルのデータ保持
@riverpod
class S6Notifier extends _$S6Notifier {
  @override
  String build() {
    // 初期値
    return '';
  }

  // データを変更する関数
  updateState(value) {
    state = value;
  }
}

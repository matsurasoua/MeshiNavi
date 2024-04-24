//位置情報取得

import 'package:geolocator/geolocator.dart';

Future<Position> position() async {
  bool serviceEnabled;
  LocationPermission permission;
  // 位置情報サービスが有効かどうかをテスト
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // 位置情報サービスを有効にするよう促す
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // ユーザーに位置情報を許可してもらうよう促す
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // 拒否された場合
      return Future.error('Location permissions are denied');
    }
  }

  // 永久に拒否されている場合のエラー
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  // デバイスの位置情報を返す。
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

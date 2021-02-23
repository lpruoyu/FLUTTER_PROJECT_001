import 'package:dio/dio.dart';

class NetworkRequest {
  static Dio dio;

  static Future<String> getDataFuture(String url) async {
    if (dio == null) {
      dio = Dio();
    }
    var res = await dio.get<String>(url);
    return res.data;
  }
}

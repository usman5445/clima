import 'package:http/http.dart';
import 'dart:convert';

class NetworkController {
  final String url;

  NetworkController({required this.url});

  Future getWeather() async {
    Response resp = await get(Uri.parse(url));
    if (resp.statusCode == 200) {
      return jsonDecode(resp.body);
    } else {
      print(resp.body);
      return null;
    }
  }
}

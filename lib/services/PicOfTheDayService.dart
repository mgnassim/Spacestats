import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:spacestats/model/PicOfTheDay.dart';

class PicOfTheDayService {
  Future<PicOfTheDay?> getPicOfTheDay() async {
    const url = 'https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = response.body;
      return picOfTheDayFromJson(json);
    }
    return null;
  }
}

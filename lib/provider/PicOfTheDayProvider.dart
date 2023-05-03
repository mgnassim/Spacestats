import 'package:flutter/cupertino.dart';
import 'package:spacestats/model/PicOfTheDay.dart';
import 'package:spacestats/services/PicOfTheDayService.dart';

class PicOfTheDayProvider extends ChangeNotifier {
  final _service = PicOfTheDayService();
  bool isLoading = false;
  PicOfTheDay _picOfTheDay = PicOfTheDay(copyright: '', date: DateTime.now(), explanation: '', hdurl: '', mediaType: '', serviceVersion: '', title: '', url: '');
  PicOfTheDay get picOfTheDay => _picOfTheDay;

  Future<void> fetchPicOfTheDay() async {
    isLoading = true;
    notifyListeners();

    PicOfTheDay? response = await _service.getPicOfTheDay();

    response?.explanation = makeNiceParagraph(response.explanation);
    print(response?.copyright);
    _picOfTheDay = response!;

    isLoading = false;
    notifyListeners();
  }

  String makeNiceParagraph(String textToBeShown) {
    String elementToAdd = '\n';
    String elementToMeasureWith = '.';

    List<String> lines = textToBeShown.split(elementToMeasureWith);

    for (int i = 1; i < lines.length; i += 2) {
      // insert the element after every second line
      lines[i] = '${lines[i]}.$elementToAdd';
    }

    return lines.join(elementToAdd);
  }
}
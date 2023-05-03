import 'package:flutter/cupertino.dart';
import 'package:spacestats/model/WikiMediaResponse.dart';
import 'package:wikidart/wikidart.dart';
import '../services/RoverWikiDetailService.dart';

class RoverWikiDetailProvider extends ChangeNotifier {
  final _service = RoverWikiDetailService();
  bool isLoading = false;
  WikiMediaResponse _wikiResponse = WikiMediaResponse(success: false, rawResponse: {});
  WikiMediaResponse get wikiResponse => _wikiResponse;

  Future<void> fetchRoverWikiDetails(String roverName) async {
    isLoading = true;
    notifyListeners();

    WikiResponse? responseOne = await _service.getRoverWikiDetails(roverName);
    WikiMediaResponse? responseParsed = WikiMediaResponse(
      success: true,
      rawResponse: {},
      pageId: responseOne?.pageId,
      title: responseOne?.title,
      description: responseOne?.description,
      extract: makeNiceParagraph(responseOne?.extract),
      langlinks: responseOne?.langlinks,
    );

    _wikiResponse = responseParsed;
    isLoading = false;
    notifyListeners();
  }

  String makeNiceParagraph(String? textToBeShown) {
    String elementToAdd = '\n';
    String elementToMeasureWith = '.';

    textToBeShown = textToBeShown!;
    List<String> lines = textToBeShown.split(elementToMeasureWith);

    for (int i = 1; i < lines.length; i += 3) {
      // insert the element after every second line
      lines[i] = '${lines[i]}.$elementToAdd';
    }

    return lines.join(elementToAdd);
  }
}
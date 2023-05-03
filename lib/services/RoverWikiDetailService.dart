import 'package:wikidart/wikidart.dart';
import '../model/WikiMediaResponse.dart';

class RoverWikiDetailService {
  Future<WikiResponse?> getRoverWikiDetails(String roverName) async {
    var res = await Wikidart.searchQuery("$roverName (rover)");
    var pageid = res?.results?.first.pageId;

    if (pageid != null) {
      var sojourner = await Wikidart.summary(pageid);

      return sojourner;
    }
    return null;
  }
}

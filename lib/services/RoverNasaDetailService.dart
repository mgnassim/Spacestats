import 'package:http/http.dart' as http;
import 'package:spacestats/model/RoverImages.dart';
import 'package:spacestats/model/RoverManifest.dart';

class RoverNasaDetailService {

  static const base_url = 'https://mars-photos.herokuapp.com/api/v1/rovers';

  Future<RoverManifest?> getRoverManifest(String roverName) async {
    final uri = Uri.parse("$base_url/$roverName");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = response.body;
      return roverManifestFromJson(json);
    }
    return null;
  }

  Future<RoverImages?> getRoverImagesBySol(String roverName, int sol, String camera) async {
    final uri = Uri.parse("$base_url/$roverName/photos?sol=$sol&camera=$camera");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = response.body;
      return roverImagesFromJson(json);
    }
    return null;
  }

  Future<RoverImages?> getRoverImagesByEarthDate(String roverName, String date, String camera) async {
    final uri = Uri.parse("$base_url/$roverName/photos?earth_date=$date&camera=$camera");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = response.body;
      return roverImagesFromJson(json);
    }
    return null;
  }
}
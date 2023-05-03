import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:spacestats/model/RoverImages.dart';
import 'package:spacestats/model/RoverManifest.dart';
import 'package:spacestats/services/RoverNasaDetailService.dart';

class RoverNasaDetailProvider extends ChangeNotifier {
  final _service = RoverNasaDetailService();
  bool isLoading = false;
  RoverManifest _roverManifest = RoverManifest(rover: RoverOfManifest(id: 0, name: '', landingDate: DateTime.now(), launchDate: DateTime.now(), status: '', maxSol: 0, maxDate: DateTime.now(), totalPhotos: 0, cameras: List.empty(growable: true)));
  RoverManifest get roverManifest => _roverManifest;

  RoverImages _roverImages = RoverImages(photos: List.empty(growable: true));
  RoverImages get roverImages => _roverImages;

  var picOfApiCall;

  // For sojourner, it doesn't exist in the NASA API.
  bool roverExists = false;

  // For showing which current date method chosen and chips.
  int slideValue = 1;
  int chipsValue = 1;

  Future<void> fetchRoverManifest(String roverName) async {
    isLoading = true;
    notifyListeners();

    RoverManifest? response = await _service.getRoverManifest(roverName);

    if(response != null) { roverExists = true; }

    _roverManifest = response!;
    isLoading = false;
    notifyListeners();
  }

  Future<void> getRoverImagesBySol(int sol, String camera) async {
    isLoading = true;
    notifyListeners();

    RoverImages? response = await _service.getRoverImagesBySol(roverManifest.rover.name, sol, camera);

    if(response == null || response.photos.isEmpty) {
      isLoading = false;
      notifyListeners();
    }

    if(response != null && response.photos.isNotEmpty) {
      _roverImages = response;
      picOfApiCall = _roverImages.photos[Random().nextInt(_roverImages.photos.length)];
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getRoverImagesByEarthDate(String date, String camera) async {
    isLoading = true;
    notifyListeners();

    RoverImages? response = await _service.getRoverImagesByEarthDate(roverManifest.rover.name, date, camera);

    if(response == null || response.photos.isEmpty) {
      isLoading = false;
      notifyListeners();
    }

    if(response != null && response.photos.isNotEmpty) {
      _roverImages = response;
      picOfApiCall = _roverImages.photos[Random().nextInt(_roverImages.photos.length)];
      isLoading = false;
      notifyListeners();
    }
  }
}
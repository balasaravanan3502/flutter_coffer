import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Location {
  late double latitude;
  late double longitude;
  late String state;
  late String city;

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);

      latitude = position.latitude;
      longitude = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(
          latitude, longitude,
          localeIdentifier: "en");
      state = placemarks[0].administrativeArea!;
      city = placemarks[0].locality!;
    } catch (e) {
      print(e);
    }
  }
}

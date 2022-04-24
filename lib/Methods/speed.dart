import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class VehicleSpeed {
  VehicleSpeed();
  var speedInMps = ' empty';

  String speed() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((position) {
      speedInMps = position.speed.toStringAsPrecision(2); // this is your speed
      print(speedInMps);
    });
    return speedInMps;
  }
}

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../AppConstData/app_colors.dart';
import '../Screens/Api_Provider/imageupload_api.dart';
import '../firebase_services/fetchdata.dart';

class MaplocationUpdate extends GetxController implements GetxService {

  bool isLoading = false;
  StreamSubscription<Position>? positionStreamSubscription;
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();

  setIsLoading(value){
    isLoading = value;
    update();
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current position
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<Uint8List> getNetworkImage(String path, {int targetWidth = 80, int targetHeight = 80}) async {
    final completer = Completer<ImageInfo>();
    var image = AssetImage(path);
    image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((info, _) => completer.complete(info)),
    );
    final ImageInfo imageInfo = await completer.future;

    final ByteData? byteData = await imageInfo.image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    Uint8List resizedImage = await resizeImage(Uint8List.view(byteData!.buffer), targetWidth: targetWidth, targetHeight: targetHeight);
    return resizedImage;
  }

  Future<Uint8List> resizeImage(Uint8List data, {required int targetWidth, required int targetHeight}) async {
    // Decode the image
    final ui.Codec codec = await ui.instantiateImageCodec(data);
    final ui.FrameInfo frameInfo = await codec.getNextFrame();

    // Original dimensions
    final int originalWidth = frameInfo.image.width;
    final int originalHeight = frameInfo.image.height;

    // Calculate the aspect ratio
    final double aspectRatio = originalWidth / originalHeight;

    // Determine the dimensions to maintain the aspect ratio
    int resizedWidth, resizedHeight;
    if (originalWidth > originalHeight) {
      resizedWidth = targetWidth;
      resizedHeight = (targetWidth / aspectRatio).round();
    } else {
      resizedHeight = targetHeight;
      resizedWidth = (targetHeight * aspectRatio).round();
    }

    // Resize image
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Size size = Size(resizedWidth.toDouble(), resizedHeight.toDouble());
    final Rect rect = Rect.fromLTWH(0.0, 0.0, size.width, size.height);

    // Paint image
    final Paint paint = Paint()..isAntiAlias = true;
    canvas.drawImageRect(frameInfo.image, Rect.fromLTWH(0.0, 0.0, originalWidth.toDouble(), originalHeight.toDouble()), rect, paint);

    final ui.Image resizedImage = await recorder.endRecording().toImage(resizedWidth, resizedHeight);

    final ByteData? resizedByteData = await resizedImage.toByteData(format: ui.ImageByteFormat.png);
    return resizedByteData!.buffer.asUint8List();
  }
  Map<MarkerId, Marker> markers = {};
  double carDegree = 0.0;
  updateMarker(LatLng position, String id, String imageUrl) async {
    print("1111111111111111111");
    final Uint8List markIcon = await getNetworkImage(imageUrl);
    MarkerId markerId = MarkerId(id);
    Marker marker = Marker(
        markerId: markerId,
        icon: BitmapDescriptor.fromBytes(markIcon),
        position: position,
        rotation: carDegree,
        anchor: const Offset(0.5, 0.5)
    );

    markers[markerId] = marker;
  }


  Future startLiveTracking({required String pickLat, required String pickLong, required String dropLat, required String dropLong, required String vehicleLat, required String vehicleLng, required bool isPickup}) async {
      update();
      print("LATLONG ${double.parse(vehicleLat)} ${double.parse(vehicleLng)}");
      print("position.longitude ${double.parse(vehicleLat)}");
      print("position.longitude ${double.parse(vehicleLng)}");

      updateMarker(LatLng(double.parse(vehicleLat), double.parse(vehicleLng)), "origin", "assets/icons/trucktop.png");

      if (isPickup) {
        getDirections(latPick: double.parse(vehicleLat), longPick: double.parse(vehicleLng), latDrop: double.parse(pickLat), longDrop: double.parse(pickLong),);
      } else {
        getDirections(latPick: double.parse(vehicleLat), longPick: double.parse(vehicleLng), latDrop: double.parse(dropLat), longDrop: double.parse(dropLong),);
      }
      addMarkerpickup("Pickup", double.parse(pickLat), double.parse(pickLong));
      addMarkerdrop("Drop", double.parse(dropLat), double.parse(dropLong));
      carDegree = calculateDegrees(LatLng(double.parse(vehicleLat), double.parse(vehicleLng)), LatLng(double.parse(vehicleLat), double.parse(vehicleLng)));
      // sendLiveLocation(position.latitude, position.longitude);
  }

  // void goForPickUp({required String latPick, required String longPick}){
  //   setIsLoading(true);
  //   startLiveTracking(dropLat: latPick, dropLong: longPick, vehicleLat: , vehicleLng: '').then((value) {
  //     print("VALUE :- ${value}");
  //       update();
  //       Future.delayed(Duration(seconds: 5)).then((value) {
  //         addMarkerpickup("Pickup", double.parse(latPick), double.parse(longPick));
  //         getDirections(latPick: movingLat, longPick: movingLong, latDrop: double.parse(latPick), longDrop: double.parse(longPick));
  //
  //       },);
  //   },);
  //
  // }

  // void startDropping({required String latPick, required String longPick, required String latDrop, required String longDrop}){
  //   setIsLoading(true);
  //   if (positionStreamSubscription == null) {
  //     startLiveTracking(dropLat: latDrop, dropLong: longDrop).then((value) {
  //       addMarkerpickup("Pickup", double.parse(latPick), double.parse(longPick));
  //       Future.delayed(Duration(seconds: 5)).then((value) {
  //         addMarkerdrop("Drop", double.parse(latDrop), double.parse(longDrop));
  //         getDirections(latPick: movingLat, longPick: movingLong, latDrop: double.parse(latDrop), longDrop: double.parse(longDrop)).then((value) {
  //           setIsLoading(false);
  //         },);
  //       },);
  //     },);
  //   } else {
  //     Future.delayed(Duration(seconds: 5)).then((value) {
  //       addMarkerdrop("Drop", double.parse(latDrop), double.parse(longDrop));
  //       getDirections(latPick: movingLat, longPick: movingLong, latDrop: double.parse(latDrop), longDrop: double.parse(longDrop)).then((value) {
  //         setIsLoading(false);
  //       },);
  //     },);
  //   }
  // }

  void stopLiveTracking() {
    if (positionStreamSubscription != null) {
      positionStreamSubscription!.cancel();
      positionStreamSubscription = null;
    }
  }

  addMarkerpickup(String id, pickuplat, pickupLong) async {

    final Uint8List markIcon = await getNetworkImage("assets/icons/pickup.png");
    MarkerId markerId = MarkerId(id);

    LatLng position = LatLng(pickuplat, pickupLong);

    Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.fromBytes(markIcon),
      position: position,
      onTap: () {
        // Add any desired behavior for when the marker is tapped
      },
    );
    markers[markerId] = marker;
  }

  addMarkerdrop(String id, pickuplat, pickupLong) async {

    final Uint8List markIcon = await getNetworkImage("assets/icons/drop.png");
    MarkerId markerId = MarkerId(id);

    LatLng position = LatLng(pickuplat, pickupLong);

    Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.fromBytes(markIcon),
      position: position,
    );
    markers[markerId] = marker;
  }

  Future getDirections({required double latPick, required double longPick, required double latDrop, required double longDrop}) async {
    List<LatLng> polylineCoordinates = [];
    print("LAT $latPick - $longPick / $latDrop - $longDrop");
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleApiKey,
      request: PolylineRequest(
        origin: PointLatLng(latPick, longPick),
        destination: PointLatLng(latDrop, longDrop),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    }

    addPolyLine11(polylineCoordinates);
    setIsLoading(false);
  }

  addPolyLine11(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: priMaryColor,
      points: polylineCoordinates,
      width: 4,
    );
    polylines[id] = polyline;
  }
  static double calculateDegrees(LatLng startPoint, LatLng endPoint) {
    final double startLat = toRadians(startPoint.latitude);
    final double startLng = toRadians(startPoint.longitude);
    final double endLat = toRadians(endPoint.latitude);
    final double endLng = toRadians(endPoint.longitude);

    final double deltaLng = endLng - startLng;

    final double y = math.sin(deltaLng) * math.cos(endLat);
    final double x = math.cos(startLat) * math.sin(endLat) -
        math.sin(startLat) * math.cos(endLat) * math.cos(deltaLng);

    final double bearing = math.atan2(y, x);
    return (toDegrees(bearing) + 360) % 360;
  }

  static double toRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }

  static double toDegrees(double radians) {
    return radians * (180.0 / math.pi);
  }

  void zoomOutToFitPolyline({controller, pickLat, pickLng, dropLat, dropLng}) async {
    List<LatLng> polylineCoordinates = [LatLng(double.parse(pickLat), double.parse(pickLng)), LatLng(double.parse(dropLat), double.parse(dropLng))];

    if (controller == null || polylineCoordinates.isEmpty) return;

    LatLngBounds bounds = _getLatLngBounds(polylineCoordinates);

// Move camera with padding to keep polyline in view
    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100); // Increase padding for spacing
    await controller!.animateCamera(cameraUpdate);
  }

  LatLngBounds _getLatLngBounds(List<LatLng> points) {
    double minLat = points.first.latitude, maxLat = points.first.latitude;
    double minLng = points.first.longitude, maxLng = points.first.longitude;

    for (var point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }

    return LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );
  }

}
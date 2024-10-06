import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/flutter_earth_globe_controller.dart';
import 'package:flutter_earth_globe/globe_coordinates.dart';
import 'package:flutter_earth_globe/point.dart';
import 'package:flutter_earth_globe/sphere_style.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:nasa_space_app/homepage/controller/home_controller.dart';
import 'package:nasa_space_app/homepage/model/event_catagory_model.dart';
import 'package:nasa_space_app/homepage/model/event_model.dart';
import 'package:nasa_space_app/homepage/model/point_model.dart';

class EventController extends GetxController {
  bool isLoading = false;
  NasaEvenData? nasaEvenData;
  List<Point> point = [];
  NasaEventCatagoryData? eventCatagoryData;
  String filterCatagory = "";
  bool showcatError = false;
  List<EventsName> events = [];
  double initZoom = 0.5;

  late FlutterEarthGlobeController globeController;

  @override
  void onInit() async {
    super.onInit();
    globeController = FlutterEarthGlobeController(
      rotationSpeed: 0.05,
      zoom: initZoom,
      isRotating: false,
      maxZoom: 1.5,
      minZoom: 0.5,
      isBackgroundFollowingSphereRotation: true,
      background: Image.asset('assets/glob/2k_stars.jpg').image,
      surface: Image.asset('assets/glob/2k_earth-day.jpg').image,
      sphereStyle: const SphereStyle(
        showShadow: true,
      ),
      isZoomEnabled: false,
    );

    if (nasaEvenData == null) {
      await getData();
    }
  }

  Widget pointLabelBuilder(
      BuildContext context, Point point, bool isHovering, bool visible) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: isHovering
              ? Colors.blueAccent.withOpacity(0.8)
              : Colors.blueAccent.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2)
          ]),
      child: Text(point.label ?? '',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
              )),
    );
  }

  Color getCategoryColor(int categoryId) {
    switch (categoryId) {
      case 6: // Drought
        return Colors.brown;
      case 7: // Dust and Haze
        return Colors.grey;
      case 16: // Earthquakes
        return Colors.orange;
      case 9: // Floods
        return const Color.fromARGB(255, 6, 57, 98);
      case 14: // Landslides
        return Colors.green;
      case 19: // Manmade
        return Colors.red;
      case 15: // Sea and Lake Ice
        return Colors.cyan;
      case 10: // Severe Storms
        return Colors.purple;
      case 17: // Snow
        return Colors.white;
      case 18: // Temperature Extremes
        return Colors.yellow;
      case 12: // Volcanoes
        return Colors.deepOrange;
      case 13: // Water Color
        return Colors.teal;
      case 8: // Wildfires
        return Colors.redAccent;
      default: // Default color if the category doesn't match any case
        return Colors.black;
    }
  }

  Future<void> getData() async {
    isLoading = true;
    update();
    point.clear();
    events.clear();
    refresh();
    try {
      final response = await http.get(
        Uri.parse(
            "https://eonet.gsfc.nasa.gov/api/v2.1/events?limit=100&days=30&status=open"),
      );
      final catagoryResponse = await http.get(
        Uri.parse("https://eonet.gsfc.nasa.gov/api/v2.1/categories"),
      );

      if (response.statusCode == 200 && catagoryResponse.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var catajsonData = json.decode(catagoryResponse.body);

        nasaEvenData = NasaEvenData.fromJson(jsonData);
        update();
        eventCatagoryData = NasaEventCatagoryData.fromJson(catajsonData);
        update();
        if (nasaEvenData != null) {
          events = List.from(nasaEvenData!.events!);
          refresh();
        }

        if (nasaEvenData != null) {
          for (EventsName element in nasaEvenData!.events!) {
            for (Geometries latlan in element.geometries ?? []) {
              final PointModel pointModel = PointModel(
                  id: element.id ?? "",
                  label: element.title ?? "",
                  color: getCategoryColor(element.categories?.first.id ?? 0),
                  position: LatLng(
                    latlan.coordinates?.first.toDouble() ?? 0.0,
                    latlan.coordinates?.last.toDouble() ?? 0.0,
                  ),
                  source: element.sources?.first.url ?? "");

              Point globPoint = Point(
                coordinates: GlobeCoordinates(
                  pointModel.position.latitude,
                  pointModel.position.longitude,
                ),
                id: pointModel.id + Random().toString(),
                label: pointModel.label,
                style: PointStyle(
                  color: pointModel.color,
                  size: 3.r,
                ),

                onTap: () {
                  sourceViewer(url: pointModel.source);
                },
              );
              point.add(globPoint);
            }
            refresh();
          }
        }

        final HomeController homeController = Get.find();

        if (homeController.currentPosition != null) {
          point.add(
            Point(
              id: "MyHome",
              label: "You",
              isLabelVisible: true,
              style: const PointStyle(
                color: Colors.pinkAccent,
              ),
              coordinates: GlobeCoordinates(
                homeController.currentPosition!.latitude,
                homeController.currentPosition!.longitude,
              ),
            ),
          );
          refresh();
        }

        for (Point element in point) {
          globeController.addPoint(element);
        }
      } else {
        if (kDebugMode) {
          print('Failed to load data: ${response.statusCode}');
        }
      }
    } finally {
      isLoading = false;
      refresh();
      update();
    }
  }

  DateTime parseEventDate(String dateString) {
    return DateTime.parse(dateString);
  }

  List<Map<String, dynamic>> filterFutureEvents(
      List<Map<String, dynamic>> events) {
    DateTime now = DateTime.now().toUtc();

    List<Map<String, dynamic>> futureEvents = events.where((event) {
      for (var geometry in event['geometries']) {
        DateTime eventDate = parseEventDate(geometry['date']);
        if (eventDate.isAfter(now) || eventDate.isAtSameMomentAs(now)) {
          return true;
        }
      }
      return false;
    }).toList();

    return futureEvents;
  }

  void filterEventsByCategory(String categoryTitle) {
    for (var element in point) {
      globeController.removePoint(element.id);
    }

    events.clear();
    update();
    refresh();
    if (events.isEmpty) {
      if (nasaEvenData != null) {
        events = List.from(nasaEvenData!.events!);
        refresh();
      }
    }

    List<EventsName> filteredEvents = List.from(events.where((event) {
      for (Categories element in event.categories ?? []) {
        if (element.title == categoryTitle) {
          return true;
        }
      }
      return false;
    }).toList());

    events.clear();
    point.clear();
    refresh();

    events.addAll(filteredEvents);

    refresh();

    for (EventsName element in events) {
      for (Geometries latlan in element.geometries ?? []) {
        final PointModel pointModel = PointModel(
            id: element.id ?? "",
            label: element.title ?? "",
            color: getCategoryColor(element.categories?.first.id ?? 0),
            position: LatLng(
              latlan.coordinates?.first.toDouble() ?? 0.0,
              latlan.coordinates?.last.toDouble() ?? 0.0,
            ),
            source: element.sources?.first.url ?? "");

        Point globPoint = Point(
          coordinates: GlobeCoordinates(
            pointModel.position.latitude,
            pointModel.position.longitude,
          ),
          id: pointModel.id + Random().toString(),
          label: pointModel.label,
          style: PointStyle(
            color: pointModel.color,
            size: 3.r,
          ),
          onTap: () {
            sourceViewer(url: pointModel.source);
          },
        );
        point.add(globPoint);
      }
      refresh();
    }
    refresh();

    final HomeController homeController = Get.find();

    if (homeController.currentPosition != null) {
      point.add(
        Point(
          id: "MyHome",
          label: "You",
          isLabelVisible: true,
          style: const PointStyle(
            color: Colors.pinkAccent,
          ),
          coordinates: GlobeCoordinates(
            homeController.currentPosition!.latitude,
            homeController.currentPosition!.longitude,
          ),
        ),
      );
      refresh();
    }
    update();
    for (Point element in point) {
      globeController.addPoint(element);
    }
  }

  void resetCatagory() {
    events.clear();
    if (nasaEvenData != null) {
      events = List.from(nasaEvenData!.events!);
      refresh();
    }
    for (EventsName element in events) {
      for (Geometries latlan in element.geometries ?? []) {
        final PointModel pointModel = PointModel(
          source: element.sources?.first.url ?? "",
          id: element.id ?? "",
          label: element.title ?? "",
          color: getCategoryColor(element.categories?.first.id ?? 0),
          position: LatLng(
            latlan.coordinates?.first.toDouble() ?? 0.0,
            latlan.coordinates?.last.toDouble() ?? 0.0,
          ),
        );

        Point globPoint = Point(
          coordinates: GlobeCoordinates(
            pointModel.position.latitude,
            pointModel.position.longitude,
          ),
          id: pointModel.id + Random().toString(),
          label: pointModel.label,
          style: PointStyle(
            color: pointModel.color,
            size: 3.r,
          ),
          onTap: () {
            sourceViewer(url: pointModel.source);
          },
        );
        point.add(globPoint);
      }
      refresh();
    }
    for (Point element in point) {
      globeController.addPoint(element);
    }
    filterCatagory = "";
    final HomeController homeController = Get.find();

    if (homeController.currentPosition != null) {
      point.add(
        Point(
          id: "MyHome",
          label: "You",
          isLabelVisible: true,
          style: const PointStyle(
            color: Colors.pinkAccent,
          ),
          coordinates: GlobeCoordinates(
            homeController.currentPosition!.latitude,
            homeController.currentPosition!.longitude,
          ),
        ),
      );
      refresh();
    }
    update();
  }

  void sourceViewer({required String url}) {
    // Get.to(() => SourceView(url: url));
  }
}

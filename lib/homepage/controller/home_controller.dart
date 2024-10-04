import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:nasa_space_app/core/theme/keys.dart';
import 'package:nasa_space_app/homepage/controller/report_controller.dart';
import 'package:nasa_space_app/homepage/controller/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  static DatabaseReference ref =
      FirebaseDatabase.instance.ref().child("sensor_data");
  Stream<DatabaseEvent> stream = ref.onValue;

  final gemini = Gemini.instance;
  String generatedText = '';
  bool isloading = false;
  Position? currentPosition;

  num humidity = 0;
  num nitro = 0;
  num phosphorus = 0;
  num potaisum = 0;
  num temp = 0;
  num moisture = 0;
  int tabIndex = 0;
  int totalSensor = 0;
  void changeTabIndex(int value) {
    tabIndex = value;
    update();
  }

  num previousHumidity = 0;
  num previousNitro = 0;
  num previousPhosphorus = 0;
  num previousPotasium = 0;
  num previousTemp = 0;
  num previousMoisture = 0;

  DateTime lastApiCallTime =
      DateTime.now().subtract(const Duration(seconds: 30));

  @override
  void onInit() async {
    super.onInit();
    await getWeatherData();
    stream.listen((DatabaseEvent event) {
      var snapshotValue = event.snapshot.value as Map<dynamic, dynamic>;

      humidity = snapshotValue["humidity"];
      nitro = snapshotValue["nitrogen"];
      phosphorus = snapshotValue["phosphorus"];
      potaisum = snapshotValue["potassium"];
      temp = snapshotValue["temperature"];
      moisture = snapshotValue["moisture"];

      if (shouldCallApi()) {
        fetchGeneratedText(snapshotValue);
        lastApiCallTime = DateTime.now();
      }
      updatePreviousValues();
      update();
    });
    totalSensor = await getSensorDataLength();
  }

  bool shouldCallApi() {
    final now = DateTime.now();
    const apiCallInterval = Duration(seconds: 30);
    final timeSinceLastCall = now.difference(lastApiCallTime);

    // Check if the change in data is "huge" or noticeable
    bool significantChange = (humidity - previousHumidity).abs() > 5 ||
        (nitro - previousNitro).abs() > 50 ||
        (phosphorus - previousPhosphorus).abs() > 100 ||
        (potaisum - previousPotasium).abs() > 100 ||
        (temp - previousTemp).abs() > 2 ||
        (moisture - previousMoisture).abs() > 0.4;

    // API should be called if either 30 seconds have passed or the data change is significant
    return timeSinceLastCall >= apiCallInterval || significantChange;
  }

  void updatePreviousValues() {
    previousHumidity = humidity;
    previousNitro = nitro;
    previousPhosphorus = phosphorus;
    previousPotasium = potaisum;
    previousTemp = temp;
    previousMoisture = moisture;
  }

  Future<void> fetchGeneratedText(Map<dynamic, dynamic> data) async {
    isloading = true;
    update();
    final ReportController reportController = Get.find();
    try {
      if (reportController.floodModel != null &&
          reportController.apiSensorDataModel != null) {
        final value = await gemini.text(
          "Give meaning full about  farming  suggestion so that farmer can get helped. This is the sensor data: $data. This is the weather forcast for today is :${weatherModel.toString()}   Also your help, I'm giving 2 data from open-meteo.com on my area:  Daily river discharge data : ${reportController.floodModel.toString()} and Hourly Soil Temp and Moisture Data: ${reportController.apiSensorDataModel.toString()} . Today Date is : ${DateTime.now()}. Make it short in 3 line and in bangla language. Bangladeshi bangla. And also predict the current conditon on the field. Dont take new line without any cause. Make it like human. Temp is in Celcius. Also warn if something dangerous is gonna Happen",
        );

        generatedText = value?.output ?? 'No content available';
      } else {
        final value = await gemini.text(
          "Give meaning full about  farming suggestion so that farmer can get helped. This is the sensor data: $data. This is the weather forcast for today is :${weatherModel.toString()}  Make it short in 3 line and in bangla language. Bangladeshi bangla. And also predict the current conditon on the field. Dont take new line without any cause. Make it like human. Temp is in Celcius.",
        );
        generatedText = value?.output ?? 'No content available';
      }
    } catch (e) {
      generatedText = 'Error fetching text';
    }
    isloading = false;
    update();
  }

  final String defaultBangladeshUrl =
      "https://api.openweathermap.org/data/2.5/weather?q=Bangladesh&appid=${KeysForApi.openWeatherKey}&units=metric";

  WeatherData? weatherModel;

  Future<void> getWeatherData() async {
    Position? position;

    // Request location permission
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // User denied location permission, default to Bangladesh
      await fetchWeatherData(defaultBangladeshUrl);
    } else if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied, show default value
      await fetchWeatherData(defaultBangladeshUrl);
    } else {
      // Permission granted, get the current position
      position = await Geolocator.getCurrentPosition();
      currentPosition = position;
      final ReportController controller = Get.find();
      await controller.fetchFloodData(position.latitude, position.longitude);
      await controller.fetchSensorData(position.latitude, position.longitude);
      final String url =
          "https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=${KeysForApi.openWeatherKey}&units=metric";
      update();
      // Fetch weather data using the user's location
      await fetchWeatherData(url);
    }
  }

  Future<void> fetchWeatherData(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Parse the JSON data
      final data = json.decode(response.body);

      weatherModel = WeatherData.fromJson(
        data,
      );
      update();
    } else {
      // Handle error
      log('Error fetching weather data: ${response.statusCode}');
    }
    // try {

    // } catch (e) {
    //   print('Error: $e');
    // }
  }

  Future<int> getSensorDataLength() async {
    try {
      // Fetch the snapshot of the data at 'sensordata'
      DataSnapshot snapshot = await ref.get();

      // Check if the snapshot exists and has children
      if (snapshot.exists) {
        // Get the map of data
        Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
        return data.length; // Return the length of the data
      } else {
        return 0; // No data available
      }
    } catch (e) {
      print('Error fetching sensor data length: $e');
      return 0; // Return 0 in case of an error
    }
  }
}

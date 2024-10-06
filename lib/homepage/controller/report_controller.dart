import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nasa_space_app/homepage/model/api_sensor_model.dart';
import 'package:nasa_space_app/homepage/model/flood_model.dart';

class ReportController extends GetxController {
  FloodModel? floodModel;
  ApiSensorDataModel? apiSensorDataModel;
  bool isLoading = false;
  Future<void> fetchFloodData(double latitude, double longitude) async {
    isLoading = true;
    update();
    final String url =
        'https://flood-api.open-meteo.com/v1/flood?latitude=$latitude&longitude=$longitude&daily=river_discharge';

    try {
      final response = await http.get(Uri.parse(url));

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        floodModel = FloodModel.fromJson(data);
      }
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchSensorData(double latitude, double longitude) async {
    final String apiUrl =
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&hourly=soil_temperature_54cm,soil_moisture_27_to_81cm';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        apiSensorDataModel = ApiSensorDataModel.fromJson(data);
      } else {
        if (kDebugMode) {
          print('Failed to load sensor data: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    } finally {
      update();
    }
  }
}

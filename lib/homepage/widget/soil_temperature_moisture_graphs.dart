import 'dart:convert';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nasa_space_app/core/theme/colors.dart';
import 'package:nasa_space_app/homepage/controller/home_controller.dart';
import 'package:nasa_space_app/homepage/model/api_sensor_model.dart';

class SoilTemperatureMoistureGraphs extends StatefulWidget {
  const SoilTemperatureMoistureGraphs({super.key});

  @override
  State<SoilTemperatureMoistureGraphs> createState() =>
      _SoilTemperatureMoistureGraphsState();
}

class _SoilTemperatureMoistureGraphsState
    extends State<SoilTemperatureMoistureGraphs> {
  List<Color> temperatureGradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  List<Color> moistureGradientColors = [
    Colors.green,
    Colors.blue,
  ];

  List<FlSpot> temperatureSpots = [];
  List<FlSpot> moistureSpots = [];

  @override
  void initState() {
    super.initState();
    fetchSoilData();
  }

  Future<void> fetchSoilData() async {
    final HomeController homeController = Get.find();
    Position position = homeController.currentPosition!;
    try {
      // Fetch soil temperature and moisture data from API
      final response = await http.get(Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=${position.latitude}&longitude=${position.longitude}&hourly=soil_temperature_54cm,soil_moisture_27_to_81cm'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ApiSensorDataModel sensorData = ApiSensorDataModel.fromJson(data);

        // Get the current date
        DateTime today = DateTime.now();
        List<FlSpot> fetchedTemperatureSpots = [];
        List<FlSpot> fetchedMoistureSpots = [];

        for (int i = 0; i < sensorData.hourly!.time!.length; i++) {
          DateTime date = DateTime.parse(sensorData.hourly!.time![i]);

          // Filter for the current day
          if (date.day == today.day &&
              date.month == today.month &&
              date.year == today.year) {
            fetchedTemperatureSpots.add(FlSpot(
              date.hour.toDouble(),
              sensorData.hourly!.soilTemperature54cm![i],
            ));
            fetchedMoistureSpots.add(FlSpot(
              date.hour.toDouble(),
              sensorData.hourly!.soilMoisture27To81cm![i],
            ));
          }
        }

        // Update the state with the filtered data
        setState(() {
          temperatureSpots = fetchedTemperatureSpots;
          moistureSpots = fetchedMoistureSpots;
        });
      } else {
        throw Exception('Failed to load soil data');
      }
    } catch (e) {
      print('Error fetching soil data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "${DateFormat('EEEE').format(DateTime.now())} Soil Temperature",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        // Soil Temperature Graph
        Expanded(
          child: SizedBox(
            width: context.width,
            child: AspectRatio(
              aspectRatio: 1.50,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 18,
                  left: 12,
                  top: 24,
                  bottom: 12,
                ),
                child: LineChart(
                  temperatureData(),
                ),
              ),
            ),
          ),
        ),
        Text(
          "${DateFormat('EEEE').format(DateTime.now())} Soil Moisture",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        // Soil Moisture Graph
        Expanded(
          child: SizedBox(
            width: context.width,
            child: AspectRatio(
              aspectRatio: 1.50,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 18,
                  left: 12,
                  top: 24,
                  bottom: 12,
                ),
                child: LineChart(
                  moistureData(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final hour = value.toInt();
    return SideTitleWidget(
      axisSide: meta.axisSide,
      angle: -math.pi / 2,
      space: 20,
      child: Text(
        '$hour:00',
        style: TextStyle(
          fontSize: 8.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  LineChartData temperatureData() {
    return LineChartData(
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          drawBelowEverything: true,
          axisNameWidget: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Hour"),
            ],
          ),
          axisNameSize: 40.w,
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 50,
            maxIncluded: true,
            interval: 1,
            getTitlesWidget: (double value, TitleMeta meta) =>
                bottomTitleWidgets(value, meta),
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: const Text("Soil Temperature (°C)"),
          axisNameSize: 40.w,
          sideTitles: SideTitles(
            showTitles: false,
            interval: 1,
            reservedSize: 100.w,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      maxX: 23, // 24 hours in a day
      minY: 0,
      maxY: temperatureSpots.isNotEmpty
          ? temperatureSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1
          : 10,
      gridData: const FlGridData(
        show: true,
      ),
      lineBarsData: [
        LineChartBarData(
          spots: temperatureSpots,
          isCurved: true,
          gradient: LinearGradient(
            colors: temperatureGradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (p0, p1, p2, p3) {
              return FlDotCirclePainter(
                color: const Color.fromARGB(255, 154, 5, 72),
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: temperatureGradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          // tooltipBgColor: Colors.blueAccent, // Background color of the tooltip
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((LineBarSpot spot) {
              final date = DateTime(
                  DateTime.now().year, DateTime.now().month, spot.x.toInt());
              final formattedDate =
                  DateFormat('dd MMM').format(date); // Format date

              // Assuming you have separate lists for soil moisture and temperature
              String tooltipText = '';
              // For soil temperature
              double temperatureValue =
                  spot.y; // Assuming this is temperature data
              tooltipText =
                  '$formattedDate\nTemperature: ${temperatureValue.toStringAsFixed(1)} °C';

              return LineTooltipItem(
                tooltipText,
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  LineChartData moistureData() {
    return LineChartData(
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          drawBelowEverything: true,
          axisNameWidget: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Hour"),
            ],
          ),
          axisNameSize: 40.w,
          sideTitles: SideTitles(
            showTitles: false,
            reservedSize: 50,
            maxIncluded: true,
            interval: 1,
            getTitlesWidget: (double value, TitleMeta meta) =>
                bottomTitleWidgets(value, meta),
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: const Text("Soil Moisture (%)"),
          axisNameSize: 40.w,
          sideTitles: SideTitles(
            showTitles: false,
            interval: 1,
            reservedSize: 100.w,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      maxX: 23, // 24 hours in a day
      minY: 0,
      maxY: moistureSpots.isNotEmpty
          ? moistureSpots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1
          : 100, // Assuming soil moisture is measured in percentage
      gridData: const FlGridData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: moistureSpots,
          isCurved: true,
          gradient: LinearGradient(
            colors: moistureGradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (p0, p1, p2, p3) {
              return FlDotCirclePainter(
                color: Colors.blue,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: moistureGradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          // tooltipBgColor: Colors.blueAccent, // Background color of the tooltip
          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
            return touchedBarSpots.map((LineBarSpot spot) {
              final date = DateTime(
                  DateTime.now().year, DateTime.now().month, spot.x.toInt());
              final formattedDate =
                  DateFormat('dd MMM').format(date); // Format date

              // Assuming you have separate lists for soil moisture and temperature
              String tooltipText = '';
              if (spot.barIndex == 0) {
                // For soil moisture
                double moistureValue = spot.y; // Assuming this is moisture data
                tooltipText =
                    '$formattedDate\nMoisture: ${(moistureValue * 100).toStringAsFixed(1)}%';
              } else if (spot.barIndex == 1) {
                // For soil temperature
                double temperatureValue =
                    spot.y; // Assuming this is temperature data
                tooltipText =
                    '$formattedDate\nTemperature: ${temperatureValue.toStringAsFixed(1)} °C';
              }

              return LineTooltipItem(
                tooltipText,
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }
}

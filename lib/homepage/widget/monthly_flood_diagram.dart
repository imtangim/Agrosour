import 'dart:convert';
import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nasa_space_app/core/theme/colors.dart';
import 'package:nasa_space_app/homepage/controller/home_controller.dart';
import 'package:nasa_space_app/homepage/model/flood_model.dart';

class MonthlyFloodDiagram extends StatefulWidget {
  const MonthlyFloodDiagram({super.key});

  @override
  State<MonthlyFloodDiagram> createState() => _MonthlyFloodDiagramState();
}

class _MonthlyFloodDiagramState extends State<MonthlyFloodDiagram> {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  bool showAvg = false;
  List<FlSpot> spots = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchFloodData();
    });
  }

  Future<void> fetchFloodData() async {
    final HomeController homeController = Get.find();
    Position position = homeController.currentPosition!;
    try {
      // Fetch data from API
      final response = await http.get(Uri.parse(
          'https://flood-api.open-meteo.com/v1/flood?latitude=${position.latitude}&longitude=${position.longitude}&daily=river_discharge'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        FloodModel floodData = FloodModel.fromJson(data);

        // Get the current month and year
        int currentMonth = DateTime.now().month;
        int currentYear = DateTime.now().year;

        List<FlSpot> fetchedSpots = [];
        for (int i = 0; i < floodData.daily!.time!.length; i++) {
          DateTime date = DateTime.parse(floodData.daily!.time![i]);

          // Filter for the current month and year
          if (date.month == currentMonth && date.year == currentYear) {
            fetchedSpots.add(FlSpot(
              date.day.toDouble(),
              floodData.daily!.riverDischarge![i],
            ));
          }
        }

        // Update state with filtered spots
        setState(() {
          spots = fetchedSpots;
        });
      } else {
        throw Exception('Failed to load flood data');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
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
                mainData(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final date =
        DateTime(DateTime.now().year, DateTime.now().month, value.toInt());
    final formattedDate = DateFormat('dd MMM').format(date); // Format the date

    return SideTitleWidget(
      // fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
      axisSide: AxisSide.bottom,
      angle: -math.pi / 2,
      space: 20,
      child: Text(
        formattedDate,
        style: TextStyle(
          fontSize: 8.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  LineChartData mainData() {
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
              Text("Date"),
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
          axisNameWidget: const Text("River Discharge(m³/s)"),
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
      maxX: 31,
      minY: 0,
      maxY: spots.isNotEmpty
          ? spots.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1
          : 6,
      gridData: const FlGridData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (p0, p1, p2, p3) {
              return FlDotCirclePainter(
                color: Colors.red,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          fitInsideVertically: true, fitInsideHorizontally: true,

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
                  '$formattedDate\n Discharge: ${temperatureValue.toStringAsFixed(1)} m³/s';

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

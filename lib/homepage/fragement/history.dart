import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nasa_space_app/homepage/controller/home_controller.dart';
import 'package:nasa_space_app/homepage/widget/monthly_flood_diagram.dart';
import 'package:nasa_space_app/homepage/widget/soil_temperature_moisture_graphs.dart';

class HistoryFragment extends StatelessWidget {
  const HistoryFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<HomeController>(builder: (controller) {
          if (controller.currentPosition == null) {
            return SizedBox(
              height: 300.h,
              width: context.width,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${DateFormat.MMMM().format(DateTime.now())} River Discharge",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const MonthlyFloodDiagram(),
                ],
              ),
              10.verticalSpace,
              SizedBox(
                  height: 400.h, child: const SoilTemperatureMoistureGraphs()),
            ],
          );
        }),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nasa_space_app/homepage/controller/home_controller.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SensorFragments extends StatefulWidget {
  const SensorFragments({super.key});

  @override
  State<SensorFragments> createState() => _SensorFragmentsState();
}

class _SensorFragmentsState extends State<SensorFragments> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (homeController) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: const Color(0xffe59a54),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Realtime Sensor Data",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  10.verticalSpace,
                  SizedBox(
                    width: context.width,
                    child: Wrap(
                      alignment: WrapAlignment.spaceEvenly,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.spaceEvenly,
                      runSpacing: 20.h,
                      children: [
                        SensorDataCard(
                          title: "Nitrogen",
                          percent: (homeController.nitro) / 255,
                          text: homeController.nitro.toString(),
                        ),
                        SensorDataCard(
                          title: "Phosphorus",
                          percent: (homeController.phosphorus) / 255,
                          text: homeController.phosphorus.toString(),
                        ),
                        SensorDataCard(
                          title: "Potassium",
                          percent: (homeController.potaisum) / 255,
                          text: homeController.potaisum.toString(),
                        ),
                        SensorDataCard(
                          title: "Humidity",
                          percent: (homeController.humidity.toDouble()),
                          text: (homeController.humidity * 100).toString(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            Container(
              width: context.width,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: const Color(0xfff4f5ef),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                children: [
                  Text(
                    "Water Level Checker",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16.sp,
                    ),
                  ),
                  10.verticalSpace,
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Moisture Level",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ).paddingSymmetric(horizontal: 15.w),
                  ),
                  5.verticalSpace,
                  LinearPercentIndicator(
                    barRadius: Radius.circular(999.r),
                    percent: 0.5,
                    progressColor: const Color(0xffe59a54),
                    trailing: Text(
                      "${homeController.moisture * 100}%",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            Row(
              children: [
                Text(
                  "Suggestion",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20.sp,
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            GetBuilder<HomeController>(
              builder: (controller) {
                if (controller.isloading) {
                  return LoadingAnimationWidget.fourRotatingDots(
                    color: Colors.blueAccent,
                    size: 50.h,
                  );
                }
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.generatedText.replaceAll("*", ""),
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(
              height: 20.h,
            )
          ],
        ).paddingSymmetric(horizontal: 20.w),
      );
    });
  }
}

class SensorDataCard extends StatelessWidget {
  final String title;
  final double percent;
  final String text;
  const SensorDataCard({
    super.key,
    required this.title,
    required this.percent,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120.w,
      height: 120.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xfff4f5ef),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularPercentIndicator(
            animation: true,
            percent: percent,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: const Color.fromARGB(255, 53, 53, 49),
            backgroundColor: const Color(0xffe59a54),
            radius: 30.r,
            center: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xff514f4f),
              ),
            ),
          ),
          5.verticalSpace,
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: const Color(0xff514f4f),
            ),
          )
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_earth_globe/flutter_earth_globe.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:nasa_space_app/homepage/controller/event_controller.dart';
import 'package:nasa_space_app/homepage/model/event_catagory_model.dart';
import 'package:nasa_space_app/homepage/model/event_model.dart';
import 'package:url_launcher/url_launcher.dart';

class EventFragments extends StatefulWidget {
  const EventFragments({super.key});

  @override
  State<EventFragments> createState() => _EventFragmentsState();
}

class _EventFragmentsState extends State<EventFragments> {
  final EventController eventController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  void fetchData() async {
    await eventController.getData();
  }

  @override
  Widget build(BuildContext context) {
    double radius = MediaQuery.of(context).size.width < 500
        ? ((MediaQuery.of(context).size.width / 3.8) - 20)
        : 120;
    return GetBuilder<EventController>(builder: (eveController) {
      return Stack(
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onDoubleTap: () {
              if (eveController.initZoom < 1.5) {
                eveController.initZoom = eveController.initZoom + 0.5;
                // setState(() {
                eveController.globeController.setZoom(eveController.initZoom);
                // });
                setState(() {});
                log(eveController.initZoom.toString(), time: DateTime.now());
              } else {
                eveController.initZoom = 0.5;
                eveController.globeController.setZoom(eveController.initZoom);
                setState(() {});
              }
            },
            child: FlutterEarthGlobe(
              alignment: Alignment.center,
              onZoomChanged: (zoom) {},
              onTap: (coordinates) {},
              onHover: (coordinates) {},
              controller: eveController.globeController,
              radius: radius,
            ),
          ),
          if (eveController.initZoom <= 0.5)
            Builder(
              builder: (context) {
                if (eveController.isLoading) {
                  return const SizedBox();
                }
                return Container(
                  width: 180.w,
                  margin:
                      EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Wrap(
                    runSpacing: 5.w,
                    spacing: 10.w,
                    children: [
                      const PointAlertDialogMaker(
                        color: Colors.pinkAccent,
                        label: "Your Location",
                      ),
                      ...List.generate(
                        eveController.eventCatagoryData?.categories?.length ??
                            0,
                        (index) {
                          final CataCatagories data = eveController
                              .eventCatagoryData!.categories![index];
                          return PointAlertDialogMaker(
                            label: data.title ?? "",
                            color: eveController.getCategoryColor(data.id ?? 0),
                          );
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          if (eveController.initZoom <= 0.5)
            if (eventController.isLoading == false)
              Positioned(
                right: 10.h,
                top: 30.h,
                child: Row(
                  children: [
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          isDismissible: true,
                          showDragHandle: true,
                          backgroundColor: Colors.white,
                          context: context,
                          builder: (context) {
                            return GetBuilder<EventController>(
                                builder: (eveController) {
                              return SizedBox(
                                width: context.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Filter by Catagory: ${eveController.filterCatagory}",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    10.verticalSpace,
                                    Wrap(
                                      runSpacing: 10.w,
                                      spacing: 10.w,
                                      children: [
                                        ...List.generate(
                                          eveController.eventCatagoryData
                                                  ?.categories?.length ??
                                              0,
                                          (index) {
                                            return GestureDetector(
                                              onTap: () {
                                                eveController.filterCatagory =
                                                    eveController
                                                            .eventCatagoryData
                                                            ?.categories?[index]
                                                            .title ??
                                                        "";

                                                eveController.update();
                                              },
                                              child: ChipForModal(
                                                label: eveController
                                                        .eventCatagoryData
                                                        ?.categories?[index]
                                                        .title ??
                                                    "",
                                              ),
                                            );
                                          },
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    if (eveController.showcatError)
                                      const Text(
                                        "Select a Catagory",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xffe59a54),
                                        fixedSize: Size(context.width, 40.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.r),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (eveController
                                            .filterCatagory.isNotEmpty) {
                                          eveController.showcatError = false;
                                          eveController.filterEventsByCategory(
                                            eveController.filterCatagory,
                                          );
                                          eveController.update();
                                          Get.back();
                                        } else {
                                          eveController.showcatError = true;
                                          eveController.update();
                                        }
                                      },
                                      child: Text(
                                        "Search",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    20.verticalSpace,
                                  ],
                                ).paddingSymmetric(horizontal: 20.w),
                              );
                            });
                          },
                        );
                      },
                      icon: const Icon(Iconsax.filter_search),
                    ),
                    if (eventController.filterCatagory != "") ...[
                      10.horizontalSpace,
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () {
                          eventController.resetCatagory();
                        },
                        icon: const Icon(Iconsax.close_circle),
                      ),
                    ]
                  ],
                ),
              ),
          if (eveController.isLoading)
            Container(
              height: context.height,
              width: context.width,
              color: Colors.white.withOpacity(0.3),
              child: Center(
                child: Text(
                  "Looking for event...",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 17.sp,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
          if (eveController.initZoom <= 0.5)
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Event Found:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ).paddingSymmetric(horizontal: 20.w),
                  10.verticalSpace,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ...List.generate(
                          eveController.events.length,
                          (index) {
                            final EventsName data = eveController.events[index];
                            return EventCard(
                              catagory: data.categories ?? [],
                              source: data.sources?.first.url ?? "",
                              time: data.geometries?.first.date ?? "",
                              title: data.title ?? "",
                            ).marginOnly(right: 10.w);
                          },
                        )
                      ],
                    ).paddingSymmetric(horizontal: 20.w),
                  ),
                  20.verticalSpace,
                ],
              ),
            )
        ],
      );
    });
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final List<Categories> catagory;

  final String source;
  final String time;
  const EventCard({
    super.key,
    required this.title,
    required this.catagory,
    required this.source,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.w,
      height: 140.h,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          5.verticalSpace,
          Row(
            children: [
              ...List.generate(
                catagory.length,
                (index) {
                  final Categories data = catagory[index];
                  return CatLabelBuilder(
                    name: data.title ?? "",
                    color: EventController().getCategoryColor(data.id ?? 0),
                  ).marginOnly(right: 10.w);
                },
              )
            ],
          ),
          5.verticalSpace,
          Row(
            children: [
              Text(
                "Date and Time: ",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              10.horizontalSpace,
              Text(
                time,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          5.verticalSpace,
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffe59a54),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () async {
              if (await launchUrl(Uri.parse(source))) {
              } else {
                throw 'Could not launch $Uri.parse(source)';
              }
            },
            child: const Text("Learn more"),
          )
        ],
      ),
    );
  }
}

class CatLabelBuilder extends StatelessWidget {
  final String name;
  final Color color;
  const CatLabelBuilder({
    super.key,
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 10.h,
          width: 10.w,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        10.horizontalSpace,
        Text(
          name,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class ChipForModal extends StatelessWidget {
  final String label;
  const ChipForModal({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
          color: const Color(0xffe59a54),
          borderRadius: BorderRadius.circular(10.r)),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}

class PointAlertDialogMaker extends StatelessWidget {
  final String label;
  final Color color;
  const PointAlertDialogMaker({
    super.key,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 10.h,
          width: 10.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        3.horizontalSpace,
        Text(label),
      ],
    );
  }
}

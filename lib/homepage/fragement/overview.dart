
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nasa_space_app/homepage/controller/home_controller.dart';
import 'package:nasa_space_app/homepage/controller/weather_model.dart';
import 'package:nasa_space_app/homepage/fragement/camera_screen.dart';

class OverviewFragments extends StatefulWidget {
  final TabController tabController;
  const OverviewFragments({super.key, required this.tabController});

  @override
  State<OverviewFragments> createState() => _OverviewFragmentsState();
}

class _OverviewFragmentsState extends State<OverviewFragments> {
  @override
  void initState() {
    super.initState();
    // _homeController.getWeatherData();
  }

  Future<void> _showImageSourceDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          title: const Text('Choose Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Iconsax.gallery),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context); // Close the dialog
                  _openCamera(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Iconsax.camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context); // Close the dialog
                  _openCamera(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  Future<void> _openCamera(ImageSource source) async {
    try {
      _image = null;
      setState(() {});
      // Open the camera and capture a picture
      final XFile? image = await _picker.pickImage(
        source: source,
        preferredCameraDevice: CameraDevice.rear,
      );

      // If an image is captured, update the state
      if (image != null) {
        setState(() {
          _image = image;
        });
      }
      if (_image != null) {
        Get.to(
          () => CameraScreen(
            image: _image!,
          ),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeController>(builder: (controller) {
        if (controller.weatherModel == null) {
          return const Center(
            child: SizedBox(
              child: CircularProgressIndicator(),
            ),
          );
        }
        final WeatherData data = controller.weatherModel!;
        return SingleChildScrollView(
          child: Column(
            children: [
              WeatherHeader(
                humidity: data.main?.humidity.toString() ?? "",
                imageid: data.weather?.first.icon ?? "",
                rainMeter: data.rain?.d1h.toString() ?? "",
                temp: data.main?.temp.toString() ?? "",
                weatherCondition: data.weather?.first.description ?? "",
                windSpeed: data.wind?.speed.toString() ?? "",
                area: "${data.name}, ${data.sys?.country ?? ""}",
              ),
              18.verticalSpace,
              SensorPart(
                tabController: widget.tabController,
              ),
              18.verticalSpace,
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Diagnosis",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 5.w),
                  10.verticalSpace,
                  IconButton(
                    onPressed: () async {
                      await _showImageSourceDialog();
                    },
                    icon: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Iconsax.camera,
                          color: Color(0xffe59a54),
                        ),
                        10.horizontalSpace,
                        Text(
                          "Snap & Diagnose 🌿",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17.sp,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              10.verticalSpace,
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Alert",
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "View all",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ).paddingSymmetric(horizontal: 5.w),
                  10.verticalSpace,
                  const NotificationCard(),
                  10.verticalSpace,
                  const NotificationCard(),
                  20.verticalSpace,
                ],
              )
            ],
          ).paddingSymmetric(horizontal: 10.w),
        );
      }),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xffededed),
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Iconsax.warning_25,
            color: Colors.red,
            size: 30.h,
          ),
          35.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Need water",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
              ),
              3.verticalSpace,
              Text(
                "Moisture level has dropped significently",
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                      color: const Color(0xff64748B),
                    ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class SensorPart extends StatelessWidget {
  final TabController tabController;
  const SensorPart({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Sensors",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            GestureDetector(
              onTap: () {
                tabController.animateTo(1);
              },
              child: Text(
                "View all",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ).paddingSymmetric(horizontal: 5.w),
        10.verticalSpace,
        SizedBox(
          height: 90.h,
          child: Row(
            children: [
              GetBuilder<HomeController>(builder: (controller) {
                return Expanded(
                  child: SensorCard(
                    color: const Color(0xff249f77),
                    data: controller.totalSensor.toString(),
                    title: "Online",
                  ),
                );
              }),
              10.horizontalSpace,
              const Expanded(
                child: SensorCard(
                  color: Color(0xffdeecee),
                  data: "0",
                  title: "Low Battery",
                  textColor: Color(0xff3f3d3d),
                ),
              ),
              10.horizontalSpace,
              const Expanded(
                child: SensorCard(
                  color: Color(0xffe9dbd7),
                  textColor: Color(0xff3f3d3d),
                  data: "0",
                  title: "Offline",
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class SensorCard extends StatelessWidget {
  final String data;
  final String title;
  final Color color;
  final Color textColor;
  const SensorCard({
    super.key,
    required this.data,
    required this.title,
    required this.color,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 40.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          16.r,
        ),
        border: Border.all(style: BorderStyle.none),
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            data,
            style: TextStyle(
              fontSize: 25.sp,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          )
        ],
      ),
    );
  }
}

class WeatherHeader extends StatefulWidget {
  final String imageid;
  final String weatherCondition;
  final String temp;
  final String humidity;
  final String windSpeed;
  final String rainMeter;
  final String area;
  const WeatherHeader({
    super.key,
    required this.imageid,
    required this.weatherCondition,
    required this.temp,
    required this.humidity,
    required this.windSpeed,
    required this.rainMeter,
    required this.area,
  });

  @override
  State<WeatherHeader> createState() => _WeatherHeaderState();
}

class _WeatherHeaderState extends State<WeatherHeader> {
  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xffe59a54),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.area,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "Weather",
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Image.network(
                    "https://openweathermap.org/img/wn/${widget.imageid}@2x.png",
                    height: 60.h,
                    // height: 60.h,
                  ),
                  Text(
                    widget.weatherCondition.capitalizeFirst ?? "",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 30.h,
          ),
          SizedBox(
            width: context.width,
            child: Wrap(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.start,
              runAlignment: WrapAlignment.spaceBetween,
              children: [
                if (widget.temp.isNotEmpty)
                  WeatherDataCard(
                    data: "${widget.temp}°C",
                    iconData: Icons.thermostat,
                    title: "Temperature",
                  ),
                if (widget.humidity.isNotEmpty)
                  WeatherDataCard(
                    data: "${widget.humidity}%",
                    iconData: Icons.water_drop_outlined,
                    title: "Humidity",
                  ),
                if (widget.windSpeed.isNotEmpty)
                  WeatherDataCard(
                    data: "${widget.windSpeed} m/s",
                    title: "Wind",
                    iconData: Iconsax.wind4,
                  ),
                if (widget.rainMeter.isNotEmpty)
                  WeatherDataCard(
                    data: "${widget.rainMeter} mm/h",
                    iconData: Iconsax.cloud_drizzle,
                    title: "Percipation",
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class WeatherDataCard extends StatelessWidget {
  final String title;
  final IconData iconData;
  final String data;
  const WeatherDataCard({
    super.key,
    required this.title,
    required this.iconData,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          iconData,
          color: Colors.white,
          size: 30.sp,
        ),
        Text(
          data,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15.sp,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        )
      ],
    );
  }
}

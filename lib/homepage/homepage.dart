import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nasa_space_app/authentication/auth_controller.dart';
import 'package:nasa_space_app/homepage/controller/home_controller.dart';
import 'package:nasa_space_app/homepage/fragement/camera_screen.dart';
import 'package:nasa_space_app/homepage/fragement/community.dart';
import 'package:nasa_space_app/homepage/fragement/event_fragments.dart';
import 'package:nasa_space_app/homepage/fragement/history.dart';
import 'package:nasa_space_app/homepage/fragement/overview.dart';
import 'package:nasa_space_app/homepage/fragement/profile_fragment.dart';
import 'package:nasa_space_app/homepage/fragement/sensor.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final HomeController _homeController = Get.find();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 6,
      vsync: this,
      initialIndex: _homeController.tabIndex,
    );
    _tabController.addListener(
      () {
        _homeController.changeTabIndex(_tabController.index);

        setState(() {});
      },
    );
  }

  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  Future<void> _openCamera() async {
    try {
      // Open the camera and capture a picture
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
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
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (homeController) {
      return Scaffold(
        backgroundColor:
            homeController.tabIndex == 3 ? Colors.transparent : Colors.white,
        extendBodyBehindAppBar: homeController.tabIndex == 3 ? true : false,
        appBar: homeController.tabIndex == 0
            ? AppBar(
                centerTitle: false,
                title: GetBuilder<AuthController>(builder: (controller) {
                  return Text(
                    "Welcome! ${controller.usermodel?.name.split(" ").first ?? ""}",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.sp,
                        ),
                  );
                }),
              )
            : homeController.tabIndex == 4
                ? AppBar(
                    actions: [
                      IconButton(
                        onPressed: () {
                          final AuthController controller = Get.find();
                          controller.googleSignOut();
                        },
                        icon: Row(
                          children: [
                            const Icon(
                              Iconsax.logout,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "Logout",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                color: Colors.red,
                              ),
                            )
                          ],
                        ),
                      ).paddingOnly(right: 10.w)
                    ],
                  )
                : null,
        body: GetBuilder<AuthController>(
          builder: (authController) {
            return SafeArea(
              child: GetBuilder<HomeController>(builder: (homeController) {
                return Column(
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    TabBar(
                      controller: _tabController,
                      dividerHeight: 0,
                      isScrollable: true,
                      dividerColor: Colors.transparent,
                      indicatorColor: Colors.transparent,
                      indicator: BoxDecoration(color: Colors.transparent),
                      padding: const EdgeInsets.all(0),
                      tabAlignment: TabAlignment.start,
                      splashFactory: NoSplash.splashFactory,
                      overlayColor:
                          const WidgetStatePropertyAll(Colors.transparent),
                      onTap: (value) {
                        _homeController.changeTabIndex(_tabController.index);

                        setState(() {});
                      },
                      tabs: [
                        TabChip(
                          title: "Overview",
                          selected: homeController.tabIndex == 0,
                        ),
                        TabChip(
                          title: "Sensors",
                          selected: homeController.tabIndex == 1,
                        ),
                        TabChip(
                          title: "Reports",
                          selected: homeController.tabIndex == 2,
                        ),
                        TabChip(
                          title: "Global Events",
                          selected: homeController.tabIndex == 3,
                        ),
                        TabChip(
                          title: "Community",
                          selected: homeController.tabIndex == 4,
                        ),
                        TabChip(
                          title: "Profile",
                          selected: homeController.tabIndex == 5,
                        ),
                      ],
                    ),
                    10.verticalSpace,
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          OverviewFragments(
                            tabController: _tabController,
                          ),
                          const SensorFragments(),
                          const HistoryFragment(),
                          const EventFragments(),
                          const CommunityFragments(),
                          const ProfileFragment(),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            );
          },
        ),
      );
    });
  }
}

class TabChip extends StatelessWidget {
  final String title;
  final bool selected;
  const TabChip({
    super.key,
    required this.title,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: selected ? const Color(0xffe59a54) : const Color(0xffeceee6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : Colors.black,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }
}

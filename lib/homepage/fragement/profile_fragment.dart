import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nasa_space_app/authentication/auth_controller.dart';
import 'package:nasa_space_app/authentication/user_form_screen.dart';
import 'package:nasa_space_app/homepage/controller/post_service_controller.dart';
import 'package:nasa_space_app/homepage/fragement/community.dart';
import 'package:nasa_space_app/homepage/model/main_post_model.dart';

class ProfileFragment extends StatelessWidget {
  const ProfileFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PostService>(builder: (postController) {
        return StreamBuilder<List<MainPostModel>>(
          stream: postController.getUserPostsStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (snapshot.data != null && snapshot.hasData) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GetBuilder<AuthController>(builder: (authController) {
                      if (authController.usermodel == null) {
                        return const SizedBox.shrink();
                      } else {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 20.h),
                          // height: 70.h,
                          width: context.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: const Color(0xfff4f5ef),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    authController.usermodel!.name,
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    authController.usermodel!.email,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    authController.usermodel!.address,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    authController.usermodel!.mobile,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => UserFormScreen(
                                        fromProfile: true,
                                        name: authController.usermodel?.name,
                                        address:
                                            authController.usermodel?.address,
                                        mobile:
                                            authController.usermodel?.mobile,
                                      ));
                                },
                                icon: const Icon(Iconsax.edit),
                              )
                            ],
                          ),
                        );
                      }
                    }),
                    20.verticalSpace,
                    Text(
                      "You have posted so far..",
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.w700),
                    ),
                    10.verticalSpace,
                    if (snapshot.data!.isEmpty) ...[
                      Center(
                        child: Text(
                          "No Post available",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                              color: Colors.black.withOpacity(0.5)),
                        ),
                      )
                    ] else ...[
                      ...List.generate(
                        snapshot.data!.length,
                        (index) {
                          return PostCard(
                            fromProfile: true,
                            model: snapshot.data![index],
                          ).marginOnly(bottom: 10.h);
                        },
                      )
                    ]
                  ],
                ).paddingSymmetric(horizontal: 20.w),
              );
            } else {
              return const SizedBox();
            }
          },
        );
      }),
    );
  }
}

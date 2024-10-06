import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nasa_space_app/homepage/controller/post_service_controller.dart';
import 'package:nasa_space_app/homepage/fragement/post_details.dart';
import 'package:nasa_space_app/homepage/fragement/post_screen.dart';
import 'package:intl/intl.dart';
import 'package:nasa_space_app/homepage/model/main_post_model.dart';

class CommunityFragments extends StatelessWidget {
  const CommunityFragments({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<PostService>(builder: (postController) {
        return StreamBuilder<List<MainPostModel>>(
            stream: postController.getPostsStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    10.verticalSpace,
                    GestureDetector(
                      onTap: () {
                        Get.to(const PostScreenPost());
                      },
                      child: Container(
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
                            Text(
                              "Write what's on your mind...",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                              ),
                            ),
                            Icon(
                              Iconsax.edit,
                              size: 20.r,
                            )
                          ],
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    if (snapshot.hasData && snapshot.data != null) ...[
                      ...List.generate(
                        snapshot.data!.length,
                        (index) {
                          final MainPostModel model = snapshot.data![index];
                          return PostCard(
                            model: model,
                          ).marginOnly(bottom: 10.h);
                        },
                      )
                    ]
                  ],
                ).paddingSymmetric(horizontal: 20.w),
              );
            });
      }),
    );
  }
}

class PostCard extends StatelessWidget {
  final MainPostModel model;
  final bool fromProfile;
  const PostCard({
    super.key,
    required this.model,
    this.fromProfile = false,
  });
  String formatDateTime(DateTime dateTime) {
    // Define the format: "03:00 AM 1 June 2024"
    return DateFormat('hh:mm a d MMMM yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostService>(builder: (controller) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        // height: 70.h,
        width: context.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: const Color(0xfff4f5ef),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.usermodel.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      model.usermodel.address,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
                if (fromProfile)
                  IconButton(
                    onPressed: () {
                      controller.deletePost(model.postModel.id);
                    },
                    icon: const Icon(
                      Iconsax.trash,
                      color: Colors.red,
                    ),
                  )
              ],
            ),
            10.verticalSpace,
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Get.to(() => PostDetails(
                        model: model,
                      ));
                },
                child: Text(
                  model.postModel.postText,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            10.verticalSpace,
            if (model.postModel.imageList.isNotEmpty)
              GestureDetector(
                onTap: () {
                  Get.to(() => PostDetails(
                        model: model,
                      ));
                },
                child: Container(
                  width: context.width,
                  height: 190.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        model.postModel.imageList.first,
                      ),
                    ),
                  ),
                ),
              ),
            10.verticalSpace,
            Row(
              children: [
                StreamBuilder<int>(
                  stream: controller.getReactionCountStream(
                    model.postModel.id,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      return StreamBuilder<bool>(
                          stream: controller.isUserLikedPostStream(
                            model.postModel.id,
                          ),
                          builder: (context, usershot) {
                            bool hasLiked = usershot.data ?? false;
                            return IconButton(
                              onPressed: () async {
                                if (hasLiked) {
                                  await controller
                                      .removeLikeFromPost(model.postModel.id);
                                } else {
                                  await controller
                                      .addLikeToPost(model.postModel.id);
                                }
                              },
                              icon: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(
                                    hasLiked ? Iconsax.like_15 : Iconsax.like_1,
                                    color: hasLiked ? Colors.red : null,
                                  ),
                                  3.horizontalSpace,
                                  Text(
                                    snapshot.data.toString(),
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    }

                    return const CircularProgressIndicator(); // Loading indicator while waiting for the stream
                  },
                ),
                StreamBuilder<int>(
                  stream: controller.getCommentCountStream(
                    model.postModel.id,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      return IconButton(
                        onPressed: () async {
                          Get.to(() => PostDetails(model: model));
                        },
                        icon: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Icon(
                              Iconsax.message,
                            ),
                            3.horizontalSpace,
                            Text(
                              snapshot.data.toString(),
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          ],
                        ),
                      );
                    }

                    return const CircularProgressIndicator(); // Loading indicator while waiting for the stream
                  },
                ),
                const Spacer(),
                Text(
                  formatDateTime(model.postModel.timestamp),
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                  ),
                )
              ],
            )
          ],
        ),
      );
    });
  }
}

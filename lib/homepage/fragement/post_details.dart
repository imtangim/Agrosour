import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:nasa_space_app/homepage/controller/post_service_controller.dart';
import 'package:nasa_space_app/homepage/model/comment.dart';
import 'package:nasa_space_app/homepage/model/main_post_model.dart';

class PostDetails extends StatefulWidget {
  final MainPostModel model;
  const PostDetails({super.key, required this.model});

  @override
  State<PostDetails> createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  String formatDateTime(DateTime dateTime) {
    // Define the format: "03:00 AM 1 June 2024"
    return DateFormat('hh:mm a d MMMM yyyy').format(dateTime);
  }

  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
      ),
      body: GetBuilder<PostService>(builder: (postController) {
        return Stack(
          children: [
            ListView(
              shrinkWrap: true,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
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
                            widget.model.usermodel.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          Text(
                            widget.model.usermodel.address,
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                            ),
                          ),
                          5.verticalSpace,
                          Text(
                            widget.model.postModel.postText,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                      if (widget.model.postModel.postUserUid ==
                          postController.auth.currentUser!.uid)
                        GestureDetector(
                          onTap: () async {
                            postController
                                .deletePost(widget.model.postModel.id);
                          },
                          child: Icon(
                            Iconsax.trash,
                            size: 20.r,
                            color: Colors.red,
                          ),
                        )
                    ],
                  ),
                ),
                if (widget.model.postModel.imageList.isNotEmpty) ...[
                  10.verticalSpace,
                  CarouselSlider(
                    items: [
                      ...List.generate(
                        widget.model.postModel.imageList.length,
                        (index) {
                          return Container(
                            width: context.width,
                            height: 190.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.r),
                              image: DecorationImage(
                                fit: BoxFit.contain,
                                image: NetworkImage(
                                  widget.model.postModel.imageList[index],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                    options: CarouselOptions(
                      autoPlay: false,
                      aspectRatio: 1,
                      enableInfiniteScroll: false,
                      disableCenter: false,
                      viewportFraction: 1,
                    ),
                  ),
                  15.verticalSpace,
                ],
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<int>(
                        stream: postController.getReactionCountStream(
                          widget.model.postModel.id,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            bool hasLiked = snapshot.data != 0 ? true : false;

                            return IconButton(
                              onPressed: () async {
                                if (hasLiked) {
                                  await postController.removeLikeFromPost(
                                      widget.model.postModel.id);
                                } else {
                                  await postController
                                      .addLikeToPost(widget.model.postModel.id);
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
                          }

                          return const CircularProgressIndicator(); // Loading indicator while waiting for the stream
                        },
                      ),
                      Text(
                        formatDateTime(
                          widget.model.postModel.timestamp,
                        ),
                        style: const TextStyle(
                          color: Color.fromARGB(201, 13, 13, 38),
                        ),
                      ),
                    ],
                  ),
                ),
                20.verticalSpace,
                Container(
                  width: context.width,
                  height: 1,
                  color: Colors.black.withOpacity(0.3),
                ),
                20.verticalSpace,
                StreamBuilder<List<Comment>>(
                  stream: postController
                      .getCommentsForPostWithUser(widget.model.postModel.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Column(
                          children: [
                            ...List.generate(
                              snapshot.data!.length,
                              (index) {
                                return CommentCard(
                                  model: snapshot.data![index],
                                ).marginOnly(bottom: 20.h);
                              },
                            )
                          ],
                        );
                      }
                      // Handle the case where there are no comments
                      return const SizedBox(); // Or you can show a message like "No comments yet."
                    }
                    // Optionally handle loading state if you want to show something
                    return const SizedBox(); // No loading indicator needed
                  },
                ),
                SizedBox(
                  height: 50.h,
                )
              ],
            ).paddingSymmetric(horizontal: 20.w),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                color: Colors.white,
                child: TextFormField(
                  controller: textEditingController,
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        if (textEditingController.text.isNotEmpty) {
                          await postController.addComment(
                            text: textEditingController.text,
                            userId: postController.auth.currentUser!.uid,
                            postId: widget.model.postModel.id,
                          );
                          textEditingController.clear();
                        }
                      },
                      child: const Icon(Iconsax.send_1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide: const BorderSide(
                        color: Color(0xffededed),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.r),
                      borderSide: const BorderSide(
                        color: Color(0xffededed),
                      ),
                    ),
                    hintText: "Write comment...",
                  ),
                ),
              ),
            ),
            if (postController.isloading)
              Container(
                height: context.height,
                width: context.width,
                color: Colors.white.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      }),
    );
  }
}

class CommentCard extends StatelessWidget {
  final Comment model;
  const CommentCard({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          backgroundImage: NetworkImage(
              "https://i.ytimg.com/vi/1mZhwXMl8vc/hqdefault.jpg?sqp=-oaymwExCOADEI4CSFryq4qpAyMIARUAAIhCGAHwAQH4Af4JgALQBYoCDAgAEAEYEyAyKH8wDw==&rs=AOn4CLAF2YQjvTbVETg3ACrxcoDa5WyK2g"),
        ),
        10.horizontalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
          // height: 70.h,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: const Color(0xfff4f5ef),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.user.name,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13.sp,
                ),
              ),
              3.verticalSpace,
              Text(
                model.text,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
              ).paddingOnly(bottom: 10.h)
            ],
          ),
        )
      ],
    );
  }
}

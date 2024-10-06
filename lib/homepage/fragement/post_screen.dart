import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nasa_space_app/homepage/controller/post_service_controller.dart';

class PostScreenPost extends StatefulWidget {
  const PostScreenPost({super.key});

  @override
  State<PostScreenPost> createState() => _PostScreenPostState();
}

class _PostScreenPostState extends State<PostScreenPost> {
  List<XFile> pickedImage = [];
  TextEditingController postTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Post Your Thoughts",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: GetBuilder<PostService>(builder: (postService) {
        return Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: const Color(0xfff4f5ef),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: TextFormField(
                      controller: postTextEditingController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        hintText: "Write your thoughts...",
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  GestureDetector(
                    onTap: () async {
                      final ImagePicker picker = ImagePicker();

                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      setState(() {});
                      if (image != null) {
                        if (pickedImage.indexWhere((element) =>
                                image.path.split("/").last ==
                                element.path.split("/").last) ==
                            -1) {
                          pickedImage.add(image);
                          setState(() {});
                        } else {
                          log("Image already added");
                        }
                      } else {
                        log("No image selected");
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.all(10.w),
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: const Color(0xfff4f5ef),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Choose photos",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                            ),
                          ),
                          const Icon(Iconsax.add_square4),
                        ],
                      ),
                    ),
                  ),
                  if (pickedImage.isNotEmpty) ...[
                    10.verticalSpace,
                    SizedBox(
                      width: context.width,
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runAlignment: WrapAlignment.spaceBetween,
                        spacing: 10.w,
                        runSpacing: 10.w,
                        children: [
                          ...List.generate(
                            pickedImage.length,
                            (index) {
                              return Stack(
                                children: [
                                  Container(
                                    height: 100.h,
                                    width: 100.w,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: Image.file(
                                        File(pickedImage[index].path),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: () {
                                        pickedImage.removeAt(index);
                                        setState(() {});
                                      },
                                      child: const Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ).paddingSymmetric(horizontal: 20.w),
                    20.verticalSpace,
                  ],
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1b9c73),
                      foregroundColor: Colors.white,
                      fixedSize: Size.fromWidth(context.width),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    onPressed: () async {
                      if (postTextEditingController.text.isNotEmpty) {
                        final PostService postService = Get.find();
                        await postService.createPost(
                          postText: postTextEditingController.text.trim(),
                          images: pickedImage,
                        );
                      }
                    },
                    child: Text(
                      "Post",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15.sp,
                      ),
                    ),
                  ).paddingSymmetric(horizontal: 10.w)
                ],
              ),
            ),
            if (postService.isloading)
              Container(
                width: context.width,
                height: context.height,
                color: Colors.white.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        );
      }),
    );
  }
}

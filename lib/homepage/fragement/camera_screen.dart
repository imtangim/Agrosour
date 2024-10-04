import 'dart:developer';
import 'dart:io';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  final XFile image;

  const CameraScreen({super.key, required this.image});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late Future<String> _recognizedText;

  @override
  void initState() {
    super.initState();
    _recognizedText = recogniseImage();
  }

  Future<String> recogniseImage() async {
    final gemini = Gemini.instance;

    try {
      final imageBytes = await widget.image.readAsBytes();
      final result = await gemini.textAndImage(
        text:
            "Please identify this plant and any potential diseases based on the image and details provided. If a disease is present, offer suggestions for treatment and prevention. Format the response in a way suitable for Markdown (.md) file, also if the image is not clear, or does not contain a plant, please indicate so and return it as an error message with suggestion and make message interesting.", // Text
        images: [imageBytes],
      );
      return result?.content?.parts?.last.text ?? 'No text recognized';
    } catch (e) {
      log('Error in textAndImage: $e');
      return 'No text recognized';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Find Something',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.file(
              File(widget.image.path),
              fit: BoxFit.cover,
            ),
            SizedBox(
              height: 10.h,
            ),
            FutureBuilder<String>(
              future: _recognizedText,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Text("Hold your breath. We are working...")
                      ],
                    ),
                  ); // Show a loading indicator while waiting
                } else if (snapshot.hasError) {
                  return Text(
                      'Error: ${snapshot.error}'); // Show an error message if there’s an error
                } else {
                  // Use a SizedBox or Container with a fixed or flexible height to avoid unbounded height issue
                  return Markdown(
                    data: snapshot.data ?? "No text recognized",
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    selectable: true,
                  );
                }
              },
            ).paddingSymmetric(horizontal: 5.w),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}

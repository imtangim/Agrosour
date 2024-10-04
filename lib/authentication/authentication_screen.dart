import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nasa_space_app/authentication/auth_controller.dart';
import 'package:svg_flutter/svg.dart';

class AuthenticationScreen extends StatelessWidget {
  const AuthenticationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder: (authController) {
        return SafeArea(
            child: Stack(
          children: [
            SvgPicture.asset(
              "assets/image/login.svg",
              height: context.height,
            ),
            SizedBox(
              height: 20.h,
            ),
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () async {
                  await authController.googleSignIn();
                },
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xffE2E8F0),
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        "assets/image/google.svg",
                        height: 20.h,
                        width: 20.w,
                      ),
                      10.horizontalSpace,
                      Text(
                        "Sign in with Google",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13.sp,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nasa_space_app/authentication/auth_controller.dart';
import 'package:svg_flutter/svg.dart';

class UserFormScreen extends StatefulWidget {
  final bool fromProfile;
  final String? name;
  final String? mobile;
  final String? address;

  const UserFormScreen(
      {super.key,
      this.fromProfile = false,
      this.name,
      this.mobile,
      this.address});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  late TextEditingController nameController;

  late TextEditingController addressController;

  late TextEditingController mobileNumberController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    addressController = TextEditingController(text: widget.address);
    mobileNumberController = TextEditingController(text: widget.mobile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.fromProfile
          ? AppBar(
              automaticallyImplyLeading: true,
            )
          : null,
      body: SafeArea(
        child: Center(
          child: GetBuilder<AuthController>(builder: (authcont) {
            if (authcont.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/image/signup.svg",
                      height: 200.h,
                      width: context.width,
                      fit: BoxFit.cover,
                    ),
                    if (!widget.fromProfile) ...[
                      Text(
                        "Welcome\nRegister yourself",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                        ),
                      ),
                      10.verticalSpace,
                    ],
                    CustomTextField(
                      nameController: nameController,
                      hintText: 'Name',
                      prefixTxt: widget.name,
                    ),
                    CustomTextField(
                      nameController: addressController,
                      hintText: 'Your area address',
                    ),
                    CustomTextField(
                      nameController:
                          mobileNumberController, // Use the correct controller
                      hintText: 'Mobile Number',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    SizedBox(height: 10.h),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size.fromWidth(context.width),
                        backgroundColor: const Color(0xff4F46E5),
                        foregroundColor: const Color(0xffffffff),
                      ),
                      onPressed: () async {
                        if (widget.fromProfile) {
                          await authcont.updateUserData(
                              address: addressController.text,
                              mobile: mobileNumberController.text,
                              name: nameController.text);
                        } else {
                          await authcont.saveUserData(
                            adress: addressController.text,
                            mobile: mobileNumberController.text,
                            name: nameController.text,
                          );
                        }
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 12.sp,
                        ),
                      ),
                    ),
                    if (!widget.fromProfile) ...[
                      SizedBox(height: 5.h),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size.fromWidth(context.width),
                          backgroundColor: const Color(0xffF04438),
                          foregroundColor: const Color(0xffffffff),
                        ),
                        onPressed: () async {
                          final AuthController authController = Get.find();
                          await authController.googleSignOut();
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ]
                  ],
                ).paddingSymmetric(horizontal: 24.w),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.nameController,
    required this.hintText,
    this.prefixTxt,
    this.inputFormatters,
    this.keyboardType,
  });

  final TextEditingController nameController;
  final String hintText;
  final String? prefixTxt;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: nameController,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 12.sp,
          color: const Color(0xff475569),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(
            color: Color(0xffE2E8F0),
          ),
        ),
        enabled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(
            color: Color(0xffE2E8F0),
          ),
        ),
      ),
    ).marginOnly(bottom: 5.h);
  }
}

import 'package:emcus_ipgsm_app/features/auth/register/widgets/register_app_bar_widget.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorConstants.whiteColor,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    SizedBox(height: 46 + MediaQuery.of(context).padding.top),
                    const RegisterAppBarWidget(
                      title: 'Verification',
                      isBackButtonVisible: true,
                    ),
                    SizedBox(height: 35),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SvgPicture.asset('assets/svgs/shield_green_icon.svg'),
                        SvgPicture.asset(
                          'assets/svgs/shield_green_check_icon.svg',
                        ),
                      ],
                    ),
                    SizedBox(height: 22),
                    Text(
                      'Verification Successful',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ColorConstants.blackColor,
                      ),
                    ),
                    SizedBox(height: 17),
                    Text(
                      'Create your new sign in password',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: ColorConstants.blackColor,
                      ),
                    ),
                    const SizedBox(height: 70),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: GenericTextFieldWidget(
                        labelText: 'Password',
                        hintText: 'Enter your Password',
                        controller: passwordController,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: GenericTextFieldWidget(
                        labelText: 'Confirm Password',
                        hintText: 'Enter your Password Again',
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        isPassword: true,
                      ),
                    ),
                    const SizedBox(height: 39),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder:
                                  (BuildContext context) =>
                                      const SignInScreen(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorConstants.primaryColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            child: Text(
                              'Confirm and Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: ColorConstants.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Divider(
                      color: ColorConstants.blackColor.withValues(alpha: 0.2),
                      thickness: 1,
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Already have an account?',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: ColorConstants.blackColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const SignInScreen(),
                              //   ),
                              // );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ColorConstants.textFieldBorderColor,
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Text(
                                  'Sign In Here',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstants.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

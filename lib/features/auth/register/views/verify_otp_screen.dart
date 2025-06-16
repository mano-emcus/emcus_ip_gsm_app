import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  late TextEditingController otpController;
  late TextEditingController companyNameController;
  late TextEditingController emailController;
  bool isTermsAndConditions = false;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
    companyNameController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorConstants.whiteColor,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
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
                  children: <Widget>[
                    SizedBox(height: 46 + MediaQuery.of(context).padding.top),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Row(
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/svgs/arrow_back_icon.svg',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 15),
                          Text(
                            'Verification',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ColorConstants.blackColor,
                            ),
                          ),
                          Spacer(),
                          SvgPicture.asset(
                            'assets/svgs/emcus_logo.svg',
                            width: 147,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: GenericTextFieldWidget(
                        labelText: 'Enter your one time password ',
                        hintText: 'Enter your OTP',
                        controller: otpController,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: GenericTextFieldWidget(
                        labelText: 'Company Name',
                        hintText: 'Enter your Company Name',
                        controller: companyNameController,
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: GenericTextFieldWidget(
                        labelText: 'Email Address',
                        hintText: 'Enter your email address',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Terms & Conditions checkbox with wrapping text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isTermsAndConditions = !isTermsAndConditions;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2, right: 10),
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color:
                                      isTermsAndConditions
                                          ? ColorConstants.primaryColor
                                          : ColorConstants.whiteColor,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: ColorConstants.textFieldBorderColor,
                                  ),
                                ),
                                child:
                                    isTermsAndConditions
                                        ? const Center(
                                          child: Icon(
                                            Icons.check,
                                            color: ColorConstants.whiteColor,
                                            size: 12,
                                          ),
                                        )
                                        : null,
                              ),
                            ),
                          ),
                          Flexible(
                            child: RichText(
                              text: TextSpan(
                                children: <InlineSpan>[
                                  TextSpan(
                                    text:
                                        'By registering you are agreeing with the EMCUS ',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConstants.blackColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Terms & Condition',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConstants.primaryColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' and ',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConstants.blackColor,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: ColorConstants.primaryColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 39),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (BuildContext context) =>
                                        const VerifyOtpScreen(),
                              ),
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
                                'Register',
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
                        children: <Widget>[
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
                              //     builder: (context) => const RegisterScreen(),
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

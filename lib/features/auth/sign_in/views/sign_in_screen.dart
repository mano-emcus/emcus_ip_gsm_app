import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isRememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: ColorConstants.whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 
                             MediaQuery.of(context).padding.top - 
                             MediaQuery.of(context).padding.bottom - 
                             52, // Account for horizontal padding
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      SizedBox(height: 76),
                      SvgPicture.asset('assets/svgs/emcus_logo.svg'),
                      SizedBox(height: 68),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sign in',
                          style: GoogleFonts.inter(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.blackColor,
                          ),
                        ),
                      ),
                      SizedBox(height: 49),
                      GenericTextFieldWidget(
                        labelText: 'Email',
                        hintText: "Enter your email",
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 14),
                      GenericTextFieldWidget(
                        labelText: 'Password',
                        hintText: "Enter your password",
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                      ),
                      SizedBox(height: 19),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isRememberMe = !isRememberMe;
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color:
                                        isRememberMe
                                            ? ColorConstants.primaryColor
                                            : ColorConstants.whiteColor,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: ColorConstants.textFieldBorderColor,
                                    ),
                                  ),
                                  child:
                                      isRememberMe
                                          ? Center(
                                            child: Icon(
                                              Icons.check,
                                              color: ColorConstants.whiteColor,
                                              size: 12,
                                            ),
                                          )
                                          : null,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Remember me',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstants.blackColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Forgot password?',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: ColorConstants.primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 39),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorConstants.primaryColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            child: Text(
                              'Sign in',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: ColorConstants.whiteColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(), // Now this will work!
                      Text(
                        'Dont have an account?',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: ColorConstants.blackColor,
                        ),
                      ),
                      SizedBox(height: 20), // Add some bottom padding
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

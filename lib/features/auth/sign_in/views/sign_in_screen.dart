import 'package:emcus_ipgsm_app/features/auth/register/views/register_screen.dart';
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
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool isRememberMe = false;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
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
                    SvgPicture.asset('assets/svgs/emcus_logo.svg'),
                    SizedBox(height: 68),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Align(
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
                    ),
                    SizedBox(height: 49),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: GenericTextFieldWidget(
                        labelText: 'Email Address',
                        hintText: 'Enter your email address',
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: GenericTextFieldWidget(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                      ),
                    ),
                    SizedBox(height: 19),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isRememberMe = !isRememberMe;
                              });
                            },
                            child: Row(
                              children: <Widget>[
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
                                      color:
                                          ColorConstants.textFieldBorderColor,
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
                    ),
                    SizedBox(height: 39),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorConstants.primaryColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
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
                    ),
                    Spacer(),
                    Divider(
                      color: ColorConstants.blackColor.withValues(alpha: 0.2),
                      thickness: 1,
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Don’t have an account?',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: ColorConstants.blackColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => RegisterScreen(),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: ColorConstants.textFieldBorderColor,
                                ),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: Text(
                                  'Sign Up Here',
                                  style: GoogleFonts.inter(
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

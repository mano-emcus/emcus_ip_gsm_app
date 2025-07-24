import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_event.dart';
import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_state.dart';
import 'package:emcus_ipgsm_app/features/auth/verify_otp/views/verify_otp_screen.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_text_field_widget.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_yet_to_implement_pop_up_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController fullNameController;
  late TextEditingController companyNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool isTermsAndConditions = false;
  bool canSubmit = false;
  bool _showPasswordMismatchError = false;

  @override
  void initState() {
    super.initState();
    fullNameController = TextEditingController();
    companyNameController = TextEditingController(text: 'Emcus Technologies');
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    emailController = TextEditingController();
    fullNameController.addListener(_updateCanSubmit);
    companyNameController.addListener(_updateCanSubmit);
    emailController.addListener(_updateCanSubmit);
    passwordController.addListener(_validatePasswordMatch);
    confirmPasswordController.addListener(_validatePasswordMatch);

  }

  void _validatePasswordMatch() {
    setState(() {
      _showPasswordMismatchError =
          confirmPasswordController.text.isNotEmpty &&
          passwordController.text != confirmPasswordController.text;
    });
  }

  void _updateCanSubmit() {
    final fullName = fullNameController.text.trim();
    final companyName = companyNameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final next =
        fullName.isNotEmpty &&
        companyName.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword &&
        isTermsAndConditions;
    if (next != canSubmit) {
      setState(() => canSubmit = next);
    }
  }

  @override
  void dispose() {
    fullNameController.removeListener(_updateCanSubmit);
    companyNameController.removeListener(_updateCanSubmit);
    emailController.removeListener(_updateCanSubmit);
    fullNameController.dispose();
    companyNameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  bool _canSubmit() => canSubmit;

  String _getValidationMessage() {
    if (fullNameController.text.isEmpty) {
      return 'Please enter your name';
    }
    if (companyNameController.text.isEmpty) {
      return 'Please enter your company name';
    }
    if (emailController.text.isEmpty) {
      return 'Please enter your email address';
    }
    if (!isTermsAndConditions) {
      return 'Please agree to the terms and conditions to register';
    }
    if (passwordController.text.isEmpty) {
      return 'Please enter your password';
    }
    if (confirmPasswordController.text.isEmpty) {
      return 'Please enter your confirm password';
    }
    if (passwordController.text != confirmPasswordController.text) {
      return 'Passwords do not match';
    }
    return 'Please fill all the fields to register';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyOtpScreen(email: emailController.text),
            ),
          );
        } else if (state is RegisterFailure) {
          showDialog(
            context: context,
            builder: (context) => GenericYetToImplementPopUpWidget(
              title: 'Registration Failed',
              message: state.error,
            ),
          );
        }
      },
      child: Scaffold(
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
                      SizedBox(
                        height: 46 + MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Register',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: ColorConstants.blackColor,
                              ),
                            ),
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
                          labelText: 'Name',
                          hintText: 'Enter your Name',
                          controller: fullNameController,
                          keyboardType: TextInputType.name,
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
                          readOnly: true,
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
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        child: GenericTextFieldWidget(
                          labelText: 'Password',
                          hintText: 'Enter your Password',
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          isPassword: true,
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
                          obscureText: true,
                          isPassword: true,
                        ),
                      ),
                      if (_showPasswordMismatchError)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 26,
                            right: 26,
                            top: 8,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Passwords do not match',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 20),
                      // Terms & Conditions checkbox with wrapping text
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 26),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isTermsAndConditions =
                                      !isTermsAndConditions;
                                });
                                _updateCanSubmit();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 2,
                                  right: 10,
                                ),
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
                                      color:
                                          ColorConstants.textFieldBorderColor,
                                    ),
                                  ),
                                  child:
                                      isTermsAndConditions
                                          ? const Center(
                                            child: Icon(
                                              Icons.check,
                                              color:
                                                  ColorConstants.whiteColor,
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
                                  children: [
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
                          child: BlocBuilder<RegisterBloc, RegisterState>(
                            builder: (context, state) {
                              return GestureDetector(
                                onTap:
                                    _canSubmit()
                                        ? () {
                                          if (state is! RegisterLoading) {
                                            context.read<RegisterBloc>().add(
                                              RegisterSubmitted(
                                                fullName:
                                                    fullNameController.text,
                                                companyName:
                                                    companyNameController
                                                        .text,
                                                email: emailController.text,
                                                password:
                                                    passwordController.text,
                                              ),
                                            );
                                          }
                                        }
                                        : () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (
                                                  context,
                                                ) => GenericYetToImplementPopUpWidget(
                                                  title: 'Register',
                                                  message:
                                                      _getValidationMessage(),
                                                ),
                                          );
                                        },
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
                                    child:
                                        state is RegisterLoading
                                            ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child:
                                                  CircularProgressIndicator(
                                                    color:
                                                        ColorConstants
                                                            .whiteColor,
                                                    strokeWidth: 2,
                                                  ),
                                            )
                                            : Text(
                                              'Register',
                                              style: GoogleFonts.inter(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color:
                                                    ColorConstants.whiteColor,
                                              ),
                                            ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const Spacer(),
                      Divider(
                        color: ColorConstants.blackColor.withValues(
                          alpha: 0.2,
                        ),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const SignInScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        ColorConstants.textFieldBorderColor,
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
      ),
    );
  }
}

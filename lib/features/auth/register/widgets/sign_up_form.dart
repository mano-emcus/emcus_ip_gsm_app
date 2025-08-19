import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_state.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_state.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
import 'package:emcus_ipgsm_app/features/auth/verify_otp/views/verify_otp_screen.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_text_field_widget.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_yet_to_implement_pop_up_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    super.key,
    required this.onSignUp,
    required this.state,
    required this.onSignIn,
  });

  final Function({
    String fullName,
    String companyName,
    String email,
    String password,
  })
  onSignUp;
  final Function() onSignIn;
  final RegisterState state;

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  late TextEditingController fullNameController,
      companyNameController,
      emailController,
      passwordController,
      confirmPasswordController;
  bool termsAndConditions = false;

  @override
  void initState() {
    fullNameController = TextEditingController();
    companyNameController = TextEditingController(text: 'Emcus Technologies');
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => VerifyOtpScreen(email: emailController.text),
            ),
          );
        } else if (state is RegisterFailure) {
          showDialog(
            context: context,
            builder:
                (context) => GenericYetToImplementPopUpWidget(
                  title: 'Registration Failed',
                  message: state.error,
                ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Register',
                style: GoogleFonts.inter(
                  color: customColors.themeTextPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),
            GenericTextFieldWidget(
              controller: fullNameController,
              hintText: 'Full Name',
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            GenericTextFieldWidget(
              controller: companyNameController,
              hintText: 'Company Name',
              keyboardType: TextInputType.name,
              readOnly: true,
            ),
            const SizedBox(height: 16),
            GenericTextFieldWidget(
              controller: emailController,
              hintText: 'Email Address',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            GenericTextFieldWidget(
              controller: passwordController,
              hintText: 'Password',
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              isPassword: true,
            ),
            const SizedBox(height: 16),
            GenericTextFieldWidget(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              isPassword: true,
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap:
                  () =>
                      setState(() => termsAndConditions = !termsAndConditions),
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color:
                          termsAndConditions
                              ? customColors.primaryColor
                              : customColors.themeCheckboxBackground,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child:
                        termsAndConditions
                            ? const Icon(
                              Icons.check,
                              size: 12,
                              color: ColorConstants.whiteColor,
                            )
                            : null,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'I agree to the terms and conditions',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: customColors.themeTextPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap:
                  widget.state is SignInLoading
                      ? null
                      : () {
                        if (fullNameController.text.isEmpty ||
                            emailController.text.isEmpty ||
                            passwordController.text.isEmpty ||
                            confirmPasswordController.text.isEmpty ||
                            !termsAndConditions) {
                          showDialog(
                            context: context,
                            builder:
                                (context) => GenericYetToImplementPopUpWidget(
                                  title: 'Registration Failed',
                                  message:
                                      'Please enter your full name, email, password, confirm password and agree to the terms and conditions',
                                ),
                          );
                          return;
                        }
                        widget.onSignUp(
                          fullName: fullNameController.text,
                          companyName: 'Gemini',
                          email: emailController.text,
                          password: passwordController.text,
                        );
                      },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: customColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child:
                        widget.state is RegisterLoading
                            ? SizedBox(
                              height: 23,
                              width: 23,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ColorConstants.whiteColor,
                              ),
                            )
                            : Text(
                              'Register',
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
            const SizedBox(height: 18),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Already have an account? ',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: customColors.themeTextPrimary,
                    ),
                  ),
                  TextSpan(
                    text: 'Sign In',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: customColors.primaryColor,
                    ),
                    recognizer:
                        TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignInScreen(),
                              ),
                            );
                          },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

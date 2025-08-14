import 'package:emcus_ipgsm_app/features/auth/register/views/register_screen.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_state.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_text_field_widget.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_yet_to_implement_pop_up_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    super.key,
    required this.onSignIn,
    required this.state,
    required this.onSignUp,
  });

  final Function({String email, String password}) onSignIn;
  final Function() onSignUp;
  final SignInState state;

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  late TextEditingController emailController, passwordController;
  bool isRememberMe = false;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Sign In',
              style: GoogleFonts.inter(
                color: customColors.themeTextPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
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
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => setState(() => isRememberMe = !isRememberMe),
                child: Row(
                  children: [
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color:
                            isRememberMe
                                ? customColors.primaryColor
                                : customColors.themeCheckboxBackground,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child:
                          isRememberMe
                              ? const Icon(
                                Icons.check,
                                size: 12,
                                color: ColorConstants.whiteColor,
                              )
                              : null,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Remember me',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: customColors.themeTextPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Forgot password?',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: customColors.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap:
                widget.state is SignInLoading
                    ? null
                    : () {
                      if (emailController.text.isEmpty ||
                          passwordController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder:
                              (context) => GenericYetToImplementPopUpWidget(
                                title: 'Sign In',
                                message: 'Please enter your email and password',
                              ),
                        );
                        return;
                      }
                      widget.onSignIn(
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
                      widget.state is SignInLoading
                          ? SizedBox(
                            height: 23,
                            width: 23,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: ColorConstants.whiteColor,
                            ),
                          )
                          : Text(
                            'Sign In',
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
                  text: "Don't have an account? ",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: customColors.themeTextPrimary,
                  ),
                ),
                TextSpan(
                  text: 'Sign Up',
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
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

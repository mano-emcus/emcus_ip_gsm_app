import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_state.dart';
import 'package:emcus_ipgsm_app/features/auth/set_password/bloc/set_password_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/set_password/bloc/set_password_state.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_state.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_text_field_widget.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_yet_to_implement_pop_up_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SetPasswordForm extends StatefulWidget {
  const SetPasswordForm({
    super.key,
    required this.onSetPassword,
    required this.state,
  });

  final Function({String password}) onSetPassword;
  final SetPasswordState state;

  @override
  State<SetPasswordForm> createState() => _SetPasswordFormState();
}

class _SetPasswordFormState extends State<SetPasswordForm> {
  late TextEditingController passwordController, confirmPasswordController;
  bool termsAndConditions = false;

  @override
  void initState() {
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return BlocListener<SetPasswordBloc, SetPasswordState>(
      listener: (context, state) {
        if (state is SetPasswordSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
          );
        } else if (state is SetPasswordFailure) {
          showDialog(
            context: context,
            builder:
                (context) => GenericYetToImplementPopUpWidget(
                  title: 'Set Password Failed',
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
                'Create Password',
                style: GoogleFonts.inter(
                  color: customColors.themeTextPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Please create a strong password to secure your account',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: customColors.themeTextSecondary,
              ),
            ),
            const SizedBox(height: 24),
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

            const SizedBox(height: 24),
            Text(
              'Must be at least 8 characters with uppercase, lowercase, and number',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: customColors.themeTextSecondary,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap:
                  widget.state is SignInLoading
                      ? null
                      : () {
                        if (passwordController.text.isEmpty ||
                            confirmPasswordController.text.isEmpty ||
                            !termsAndConditions) {
                          showDialog(
                            context: context,
                            builder:
                                (context) => GenericYetToImplementPopUpWidget(
                                  title: 'Set Password Failed',
                                  message:
                                      'Please enter your password and confirm password',
                                ),
                          );
                          return;
                        }
                        widget.onSetPassword(password: passwordController.text);
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
                              'Continue',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/svgs/secure_icon.svg'),
                const SizedBox(width: 6),
                Text(
                  'Your password is encrypted and secure',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: customColors.themeTextSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:emcus_ipgsm_app/features/auth/register/widgets/register_app_bar_widget.dart';
import 'package:emcus_ipgsm_app/features/auth/set_password/bloc/set_password_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/set_password/bloc/set_password_event.dart';
import 'package:emcus_ipgsm_app/features/auth/set_password/bloc/set_password_state.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_text_field_widget.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_yet_to_implement_pop_up_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({super.key, required this.email});
  final String email;

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  bool _showPasswordMismatchError = false;

  @override
  void initState() {
    super.initState();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();

    // Add listeners to validate passwords in real-time
    passwordController.addListener(_validatePasswordMatch);
    confirmPasswordController.addListener(_validatePasswordMatch);
  }

  @override
  void dispose() {
    passwordController.removeListener(_validatePasswordMatch);
    confirmPasswordController.removeListener(_validatePasswordMatch);
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _validatePasswordMatch() {
    setState(() {
      _showPasswordMismatchError =
          confirmPasswordController.text.isNotEmpty &&
          passwordController.text != confirmPasswordController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SetPasswordBloc(),
      child: BlocListener<SetPasswordBloc, SetPasswordState>(
        listener: (context, state) {
          if (state is SetPasswordSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) => const SignInScreen(),
              ),
              (Route<dynamic> route) => false,
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
                        const RegisterAppBarWidget(
                          title: 'Verification',
                          isBackButtonVisible: true,
                        ),
                        const SizedBox(height: 35),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/svgs/shield_green_icon.svg',
                            ),
                            SvgPicture.asset(
                              'assets/svgs/shield_green_check_icon.svg',
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Verification Successful',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: ColorConstants.blackColor,
                          ),
                        ),
                        const SizedBox(height: 17),
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
                        SizedBox(height: _showPasswordMismatchError ? 31 : 39),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          child: BlocBuilder<SetPasswordBloc, SetPasswordState>(
                            builder: (context, state) {
                              return GestureDetector(
                                onTap:
                                    _canSubmit()
                                        ? () {
                                          if (state is! SetPasswordLoading) {
                                            if (_validatePasswords()) {
                                              context
                                                  .read<SetPasswordBloc>()
                                                  .add(
                                                    SetPasswordSubmitted(
                                                      email: widget.email,
                                                      password:
                                                          passwordController
                                                              .text,
                                                    ),
                                                  );
                                            }
                                          }
                                        }
                                        : () {
                                          showDialog(
                                            context: context,
                                            builder:
                                                (
                                                  context,
                                                ) => GenericYetToImplementPopUpWidget(
                                                  title: 'Set Password',
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
                                        state is SetPasswordLoading
                                            ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                color:
                                                    ColorConstants.whiteColor,
                                                strokeWidth: 2,
                                              ),
                                            )
                                            : const Text(
                                              'Confirm and Sign In',
                                              style: TextStyle(
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
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const SignInScreen(),
                                    ),
                                    (Route<dynamic> route) => false,
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
      ),
    );
  }

  bool _canSubmit() {
    return passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  bool _validatePasswords() {
    if (passwordController.text != confirmPasswordController.text) {
      return false;
    }

    if (passwordController.text.length < 6) {
      showDialog(
        context: context,
        builder:
            (context) => GenericYetToImplementPopUpWidget(
              title: 'Password Too Short',
              message: 'Password must be at least 6 characters long.',
            ),
      );
      return false;
    }

    return true;
  }

  String _getValidationMessage() {
    if (passwordController.text.isEmpty) {
      return 'Please enter a password';
    }
    if (confirmPasswordController.text.isEmpty) {
      return 'Please confirm your password';
    }
    return 'Please fill all fields';
  }
}

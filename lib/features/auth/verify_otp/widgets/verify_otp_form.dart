import 'package:emcus_ipgsm_app/features/auth/set_password/views/set_password_screen.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_state.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/views/sign_in_screen.dart';
import 'package:emcus_ipgsm_app/features/auth/verify_otp/bloc/verify_otp_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/verify_otp/bloc/verify_otp_state.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_yet_to_implement_pop_up_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class VerifyOtpForm extends StatefulWidget {
  const VerifyOtpForm({
    super.key,
    required this.onVerifyOtp,
    required this.state,
    required this.email,
  });

  final Function({String confirmationCode}) onVerifyOtp;
  final String email;
  final VerifyOtpState state;

  @override
  State<VerifyOtpForm> createState() => _VerifyOtpFormState();
}

class _VerifyOtpFormState extends State<VerifyOtpForm> {
  late TextEditingController pinController;
  bool termsAndConditions = false;

  @override
  void initState() {
    pinController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customColors = Theme.of(context).extension<CustomColors>()!;
    return BlocListener<VerifyOtpBloc, VerifyOtpState>(
      listener: (context, state) {
        if (state is VerifyOtpSuccess) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SetPasswordScreen(email: widget.email),
            ),
          );
        } else if (state is VerifyOtpFailure) {
          showDialog(
            context: context,
            builder:
                (context) => GenericYetToImplementPopUpWidget(
                  title: 'Verification Failed',
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
                'Verification Required',
                style: GoogleFonts.inter(
                  color: customColors.themeTextPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'For your security, please enter the 6-digit code sent to',
              style: GoogleFonts.inter(
                color: customColors.themeTextSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.email,
                style: GoogleFonts.inter(
                  color: customColors.themeTextPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Pinput(
              controller: pinController,
              length: 6,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              defaultPinTheme: PinTheme(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                  color: customColors.themeCheckboxBackground,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
            const SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset('assets/svgs/timer_icon.svg'),
                const SizedBox(width: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Resend code in ',
                        style: GoogleFonts.inter(
                          color: customColors.themeTextPrimary,
                        ),
                      ),
                      TextSpan(
                        text: '04:59',
                        style: GoogleFonts.inter(
                          color: customColors.primaryColor,
                        ),
                      ),
                    ],
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
                        if (pinController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder:
                                (context) => GenericYetToImplementPopUpWidget(
                                  title: 'Verification Failed',
                                  message:
                                      'Please enter your confirmation code',
                                ),
                          );
                          return;
                        }
                        widget.onVerifyOtp(
                          confirmationCode: pinController.text,
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
                        widget.state is VerifyOtpLoading
                            ? SizedBox(
                              height: 23,
                              width: 23,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ColorConstants.whiteColor,
                              ),
                            )
                            : Text(
                              'Verify Code',
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
                    text: "Didn't receive a code? ",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: customColors.themeTextPrimary,
                    ),
                  ),
                  TextSpan(
                    text: 'Resend in 30s',
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

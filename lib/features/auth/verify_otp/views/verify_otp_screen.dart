import 'package:emcus_ipgsm_app/features/auth/set_password/views/set_password_screen.dart';
import 'package:emcus_ipgsm_app/features/auth/register/widgets/register_app_bar_widget.dart';
import 'package:emcus_ipgsm_app/features/auth/verify_otp/bloc/verify_otp_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/verify_otp/bloc/verify_otp_event.dart';
import 'package:emcus_ipgsm_app/features/auth/verify_otp/bloc/verify_otp_state.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_text_field_widget.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_yet_to_implement_pop_up_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key, required this.email});
  final String email;

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  late TextEditingController otpController;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerifyOtpBloc(),
      child: BlocListener<VerifyOtpBloc, VerifyOtpState>(
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
              builder: (context) => GenericYetToImplementPopUpWidget(
                title: 'Verification Failed',
                message: state.error,
              ),
            );
          }
        },
        child: Scaffold(
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
                        const RegisterAppBarWidget(
                          title: 'Verification',
                          isBackButtonVisible: true,
                        ),
                        const SizedBox(height: 35),
                        SvgPicture.asset('assets/svgs/shield_icon.svg'),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.only(left: 26, right: 49),
                          child: RichText(
                            text: TextSpan(
                              children: <InlineSpan>[
                                TextSpan(
                                  text:
                                      'We have shared you an email with the temporary one time password to this email id ',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstants.blackColor,
                                  ),
                                ),
                                TextSpan(
                                  text: widget.email,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstants.primaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          child: GenericTextFieldWidget(
                            labelText: 'Enter your one time password ',
                            hintText: 'Enter your OTP',
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          child: BlocBuilder<VerifyOtpBloc, VerifyOtpState>(
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: otpController.text.isNotEmpty
                                    ? () {
                                        if (state is! VerifyOtpLoading) {
                                          context.read<VerifyOtpBloc>().add(
                                                VerifyOtpSubmitted(
                                                  email: widget.email,
                                                  confirmationCode: otpController.text,
                                                ),
                                              );
                                        }
                                      }
                                    : () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => GenericYetToImplementPopUpWidget(
                                            title: 'Verification',
                                            message: 'Please enter the OTP to continue',
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
                                    child: state is VerifyOtpLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: ColorConstants.whiteColor,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text(
                                            'Verify & Continue',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: ColorConstants.whiteColor,
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
                          color: ColorConstants.blackColor.withValues(alpha: 0.2),
                          thickness: 1,
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 26),
                          child: RichText(
                            text: TextSpan(
                              children: <InlineSpan>[
                                TextSpan(
                                  text: "Didn't receive it? ",
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstants.blackColor,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Click here to request again',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstants.primaryColor,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()..onTap = _resendOtp,
                                ),
                              ],
                            ),
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

  void _resendOtp() {}
}

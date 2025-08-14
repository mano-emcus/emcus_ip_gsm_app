import 'package:emcus_ipgsm_app/features/auth/verify_otp/bloc/verify_otp_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/verify_otp/bloc/verify_otp_event.dart';
import 'package:emcus_ipgsm_app/features/auth/verify_otp/bloc/verify_otp_state.dart';
import 'package:emcus_ipgsm_app/features/auth/verify_otp/widgets/verify_otp_form.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_form_card.dart';
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: customColors.themeBackground,
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
                    Hero(
                      tag: 'emcus_logo',
                      child: SvgPicture.asset(
                        theme.brightness == Brightness.dark
                            ? 'assets/svgs/emcus_logo_dark.svg'
                            : 'assets/svgs/emcus_logo.svg',
                        height: 40,
                      ),
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Fire Alert Monitor',
                      style: theme.textTheme.bodyLarge,
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Text(
                        'Real-time monitoring for your safety systems',
                        style: theme.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<VerifyOtpBloc, VerifyOtpState>(
                      builder: (context, state) {
                        return GenericFormCard(
                          padding: EdgeInsets.symmetric(horizontal: 26),
                          child: VerifyOtpForm(
                            state: state,
                            email: widget.email,
                            onVerifyOtp: ({String? confirmationCode}) {
                              if (state is! VerifyOtpLoading) {
                                context.read<VerifyOtpBloc>().add(
                                  VerifyOtpSubmitted(
                                    email: widget.email,
                                    confirmationCode: confirmationCode!,
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Back to Registration',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: customColors.themeTextSecondary,
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
    );
  }
}

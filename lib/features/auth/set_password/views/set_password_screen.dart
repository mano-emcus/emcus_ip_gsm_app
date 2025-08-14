import 'package:emcus_ipgsm_app/features/auth/set_password/bloc/set_password_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/set_password/bloc/set_password_event.dart';
import 'package:emcus_ipgsm_app/features/auth/set_password/bloc/set_password_state.dart';
import 'package:emcus_ipgsm_app/features/auth/set_password/widgets/set_password_form.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_form_card.dart';
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
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: customColors.themeBackground,
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
                    BlocBuilder<SetPasswordBloc, SetPasswordState>(
                      builder: (context, state) {
                        return GenericFormCard(
                          padding: EdgeInsets.symmetric(horizontal: 26),
                          child: SetPasswordForm(
                            state: state,
                            onSetPassword: ({String? password}) {
                              if (state is! SetPasswordLoading) {
                                context.read<SetPasswordBloc>().add(
                                  SetPasswordSubmitted(
                                    email: widget.email,
                                    password: password!,
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
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

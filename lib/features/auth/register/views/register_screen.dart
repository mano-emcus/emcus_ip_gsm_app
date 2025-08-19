import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_event.dart';
import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_state.dart';
import 'package:emcus_ipgsm_app/features/auth/register/widgets/sign_up_form.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_form_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                    BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        return GenericFormCard(
                          padding: EdgeInsets.symmetric(horizontal: 26),
                          child: SignUpForm(
                            state: state,
                            onSignUp: ({
                              String? fullName,
                              String? companyName,
                              String? email,
                              String? password,
                            }) {
                              FocusScope.of(context).unfocus();
                              if (state is! RegisterLoading) {
                                context.read<RegisterBloc>().add(
                                  RegisterSubmitted(
                                    fullName: fullName!,
                                    companyName: companyName!,
                                    email: email!,
                                    password: password!,
                                  ),
                                );
                              }
                            },
                            onSignIn: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                          ),
                        );
                      },
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

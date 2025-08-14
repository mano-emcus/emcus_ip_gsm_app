import 'package:emcus_ipgsm_app/features/auth/register/views/register_screen.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_event.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_state.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/widgets/sign_in_form.dart';
import 'package:emcus_ipgsm_app/features/home/views/dashboard_screen.dart';
import 'package:emcus_ipgsm_app/utils/theme/custom_colors.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_form_card.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_yet_to_implement_pop_up_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

// Custom page route for smooth transitions
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  CustomPageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 800),
  }) : super(
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         pageBuilder: (context, animation, secondaryAnimation) => child,
       );

  final Widget child;
  final Duration duration;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 0.15),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
      ),
      child: FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic),
        ),
        child: child,
      ),
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customColors = theme.extension<CustomColors>()!;
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            CustomPageRoute(child: const DashBoardScreen()),
            (route) => false,
          );
        } else if (state is SignInFailure) {
          showDialog(
            context: context,
            builder:
                (_) => GenericYetToImplementPopUpWidget(
                  title: 'Sign In Failed',
                  message: state.error,
                ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: customColors.themeBackground,
        body: LayoutBuilder(
          builder:
              (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.vertical,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 46 + MediaQuery.of(context).padding.top,
                        ),
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
                        BlocBuilder<SignInBloc, SignInState>(
                          builder: (context, state) {
                            return GenericFormCard(
                              padding: EdgeInsets.symmetric(horizontal: 26),
                              child: SignInForm(
                                state: state,
                                onSignIn: ({String? email, String? password}) {
                                  FocusScope.of(context).unfocus();
                                  if (state is! SignInLoading) {
                                    context.read<SignInBloc>().add(
                                      SignInSubmitted(
                                        email: email!.trim(),
                                        password: password!.trim(),
                                      ),
                                    );
                                  }
                                },
                                onSignUp: () {
                                  Navigator.push(
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
              ),
        ),
      ),
    );
  }
}

import 'package:emcus_ipgsm_app/features/auth/register/views/register_screen.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_event.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_state.dart';
import 'package:emcus_ipgsm_app/features/home/views/dashboard_screen.dart';
import 'package:emcus_ipgsm_app/utils/constants/color_constants.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_text_field_widget.dart';
import 'package:emcus_ipgsm_app/utils/widgets/generic_yet_to_implement_pop_up_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

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
  late final TextEditingController emailController;
  late final TextEditingController passwordController;
  bool canSubmit = false;
  bool isRememberMe = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailController.addListener(_updateCanSubmit);
    passwordController.addListener(_updateCanSubmit);
  }

  void _updateCanSubmit() {
    final email = emailController.text.trim();
    final pwd = passwordController.text.trim();
    final next = email.isNotEmpty && pwd.isNotEmpty;
    if (next != canSubmit) {
      setState(() => canSubmit = next);
    }
  }

  @override
  void dispose() {
    emailController.removeListener(_updateCanSubmit);
    passwordController.removeListener(_updateCanSubmit);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _canSubmit() => canSubmit;

  String _getValidationMessage() {
    if (emailController.text.isEmpty) {
      return 'Please enter your email address';
    }
    if (passwordController.text.isEmpty) {
      return 'Please enter your password';
    }
    return 'Please fill all fields';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInBloc(),
      child: BlocListener<SignInBloc, SignInState>(
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
          backgroundColor: ColorConstants.whiteColor,
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
                              'assets/svgs/emcus_logo.svg',
                            ),
                          ),
                          const SizedBox(height: 68),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 26),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Sign in',
                                style: GoogleFonts.inter(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: ColorConstants.blackColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 49),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 26),
                            child: GenericTextFieldWidget(
                              labelText: 'Email Address',
                              hintText: 'Enter your email address',
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 26),
                            child: GenericTextFieldWidget(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              isPassword: true,
                            ),
                          ),
                          const SizedBox(height: 19),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 26),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap:
                                      () => setState(
                                        () => isRememberMe = !isRememberMe,
                                      ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          color:
                                              isRememberMe
                                                  ? ColorConstants.primaryColor
                                                  : ColorConstants.whiteColor,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          border: Border.all(
                                            color:
                                                ColorConstants
                                                    .textFieldBorderColor,
                                          ),
                                        ),
                                        child:
                                            isRememberMe
                                                ? const Icon(
                                                  Icons.check,
                                                  size: 12,
                                                  color:
                                                      ColorConstants.whiteColor,
                                                )
                                                : null,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Remember me',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: ColorConstants.blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Forgot password?',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: ColorConstants.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 39),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 26),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: BlocBuilder<SignInBloc, SignInState>(
                                builder: (context, state) {
                                  return GestureDetector(
                                    onTap:
                                        _canSubmit()
                                            ? () {
                                              FocusScope.of(context).unfocus();
                                              if (state is! SignInLoading) {
                                                context.read<SignInBloc>().add(
                                                  SignInSubmitted(
                                                    email:
                                                        emailController.text
                                                            .trim(),
                                                    password:
                                                        passwordController.text
                                                            .trim(),
                                                  ),
                                                );
                                              }
                                            }
                                            : () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (
                                                      _,
                                                    ) => GenericYetToImplementPopUpWidget(
                                                      title: 'Sign In',
                                                      message:
                                                          _getValidationMessage(),
                                                    ),
                                              );
                                            },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: ColorConstants.primaryColor,
                                        borderRadius: BorderRadius.circular(
                                          100,
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 16,
                                      ),
                                      child:
                                          state is SignInLoading
                                              ? const SizedBox(
                                                height: 20,
                                                width: 20,
                                                child:
                                                    CircularProgressIndicator(
                                                      color:
                                                          ColorConstants
                                                              .whiteColor,
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                              : Text(
                                                'Sign in',
                                                style: GoogleFonts.inter(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      ColorConstants.whiteColor,
                                                ),
                                              ),
                                    ),
                                  );
                                },
                              ),
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
                                  "Don't have an account?",
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: ColorConstants.blackColor,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const RegisterScreen(),
                                      ),
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    child: Text(
                                      'Sign Up Here',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: ColorConstants.primaryColor,
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
                ),
          ),
        ),
      ),
    );
  }
}

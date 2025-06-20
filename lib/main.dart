import 'package:emcus_ipgsm_app/features/splash_screen/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/set_password/bloc/set_password_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/verify_otp/bloc/verify_otp_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LogsBloc>(create: (_) => LogsBloc()),
        BlocProvider<NotesBloc>(create: (_) => NotesBloc()),
        BlocProvider<SignInBloc>(create: (_) => SignInBloc()),
        BlocProvider<RegisterBloc>(create: (_) => RegisterBloc()),
        BlocProvider<SetPasswordBloc>(create: (_) => SetPasswordBloc()),
        BlocProvider<VerifyOtpBloc>(create: (_) => VerifyOtpBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Ip-Gsm App', home: SplashScreen());
  }
}

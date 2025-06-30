import 'package:emcus_ipgsm_app/features/sites/bloc/devices/site_devices_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/notes/site_notes_bloc.dart';
import 'package:emcus_ipgsm_app/features/splash_screen/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/site/sites_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/set_password/bloc/set_password_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/verify_otp/bloc/verify_otp_bloc.dart';
import 'package:emcus_ipgsm_app/core/services/di.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
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
        BlocProvider<LogsBloc>(create: (_) => getIt<LogsBloc>()),
        BlocProvider<NotesBloc>(create: (_) => getIt<NotesBloc>()),
        BlocProvider<SitesBloc>(create: (_) => getIt<SitesBloc>()),
        BlocProvider<SignInBloc>(create: (_) => getIt<SignInBloc>()),
        BlocProvider<RegisterBloc>(create: (_) => getIt<RegisterBloc>()),
        BlocProvider<SetPasswordBloc>(create: (_) => getIt<SetPasswordBloc>()),
        BlocProvider<VerifyOtpBloc>(create: (_) => getIt<VerifyOtpBloc>()),
        BlocProvider<SiteLogsBloc>(create: (_) => getIt<SiteLogsBloc>()),
        BlocProvider<SiteNotesBloc>(create: (_) => getIt<SiteNotesBloc>()),
        BlocProvider<SiteDevicesBloc>(create: (_) => getIt<SiteDevicesBloc>()),
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

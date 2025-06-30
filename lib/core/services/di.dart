import 'package:get_it/get_it.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/site/sites_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/set_password/bloc/set_password_bloc.dart';
import 'package:emcus_ipgsm_app/features/auth/verify_otp/bloc/verify_otp_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/notes/site_notes_bloc.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/devices/site_devices_bloc.dart';
import 'package:emcus_ipgsm_app/features/logs/bloc/logs_repository.dart';
import 'package:emcus_ipgsm_app/features/notes/bloc/notes_repository.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/site/sites_repository.dart';
import 'package:emcus_ipgsm_app/features/auth/sign_in/bloc/sign_in_repository.dart';
import 'package:emcus_ipgsm_app/features/auth/register/bloc/register_repository.dart';
import 'package:emcus_ipgsm_app/features/auth/set_password/bloc/set_password_repository.dart';
import 'package:emcus_ipgsm_app/features/auth/verify_otp/bloc/verify_otp_repository.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/logs/site_logs_repository.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/notes/site_notes_repository.dart';
import 'package:emcus_ipgsm_app/features/sites/bloc/devices/site_devices_repository.dart';
import 'package:emcus_ipgsm_app/core/services/auth_manager.dart';
import 'package:http/http.dart' as http;
import 'package:emcus_ipgsm_app/core/services/socket_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Core
  getIt.registerLazySingleton<AuthManager>(() => AuthManager());
  getIt.registerLazySingleton<http.Client>(() => http.Client());
  getIt.registerLazySingleton<SocketService>(() => SocketService());

  // Repositories
  getIt.registerLazySingleton<LogsRepository>(() => LogsRepository(authManager: getIt<AuthManager>()));
  getIt.registerLazySingleton<NotesRepository>(() => NotesRepository(authManager: getIt<AuthManager>()));
  getIt.registerLazySingleton<SitesRepository>(() => SitesRepository(authManager: getIt<AuthManager>(), client: getIt<http.Client>()));
  getIt.registerLazySingleton<SignInRepository>(() => SignInRepository(client: getIt<http.Client>()));
  getIt.registerLazySingleton<RegisterRepository>(() => RegisterRepository(client: getIt<http.Client>()));
  getIt.registerLazySingleton<SetPasswordRepository>(() => SetPasswordRepository(client: getIt<http.Client>()));
  getIt.registerLazySingleton<VerifyOtpRepository>(() => VerifyOtpRepository(client: getIt<http.Client>()));
  getIt.registerLazySingleton<SiteLogsRepository>(() => SiteLogsRepository(authManager: getIt<AuthManager>()));
  getIt.registerLazySingleton<SiteNoteRepository>(() => SiteNoteRepository(authManager: getIt<AuthManager>()));
  getIt.registerLazySingleton<SiteDevicesRepository>(() => SiteDevicesRepository(authManager: getIt<AuthManager>()));

  // Blocs
  getIt.registerFactory(() => LogsBloc(logsRepository: getIt<LogsRepository>(), socketService: getIt<SocketService>()));
  getIt.registerFactory(() => NotesBloc(notesRepository: getIt<NotesRepository>()));
  getIt.registerFactory(() => SitesBloc(sitesRepository: getIt<SitesRepository>()));
  getIt.registerFactory(() => SignInBloc(signInRepository: getIt<SignInRepository>(), authManager: getIt<AuthManager>()));
  getIt.registerFactory(() => RegisterBloc(registerRepository: getIt<RegisterRepository>()));
  getIt.registerFactory(() => SetPasswordBloc(setPasswordRepository: getIt<SetPasswordRepository>()));
  getIt.registerFactory(() => VerifyOtpBloc(verifyOtpRepository: getIt<VerifyOtpRepository>()));
  getIt.registerFactory(() => SiteLogsBloc(siteLogsRepository: getIt<SiteLogsRepository>(), socketService: getIt<SocketService>()));
  getIt.registerFactory(() => SiteNotesBloc(siteNoteRepository: getIt<SiteNoteRepository>()));
  getIt.registerFactory(() => SiteDevicesBloc(siteDevicesRepository: getIt<SiteDevicesRepository>()));
} 
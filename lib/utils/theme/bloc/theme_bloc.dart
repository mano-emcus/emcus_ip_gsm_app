import 'package:emcus_ipgsm_app/utils/theme/theme_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState()) {
    on<ThemeInitialized>(_onThemeInitialized);
    on<ThemeChanged>(_onThemeChanged);
  }

  Future<void> _onThemeInitialized(
    ThemeInitialized event,
    Emitter<ThemeState> emit,
  ) async {
    final savedThemeMode = await ThemeService.getThemeMode();
    final systemBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final isDarkMode = ThemeService.isDarkMode(
      savedThemeMode,
      systemBrightness,
    );

    emit(state.copyWith(themeMode: savedThemeMode, isDarkMode: isDarkMode));
  }

  Future<void> _onThemeChanged(
    ThemeChanged event,
    Emitter<ThemeState> emit,
  ) async {
    await ThemeService.saveThemeMode(event.themeMode);
    final systemBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final isDarkMode = ThemeService.isDarkMode(
      event.themeMode,
      systemBrightness,
    );

    emit(state.copyWith(themeMode: event.themeMode, isDarkMode: isDarkMode));
  }
}

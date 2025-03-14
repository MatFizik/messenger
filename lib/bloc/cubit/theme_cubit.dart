import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(Brightness.light));

  setTheme(Brightness brightness) {
    emit(ThemeState(brightness));
  }

  toggleTheme(bool isDarkTheme) {
    if (isDarkTheme) {
      emit(const ThemeState(Brightness.light));
    } else {
      emit(const ThemeState(Brightness.dark));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../localization_cache_helper.dart';

part 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCubit() : super(LocalizationInitial());
  Future<void> getSavedLanguage() async {
    final languageCode = await LocalizationCacheHelper.getLanguageCode();
    emit(ChangeLanguageState(locale: Locale(languageCode)));
  }

  Future<void> changeLanguage(String languageCode) async {
    LocalizationCacheHelper.setLanguageCode(languageCode);
    emit(ChangeLanguageState(locale: Locale(languageCode)));
  }
}

part of 'localization_cubit.dart';

@immutable
abstract class LocalizationState {}

class LocalizationInitial extends LocalizationState {}

class ChangeLanguageState extends LocalizationState {
  final Locale locale;
  ChangeLanguageState({
    required this.locale,
  });
}

part of 'settings_cubit.dart';

abstract class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class SettingsChanged extends SettingsState {}

final class SettingsUpdated extends SettingsState {}

final class SettingsError extends SettingsState {
  final String message;

  SettingsError(this.message);
}

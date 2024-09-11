part of 'main_cubit.dart';

abstract class MainState {
  AuthDataModel authDataModel;

  MainState({required this.authDataModel});
}

final class MainInitial extends MainState {
  MainInitial({required super.authDataModel});
}

final class MainUpdated extends MainState {
  MainUpdated({required super.authDataModel});
}

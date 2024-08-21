part of 'doctors_cubit.dart';

abstract class DoctorsState {
  void takeAction() {}
}

final class DoctorsInitial extends DoctorsState {}

final class DoctorsLoading extends DoctorsState {}

final class DoctorsSuccess extends DoctorsState {
  final List<DoctorModel?> doctors;

  DoctorsSuccess({required this.doctors});
}

final class DoctorsError extends DoctorsState {
  final String message;

  DoctorsError(this.message);
}

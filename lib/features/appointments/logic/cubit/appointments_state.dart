part of 'appointments_cubit.dart';

abstract class AppointmentsState {}

final class AppointmentsInitial extends AppointmentsState {}

final class AppointmentsLoading extends AppointmentsState {}

final class AppointmentsSuccess extends AppointmentsState {}

final class AppointmentsError extends AppointmentsState {
  final String? title;
  final String errorMessage;

  AppointmentsError(this.errorMessage, {this.title});
}

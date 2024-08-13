import 'package:el_sharq_clinic/features/appointments/data/local/models/appointment_model.dart';
import 'package:el_sharq_clinic/features/appointments/data/remote/appointments_firebase_services.dart';

class AppointmentsRepo {
  final AppointmentsFirebaseServices _appointmentsFirebaseServices;

  AppointmentsRepo(this._appointmentsFirebaseServices);

  Future<bool> addNewAppointment(
      AppointmentModel appointment, int clinicIndex) async {
    return await _appointmentsFirebaseServices.addAppointment(
        appointment, clinicIndex);
  }

  // Future<List<AppointmentModel>> getAppointments() async {
  //   return _appointmentsFirebaseServices.getAppointments();
  // }

  // Future<void> updateAppointment(Appointment appointment) async {
  //   return localDataSource.updateAppointment(appointment);
  // }

  // Future<void> deleteAppointment(Appointment appointment) async {
  //   return localDataSource.deleteAppointment(appointment);
  // }
}

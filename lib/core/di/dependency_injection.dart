import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/core/networking/firebase_factory.dart';
import 'package:el_sharq_clinic/features/appointments/data/local/repos/appointments_repo.dart';
import 'package:el_sharq_clinic/features/appointments/data/remote/appointments_firebase_services.dart';
import 'package:el_sharq_clinic/features/appointments/logic/cubit/appointments_cubit.dart';
import 'package:el_sharq_clinic/features/auth/logic/cubit/auth_cubit.dart';
import 'package:el_sharq_clinic/features/auth/data/local/repos/auth_repo.dart';
import 'package:el_sharq_clinic/features/auth/data/remote/auth_firebase_services.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupGetIt() {
  // Firebase Firestore instance
  FirebaseFirestore firestore = FirebaseFactory.getFirestoreInstance();

  // Firebase Services
  getIt.registerLazySingleton<AuthFirebaseServices>(
      () => AuthFirebaseServices(firestore));
  getIt.registerLazySingleton<AppointmentsFirebaseServices>(
      () => AppointmentsFirebaseServices(firestore));

  // Cubits
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));
  getIt.registerFactory<AppointmentsCubit>(() => AppointmentsCubit(getIt()));

  // Repos
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(getIt()));
  getIt
      .registerLazySingleton<AppointmentsRepo>(() => AppointmentsRepo(getIt()));
}

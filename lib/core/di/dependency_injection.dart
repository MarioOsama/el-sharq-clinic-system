import 'package:el_sharq_clinic/features/appointments/logic/cubit/appointments_cubit.dart';
import 'package:el_sharq_clinic/features/auth/logic/cubit/auth_cubit.dart';
import 'package:el_sharq_clinic/features/auth/data/local/repos/auth_repo.dart';
import 'package:el_sharq_clinic/features/auth/data/remote/auth_firebase_services.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupGetIt() {
  // Firebase Services
  getIt.registerLazySingleton<AuthFirebaseServices>(
      () => AuthFirebaseServices());

  // Cubits
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));
  getIt.registerFactory<AppointmentsCubit>(() => AppointmentsCubit());

  // Repos
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(getIt()));
}

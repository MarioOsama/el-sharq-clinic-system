import 'package:el_sharq_clinic/features/auth/logic/cubit/auth_cubit.dart';
import 'package:el_sharq_clinic/features/data/local/repos/auth_repo.dart';
import 'package:el_sharq_clinic/features/data/remote/auth_firebase_services.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupGetIt() {
  // Firebase Services
  getIt.registerLazySingleton<AuthFirebaseServices>(
      () => AuthFirebaseServices());

  // Cubits
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));

  // Repos
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(getIt()));
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/core/networking/firebase_factory.dart';
import 'package:el_sharq_clinic/features/cases/data/local/repos/case_history_repo.dart';
import 'package:el_sharq_clinic/core/networking/firebase_services.dart';
import 'package:el_sharq_clinic/features/cases/logic/cubit/case_history_cubit.dart';
import 'package:el_sharq_clinic/features/auth/logic/cubit/auth_cubit.dart';
import 'package:el_sharq_clinic/features/auth/data/local/repos/auth_repo.dart';
import 'package:el_sharq_clinic/features/auth/data/remote/auth_firebase_services.dart';
import 'package:el_sharq_clinic/features/doctors/logic/cubit/doctors_cubit.dart';
import 'package:el_sharq_clinic/features/owners/data/local/repos/owners_repo.dart';
import 'package:el_sharq_clinic/features/owners/data/local/repos/pets_repo.dart';
import 'package:el_sharq_clinic/features/owners/logic/cubit/owners_cubit.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupGetIt() {
  // Firebase Firestore instance
  FirebaseFirestore firestore = FirebaseFactory.getFirestoreInstance();

  // Firebase Services
  getIt.registerLazySingleton<FirebaseServices>(
      () => FirebaseServices(firestore));
  getIt.registerLazySingleton<AuthFirebaseServices>(
      () => AuthFirebaseServices(firestore));

  // Cubits
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt()));
  getIt.registerFactory<CaseHistoryCubit>(() => CaseHistoryCubit(getIt()));
  getIt.registerFactory<OwnersCubit>(() => OwnersCubit(getIt(), getIt()));
  getIt.registerFactory<DoctorsCubit>(() => DoctorsCubit());

  // Repos
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(getIt()));
  getIt.registerLazySingleton<CaseHistoryRepo>(() => CaseHistoryRepo(getIt()));
  getIt.registerLazySingleton<OwnersRepo>(() => OwnersRepo(getIt()));
  getIt.registerLazySingleton<PetsRepo>(() => PetsRepo(getIt()));
}

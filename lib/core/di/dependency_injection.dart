import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/core/logic/cubit/main_cubit.dart';
import 'package:el_sharq_clinic/core/networking/firebase_factory.dart';
import 'package:el_sharq_clinic/features/cases/data/local/repos/case_history_repo.dart';
import 'package:el_sharq_clinic/core/networking/firebase_services.dart';
import 'package:el_sharq_clinic/features/cases/logic/cubit/case_history_cubit.dart';
import 'package:el_sharq_clinic/features/auth/logic/cubit/auth_cubit.dart';
import 'package:el_sharq_clinic/features/auth/data/local/repos/auth_repo.dart';
import 'package:el_sharq_clinic/features/auth/data/remote/auth_firebase_services.dart';
import 'package:el_sharq_clinic/features/dashboard/data/repos/dashboard_repo.dart';
import 'package:el_sharq_clinic/features/dashboard/logic/cubit/dashboard_cubit.dart';
import 'package:el_sharq_clinic/features/doctors/data/repos/doctors_repo.dart';
import 'package:el_sharq_clinic/features/doctors/logic/cubit/doctors_cubit.dart';
import 'package:el_sharq_clinic/features/invoices/data/repos/invoices_repo.dart';
import 'package:el_sharq_clinic/features/invoices/logic/cubit/invoices_cubit.dart';
import 'package:el_sharq_clinic/features/owners/data/local/repos/owners_repo.dart';
import 'package:el_sharq_clinic/features/owners/data/local/repos/pets_repo.dart';
import 'package:el_sharq_clinic/features/owners/logic/cubit/owners_cubit.dart';
import 'package:el_sharq_clinic/features/products/data/repos/products_repo.dart';
import 'package:el_sharq_clinic/features/products/logic/cubit/products_cubit.dart';
import 'package:el_sharq_clinic/features/services/data/repos/services_repo.dart';
import 'package:el_sharq_clinic/features/services/logic/cubit/services_cubit.dart';
import 'package:el_sharq_clinic/features/settings/data/repos/settings_repo.dart';
import 'package:el_sharq_clinic/features/settings/logic/cubit/settings_cubit.dart';
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
  getIt.registerFactory<DashboardCubit>(() => DashboardCubit(getIt()));
  getIt.registerFactory<CaseHistoryCubit>(() => CaseHistoryCubit(getIt()));
  getIt.registerFactory<OwnersCubit>(() => OwnersCubit(getIt(), getIt()));
  getIt.registerFactory<DoctorsCubit>(() => DoctorsCubit(getIt()));
  getIt.registerFactory<ServicesCubit>(() => ServicesCubit(getIt()));
  getIt.registerFactory<ProductsCubit>(() => ProductsCubit(getIt()));
  getIt.registerFactory<InvoicesCubit>(() => InvoicesCubit(getIt()));
  getIt.registerFactory<SettingsCubit>(() => SettingsCubit(getIt()));
  getIt.registerFactory<MainCubit>(() => MainCubit());

  // Repos
  getIt.registerLazySingleton<AuthRepo>(() => AuthRepo(getIt()));
  getIt.registerLazySingleton<DashboardRepo>(() => DashboardRepo(getIt()));
  getIt.registerLazySingleton<CaseHistoryRepo>(() => CaseHistoryRepo(getIt()));
  getIt.registerLazySingleton<OwnersRepo>(() => OwnersRepo(getIt()));
  getIt.registerLazySingleton<PetsRepo>(() => PetsRepo(getIt()));
  getIt.registerLazySingleton<DoctorsRepo>(() => DoctorsRepo(getIt()));
  getIt.registerLazySingleton<ServicesRepo>(() => ServicesRepo(getIt()));
  getIt.registerLazySingleton<ProductsRepo>(() => ProductsRepo(getIt()));
  getIt.registerLazySingleton<InvoicesRepo>(() => InvoicesRepo(getIt()));
  getIt.registerLazySingleton<SettingsRepo>(() => SettingsRepo(getIt()));
}

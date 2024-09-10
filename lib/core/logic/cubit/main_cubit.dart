import 'package:bloc/bloc.dart';
import 'package:el_sharq_clinic/core/models/auth_data_model.dart';
import 'package:el_sharq_clinic/features/products/data/models/product_model.dart';
import 'package:el_sharq_clinic/features/services/data/models/service_model.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  // Variables
  AuthDataModel authData = AuthDataModel.empty();
  bool isSelableItemListsLoaded = false;
  List<ProductModel> medicinesList = [];
  List<ProductModel> accessorieList = [];
  List<ServiceModel> servicesList = [];

  // Functions
  void updateMedicinesList(List<ProductModel> medicines) {
    medicinesList = medicines;
  }

  void updateAccessoriesList(List<ProductModel> accessories) {
    accessorieList = accessories;
  }

  void updateServicesList(List<ServiceModel> services) {
    servicesList = services;
  }

  void updateAuthData(AuthDataModel authData) {
    this.authData = authData;
  }
}

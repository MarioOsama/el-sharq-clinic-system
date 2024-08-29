import 'package:el_sharq_clinic/core/networking/firebase_services.dart';
import 'package:el_sharq_clinic/features/services/data/models/service_model.dart';

class ServicesRepo {
  final FirebaseServices _firebaseServices;

  ServicesRepo(this._firebaseServices);

  final String collectionName = 'services';

  Future<List<ServiceModel>> getServices(
      int clinicIndex, final String? lastId) async {
    return await _firebaseServices.getItems<ServiceModel>(
      collectionName,
      clinicIndex: clinicIndex,
      fromFirestore: ServiceModel.fromFirestore,
      lastId: lastId,
      descendingOrder: false,
      limit: -1,
    );
  }

  Future<bool> addService(int clinicIndex, ServiceModel service) async {
    return await _firebaseServices.addItem(
      collectionName,
      clinicIndex: clinicIndex,
      itemModel: service,
      id: service.id,
      toFirestore: service.toFirestore,
    );
  }

  Future<bool> updateService(int clinicIndex, ServiceModel service) async {
    return await _firebaseServices.updateItem(
      collectionName,
      itemModel: service,
      id: service.id,
      toFirestore: service.toFirestore,
      clinicIndex: clinicIndex,
    );
  }

  Future<bool> deleteService(int clinicIndex, ServiceModel service) async {
    return await _firebaseServices.deleteItem(
      collectionName,
      id: service.id,
      clinicIndex: clinicIndex,
    );
  }
}

import 'package:el_sharq_clinic/core/networking/firebase_services.dart';
import 'package:el_sharq_clinic/features/services/data/models/service_model.dart';

class ServicesRepo {
  final FirebaseServices _firebaseServices;

  ServicesRepo(this._firebaseServices);

  final String collectionName = 'services';

  Future<List<ServiceModel>> getServices(
      int clinicIndex, final String? lastId) async {
    return await _firebaseServices.getItems<ServiceModel>(collectionName,
        clinicIndex: clinicIndex,
        fromFirestore: ServiceModel.fromFirestore,
        lastId: lastId);
  }

  Future<bool> addService(int clinicIndex, ServiceModel service) async {
    // Check if id already exists
    final docs = await _firebaseServices.getItemsByIds(collectionName,
        clinicIndex: clinicIndex,
        ids: [service.title],
        fromFirestore: ServiceModel.fromFirestore);
    if (docs.isNotEmpty) {
      return false;
    }

    return await _firebaseServices.addItem(
      collectionName,
      clinicIndex: clinicIndex,
      itemModel: service,
      id: service.title,
      toFirestore: service.toFirestore,
    );
  }
}

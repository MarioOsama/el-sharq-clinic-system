import 'package:el_sharq_clinic/core/networking/firebase_services.dart';
import 'package:el_sharq_clinic/features/products/data/models/product_model.dart';

class ProductsRepo {
  final FirebaseServices _firebaseServices;

  ProductsRepo(this._firebaseServices);

  Future<List<ProductModel>> getProducts(
      {required int clinicIndex,
      required String collection,
      String? lastId}) async {
    return _firebaseServices.getItems<ProductModel>(
      collection,
      lastId: lastId,
      clinicIndex: clinicIndex,
      fromFirestore: ProductModel.fromFirestore,
      descendingOrder: false,
      limit: -1,
    );
  }

  Future<bool> addProduct(
      {required int clinicIndex,
      required String collection,
      required ProductModel product}) async {
    return _firebaseServices.addItem(
      collection,
      clinicIndex: clinicIndex,
      itemModel: product,
      id: product.id,
      toFirestore: product.toFirestore,
    );
  }

  Future<bool> updateProduct(
      {required int clinicIndex,
      required String collection,
      required ProductModel product}) async {
    return _firebaseServices.updateItem(
      collection,
      clinicIndex: clinicIndex,
      itemModel: product,
      id: product.id,
      toFirestore: product.toFirestore,
    );
  }

  Future<bool> deleteProduct(
      {required int clinicIndex,
      required String collection,
      required String id}) async {
    return _firebaseServices.deleteItem(
      collection,
      clinicIndex: clinicIndex,
      id: id,
    );
  }
}

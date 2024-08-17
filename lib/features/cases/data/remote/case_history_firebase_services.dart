import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/core/helpers/extensions.dart';
import 'package:el_sharq_clinic/features/cases/data/local/models/case_history_model.dart';

class CaseHistoryFirebaseServices {
  CaseHistoryFirebaseServices(this._firestore);

  final FirebaseFirestore _firestore;

  // final FirestoreCache _firestoreCache = FirestoreCache;

  Future<List<CaseHistoryModel>> getAllCaseHistories({
    required int clinicIndex,
    String? lastCaseId,
    int limit = 21,
  }) async {
    // Get the clinic document reference
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final clinicCaseHistoryCollection = clinicDoc.reference.collection('cases');

    // Create the query with pagination
    Query query = clinicCaseHistoryCollection
        .orderBy(FieldPath.documentId, descending: true)
        .limit(limit);

    // If there is a lastCase, start after its document ID
    if (lastCaseId != null) {
      final String lastIdInCollection = await clinicCaseHistoryCollection
          .orderBy(FieldPath.documentId)
          .limit(1)
          .get()
          .then((value) => value.docs.first.id);

      if (lastIdInCollection == lastCaseId) {
        return [];
      }

      query = query.startAfter([lastCaseId]);
    }

    // Execute the query and get the documents
    final querySnapshot = await query.get();

    // Map the documents to your model
    final caseHistories = querySnapshot.docs
        .map((doc) => CaseHistoryModel.fromFirestore(doc))
        .toList();

    // Return the list of case histories
    return caseHistories;
  }

  Future<String?> getFirstCaseId(
      {required int clinicIndex, required bool descendingOrder}) async {
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final clinicCaseHistoryCollection = clinicDoc.reference.collection('cases');
    final String? lastCaseHistoryId = await clinicCaseHistoryCollection
        .orderBy(FieldPath.documentId, descending: descendingOrder)
        .limit(1)
        .get()
        .then((value) {
      try {
        return value.docs.first.id;
      } catch (e) {
        return null;
      }
    });

    return lastCaseHistoryId;
  }

  Future<bool> addCase(CaseHistoryModel caseHistory, int clinicIndex) async {
    // Get clinic cases document
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final clinicCaseHistoryCollection = clinicDoc.reference.collection('cases');
    // Get last CaseHistory to generate new id

    final String? lastCaseHistoryId = await clinicCaseHistoryCollection
        .orderBy(FieldPath.documentId, descending: true)
        .limit(1)
        .get()
        .then((value) {
      try {
        return value.docs.first.id;
      } catch (e) {
        return null;
      }
    });

    String newId = 'CSE000';

    if (lastCaseHistoryId != null) {
      newId = (int.parse(lastCaseHistoryId.replaceAll('CSE', '')) + 1)
          .toString()
          .toId(3, prefix: 'CSE');
    }

    // Add new CaseHistory to clinic CaseHistory collection
    try {
      await clinicCaseHistoryCollection
          .doc(newId)
          .set(caseHistory.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateCase(CaseHistoryModel caseHistory, int clinicIndex) async {
    // Get clinic cases document
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final clinicCaseHistoryCollection = clinicDoc.reference.collection('cases');
    // Update CaseHistory in clinic CaseHistory collection
    try {
      await clinicCaseHistoryCollection
          .doc(caseHistory.id)
          .update(caseHistory.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteCase(String caseId, int clinicIndex) async {
    // Get clinic cases document
    final clinicDoc = await _getClinicDoc(clinicIndex);
    final clinicCaseHistoryCollection = clinicDoc.reference.collection('cases');
    try {
      await clinicCaseHistoryCollection.doc(caseId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> _getClinicDoc(
      int clinicIndex) async {
    return await _firestore
        .collection('clinics')
        .doc('clinic$clinicIndex')
        .get();
  }
}

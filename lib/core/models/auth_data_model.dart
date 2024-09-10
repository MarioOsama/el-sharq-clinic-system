import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_sharq_clinic/features/auth/data/local/models/user_model.dart';

class AuthDataModel {
  final UserModel userModel;
  final int clinicIndex;
  final String clinicName;
  final String language;
  final String theme;
  final double lowStockLimit;

  AuthDataModel(
      {required this.clinicIndex,
      required this.userModel,
      required this.clinicName,
      required this.language,
      required this.theme,
      required this.lowStockLimit});

  AuthDataModel copyWith({
    int? clinicIndex,
    UserModel? userModel,
    String? clinicName,
    String? language,
    String? theme,
    double? lowStockLimit,
  }) {
    return AuthDataModel(
      clinicIndex: clinicIndex ?? this.clinicIndex,
      userModel: userModel ?? this.userModel,
      clinicName: clinicName ?? this.clinicName,
      language: language ?? this.language,
      theme: theme ?? this.theme,
      lowStockLimit: lowStockLimit ?? this.lowStockLimit,
    );
  }

  factory AuthDataModel.empty() {
    return AuthDataModel(
      clinicIndex: 0,
      userModel: UserModel.empty(),
      clinicName: '',
      language: 'en',
      theme: 'light',
      lowStockLimit: 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'clinicIndex': clinicIndex,
      'userModel': userModel.toFirestore(),
      'clinicName': clinicName,
      'language': language,
      'theme': theme,
      'lowStockLimit': lowStockLimit,
    };
  }

  factory AuthDataModel.fromFirestore(QueryDocumentSnapshot<Object?> doc) {
    return AuthDataModel(
      clinicIndex: doc['clinicIndex'],
      userModel: UserModel.fromFirestore(doc['userModel']),
      clinicName: doc['clinicName'],
      language: doc['language'],
      theme: doc['theme'],
      lowStockLimit: doc['lowStockLimit'],
    );
  }

  @override
  String toString() {
    return 'AuthDataModel(clinicIndex: $clinicIndex, userModel: $userModel, clinicName: $clinicName, language: $language, theme: $theme, lowStockLimit: $lowStockLimit)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthDataModel &&
        other.clinicIndex == clinicIndex &&
        other.userModel == userModel &&
        other.clinicName == clinicName &&
        other.language == language &&
        other.theme == theme &&
        other.lowStockLimit == lowStockLimit;
  }
}

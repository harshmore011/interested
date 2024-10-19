
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends User {

  const UserModel({required super.name, required super.email, required super.isEmailVerified});

  factory UserModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    logger.log("","Onboarding model data: $data");
    return UserModel(
      name: data?['name'],
      email: data?['email'],
      isEmailVerified: data?['isEmailVerified']
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "email": email,
      "isEmailVerified": isEmailVerified,
    };
  }
  
}
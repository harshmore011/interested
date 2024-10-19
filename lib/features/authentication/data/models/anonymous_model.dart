
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../domain/entities/anonymous_entity.dart';

class AnonymousModel extends Anonymous {

  const AnonymousModel();

  factory AnonymousModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    logger.log("","Onboarding model data: $data");
    return AnonymousModel(
     /* name: data?['name'],
      email: data?['email'],
      isEmailVerified: data?['isEmailVerified']*/
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      /*"name": name,
      "email": email,
      "isEmailVerified": isEmailVerified,*/
    };
  }
  
}
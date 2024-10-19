
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../domain/entities/publisher_entity.dart';

class PublisherModel extends Publisher {

  const PublisherModel({required super.name, required super.email, required super.isEmailVerified
  ,required super.about, required super.followersCount,});

  factory PublisherModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    logger.log("","Onboarding model data: $data");
    return PublisherModel(
      name: data?['name'],
      email: data?['email'],
      isEmailVerified: data?['isEmailVerified'],
      about: data?['about'],
      followersCount: data?['followersCount'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "email": email,
      "isEmailVerified": isEmailVerified,
      "about": about,
      "followersCount": followersCount,
    };
  }
  
}
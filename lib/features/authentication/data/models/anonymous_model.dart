
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../domain/entities/anonymous_entity.dart';

class AnonymousModel extends Anonymous {

  const AnonymousModel({required super.uid, required super.creationTime, required super.lastSignInTime, required super.refreshToken});

/*  factory AnonymousModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    logger.log("","Onboarding model data: $data");
    return fromJson(data!);
  }*/

  factory AnonymousModel.fromJson(Map<String, dynamic> json) {
    return AnonymousModel(
      uid: json['uid'],
      creationTime: DateTime.parse(json['creationTime'].toDate().toString()),
      lastSignInTime: DateTime.parse(json['lastSignInTime'].toDate().toString()),
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      "creationTime": creationTime,
      "lastSignInTime": lastSignInTime,
      "refreshToken": refreshToken,
    };
  }
  
}
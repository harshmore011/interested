
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

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
      // creationTime: DateTime.parse(json['creationTime']),
      creationTime: DateTime.parse(json['creationTime'] is Timestamp ?
      json['creationTime'].toDate().toString() : json['creationTime']),
      // lastSignInTime: DateTime.parse(json['lastSignInTime']),
      lastSignInTime: DateTime.parse(json['lastSignInTime']  is Timestamp ?
      json['lastSignInTime'].toDate().toString()  : json['lastSignInTime']),
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "uid": uid,
      // "creationTime": creationTime,
      // "lastSignInTime": lastSignInTime,
      "creationTime": creationTime.toString(),
      "lastSignInTime": lastSignInTime.toString(),
      "refreshToken": refreshToken,
    };
  }
  
}
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

import '../../domain/entities/auth.dart';
import '../../domain/entities/publisher_entity.dart';

class PublisherModel extends Publisher {

   PublisherModel({
    required super.name,
    required super.email,
    required super.isEmailVerified,
    required super.about,
    required super.followersCount,
    required super.creationTime,
    required super.lastSignInTime,
    required super.authProvider,
    required super.refreshToken,
    required super.uid,
  });

/*  @override
  PublisherModel copyWith({
    String? name,
    String? email,
    bool? isEmailVerified,
    String? about,
    int? followersCount,
    DateTime? creationTime,
    DateTime? lastSignInTime,
    AuthenticationProvider? authProvider,
    String? refreshToken,
    String? uid,
  }) {
    return PublisherModel(
      name: name ?? this.name,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      about: about ?? this.about,
      followersCount: followersCount ?? this.followersCount,
      creationTime: creationTime ?? this.creationTime,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
      authProvider: authProvider ?? this.authProvider,
      refreshToken: refreshToken ?? this.refreshToken,
      uid: uid ?? this.uid,
    );
  }*/

  factory PublisherModel.fromJson(Map<String, dynamic> json) {
    PublisherModel publisherModel = PublisherModel(
      name: json['name'],
      email: json['email'],
      isEmailVerified: json['isEmailVerified'],
      about: json['about'],
      followersCount: json['followersCount'],
      // creationTime: DateTime.parse(json['creationTime']),
      creationTime: DateTime.parse(json['creationTime'] is Timestamp ?
      json['creationTime'].toDate().toString() : json['creationTime']),
      // lastSignInTime: DateTime.parse(json['lastSignInTime']),
      lastSignInTime: DateTime.parse(json['lastSignInTime']  is Timestamp ?
      json['lastSignInTime'].toDate().toString()  : json['lastSignInTime']),
      authProvider: AuthenticationProvider.values.byName(json['authProvider']),
      refreshToken: json['refreshToken'],
      uid: json['uid'],
    );

    publisherModel.personRoles.addAll(json['personRoles']
        .map<PersonRole>((role) => PersonRole.values.byName(role))
        .toList() as List<PersonRole>);

    return publisherModel;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "isEmailVerified": isEmailVerified,
      "about": about,
      "followersCount": followersCount,
      // "creationTime": creationTime,
      "creationTime": creationTime.toString(),
      // "lastSignInTime": lastSignInTime,
      "lastSignInTime": lastSignInTime.toString(),
      "authProvider": authProvider.name,
      "refreshToken": refreshToken,
      "uid": uid,
      "personRoles": personRoles.map<String>((role) => role.name).toList(),
    };
  }

  factory PublisherModel.fromEntity(Publisher entity) {
    PublisherModel publisherModel = PublisherModel(
      name: entity.name,
      email: entity.email,
      isEmailVerified: entity.isEmailVerified,
      about: entity.about,
      followersCount: entity.followersCount,
      creationTime: entity.creationTime,
      lastSignInTime: entity.lastSignInTime,
      authProvider: entity.authProvider,
      refreshToken: entity.refreshToken,
      uid: entity.uid,
    );
    publisherModel.setPersonRoles(entity.getPersonRoles());
    return publisherModel;
  }

  Publisher toEntity() {
    Publisher publisher = Publisher(
      name: name,
      email: email,
      isEmailVerified: isEmailVerified,
      about: about,
      followersCount: followersCount,
      creationTime: creationTime,
      lastSignInTime: lastSignInTime,
      authProvider: authProvider,
      refreshToken: refreshToken,
      uid: uid,
    );
    publisher.setPersonRoles(personRoles);
    return publisher;
  }

}

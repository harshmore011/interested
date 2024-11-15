import 'package:equatable/equatable.dart';

import 'auth.dart';

class Publisher extends Equatable {
  final String name;
  final String email;
  final bool isEmailVerified;
  final String about;
  final int followersCount;
  final DateTime creationTime;
  final DateTime lastSignInTime;
  final AuthenticationProvider authProvider;
  final String refreshToken;
  final String uid;
  final List<PersonRole> personRoles = [];

  // final List<String> followers;

  Publisher({
    required this.name,
    required this.email,
    required this.isEmailVerified,
    required this.about,
    required this.followersCount,
    required this.creationTime,
    required this.lastSignInTime,
    required this.authProvider,
    required this.refreshToken,
    required this.uid,
  });

  List<PersonRole> getPersonRoles() {
    return personRoles;
  }

  setPersonRoles(List<PersonRole> personRoles) {
    this.personRoles.addAll(personRoles);
  }

  @override
  List<Object?> get props => [
        name,
        email,
        isEmailVerified,
        about,
        followersCount,
        creationTime,
        lastSignInTime,
        authProvider,
        refreshToken,
        uid,
      ];

  Publisher copyWith({
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
    return Publisher(
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
  }

}

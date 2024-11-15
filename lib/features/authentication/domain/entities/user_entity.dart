import 'package:equatable/equatable.dart';

import 'auth.dart';

class User extends Equatable {
  final String name;
  final String email;
  final bool isEmailVerified;
  final DateTime creationTime;
  final DateTime lastSignInTime;
  final AuthenticationProvider authProvider;
  final String refreshToken;
  final String uid;
  final List<PersonRole> personRoles = [];

  // final List<String> followedPublishers;
  // final List<String> favoritePublishers;

  User({
    required this.name,
    required this.email,
    required this.isEmailVerified,
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
        creationTime,
        lastSignInTime,
        authProvider,
        refreshToken,
        uid,
    personRoles,
      ];

}

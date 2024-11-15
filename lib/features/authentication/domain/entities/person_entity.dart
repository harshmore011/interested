
import 'package:equatable/equatable.dart';
import 'package:interested/features/authentication/domain/entities/auth.dart';

enum PersonRole {
  admin,
  anonymous,
  user,
  publisher
}

class Person extends Equatable {

  final String? name;
  final String? email;
  final DateTime creationTime;
  final DateTime lastSignInTime;
  final bool isEmailVerified;
  final AuthenticationProvider? authProvider;
  final List<PersonRole> roles = const [];

  const Person({required this.name, required this.email, required this.creationTime, required this.lastSignInTime, required this.isEmailVerified, required this.authProvider});



  @override
  List<Object?> get props => [];

}

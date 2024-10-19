import 'package:equatable/equatable.dart';

enum AuthenticationProvider {
  emailPassword,
  google
}

class AuthParams extends Equatable {

  final EmailAuthCredential? credential;
  final AuthenticationProvider authProvider;

  const AuthParams({required this.authProvider, this.credential});
  // const AuthParams(this.authProvider, {this.credential});


  @override
  List<Object?> get props => [credential,authProvider];

}

class EmailAuthCredential extends Equatable {

  final String email;
  final String password;

  const EmailAuthCredential({required this.password, required this.email});


  @override
  List<Object?> get props => [password,email];

}

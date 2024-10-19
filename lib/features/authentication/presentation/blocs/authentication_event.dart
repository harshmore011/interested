
import 'package:equatable/equatable.dart';

import '../../domain/entities/auth.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props {
    return [];
  }
}

class SignUpPageEvent extends AuthenticationEvent{}

class SignInPageEvent extends AuthenticationEvent{}

class AnonymousSignInEvent extends AuthenticationEvent{}

class AnonymousToUserEvent extends AuthenticationEvent{

  final AuthParams params;

  AnonymousToUserEvent({required this.params});

  @override
  List<Object> get props {
    return [params];
  }
}

class UserSignInEvent extends AuthenticationEvent {
  final AuthParams params;

  UserSignInEvent({required this.params});
  @override
  List<Object> get props {
    return [params];
  }}

class UserSignUpEvent extends AuthenticationEvent {
  final AuthParams params;

  UserSignUpEvent({required this.params});
  @override
  List<Object> get props {
    return [params];
  }}

class PublisherSignUpEvent extends AuthenticationEvent {
  final AuthParams params;

  PublisherSignUpEvent({required this.params});
  @override
  List<Object> get props {
    return [params];
  }}

class PublisherSignInEvent extends AuthenticationEvent {
  final AuthParams params;

  PublisherSignInEvent({required this.params});
  @override
  List<Object> get props {
    return [params];
  }}

class VerifyEmailEvent extends AuthenticationEvent{}

// class ForgotPasswordEvent extends AuthenticationEvent{}

class SignOutEvent extends AuthenticationEvent{}

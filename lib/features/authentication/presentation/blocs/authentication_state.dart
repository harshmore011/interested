
import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  @override
  List<Object> get props {
    return [];
  }
}

class InitialState extends AuthenticationState{}

class LoadingState extends AuthenticationState{}

class SignUpPageState extends AuthenticationState{}

class SignInPageState extends AuthenticationState{}

class AnonymousSignedInState extends AuthenticationState {}

class AnonymousLinkedToUserState extends AuthenticationState {}

class UserSignedUpState extends AuthenticationState {}

class UserSignedInState extends AuthenticationState {}

class PublisherSignedUpState extends AuthenticationState {}

class PublisherSignedInState extends AuthenticationState {}

class VerificationEmailSentState extends AuthenticationState {}

class SignedOutState extends AuthenticationState {}


class FailureState extends AuthenticationState{
  final String message;

  FailureState({required this.message});

  @override
  List<Object> get props {
    return [message];
  }
}


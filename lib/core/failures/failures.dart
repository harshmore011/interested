
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {

  @override
  List<Object?> get props => [];

}

class OfflineFailure extends Failure {}

class ServerFailure extends Failure {}

class DataNotFoundFailure extends Failure {}

class NoUserFailure extends Failure {}

class UnAuthorizedFailure extends Failure {}

class EmailAlreadyInUseFailure extends Failure {}

class InvalidEmailFailure extends Failure {}

class WeakPasswordFailure extends Failure {}

class TooManyRequestsFailure extends Failure {}

class WrongPasswordFailure extends Failure {}

class InvalidCredentialsFailure extends Failure {}

class MissingRequiredArgumentsFailure extends Failure {}
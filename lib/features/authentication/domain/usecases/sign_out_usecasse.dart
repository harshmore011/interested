import 'package:dartz/dartz.dart';

import '../../../../core/failures/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/anonymous_entity.dart';
import '../repositories/authentication_repository.dart';

class SignOutUseCase extends Usecase<Unit, Unit> {
  final AuthenticationRepository repository;

  SignOutUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Unit params) async {
    return await repository.signOut();
  }
}

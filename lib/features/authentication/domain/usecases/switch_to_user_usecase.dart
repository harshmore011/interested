import 'package:dartz/dartz.dart';

import '../../../../core/failures/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/authentication_repository.dart';

class SwitchToUserUseCase extends Usecase<Unit, Unit> {
  final AuthenticationRepository repository;

  SwitchToUserUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Unit params) async {
    return await repository.switchToUser();
  }
}

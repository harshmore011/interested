import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth.dart';
import '../entities/publisher_entity.dart';
import '../repositories/authentication_repository.dart';

class PublisherSignInUseCase extends Usecase<Publisher, AuthParams> {
  final AuthenticationRepository repository;

  PublisherSignInUseCase(this.repository);

  @override
  Future<Either<Failure, Publisher>> call(AuthParams params) async {
    return await repository.publisherSignIn(params);
  }
}

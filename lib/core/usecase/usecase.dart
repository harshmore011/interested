
import 'package:dartz/dartz.dart';
import 'package:interested/core/failures/failures.dart';

abstract class Usecase<Type, Params/*, Params2*/> {

  Future<Either<Failure,Type>> call(Params params);

}
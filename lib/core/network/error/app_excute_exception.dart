import 'package:dartz/dartz.dart';
import 'app_exceptions.dart';

class AppExcute<R> {
  Future<Either<AppCoreException, R>> repositoryExcute({
    required Future<R> Function() onCall,
    required String nameMethod,
  }) async {
    try {
      return Right(await onCall.call());
    } on AppCoreException catch (err) {
      return Left(err);
    } catch (error) {
      return Left(ObjectException(
        error: error,
        method: nameMethod,
      ));
    }
  }
}

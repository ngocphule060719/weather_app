import 'package:weather_app/core/error/failures.dart';

abstract class Usecase<Type, Params> {
  Future<(Failure, Type)> call(Params params);
}

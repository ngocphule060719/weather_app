import 'package:weather_app/core/utils/result.dart';

abstract class Usecase<Type, Params> {
  Future<Result<Type>> call(Params params);
}

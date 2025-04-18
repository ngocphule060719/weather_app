import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? message;

  const Failure([this.message]);

  String get defaultDisplayMessage => 'Something went wrong at our end!';

  @override
  List<Object?> get props => [message];
}

class GeneralFailure extends Failure {
  const GeneralFailure([super.message]);
}

abstract class Failure {
  String get message;
}

class GeneralFailure implements Failure {
  @override
  String get message => 'Something went wrong at our end!';

  final String errorMessage;

  const GeneralFailure([this.errorMessage = '']);
}

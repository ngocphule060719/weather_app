abstract class Failure {
  String get message;
}

class GeneralFailure implements Failure {
  @override
  String get message => 'Something went wrong at our end!';

  const GeneralFailure();
}

class Result<T> {
  const Result();

  factory Result.success(T data) => Success(data);
  factory Result.error(Object error) => Error(error);
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Error extends Result<Never> {
  final Object error;
  const Error(this.error);
}

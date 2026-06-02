abstract interface class IUseCaseContract<T, Params extends Object?> {
  Future<T> call(Params params);
}

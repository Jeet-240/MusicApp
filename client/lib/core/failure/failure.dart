class AppFailure{
  final String message;
  AppFailure([this.message = "sorry, an unexpected error occured!"]);

  @override
  String toString() {
    return 'AppFailure{message: $message}';
  }
}
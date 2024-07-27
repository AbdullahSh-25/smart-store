class NetworkException implements Exception {
  final NetworkExceptionReason reason;
  final Exception exception;

  const NetworkException({required this.reason, required this.exception});
}

enum NetworkExceptionReason {
  canceled('Request canceled!'),
  timedOut('Request timed out!'),
  responseError('Server response error!'),
  noInternet('No internet connection'),
  serverError('Server error!'),
  unknown('Error occurred');

  const NetworkExceptionReason(this.message);

  final String message;
}
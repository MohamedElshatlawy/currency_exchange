class ResponseError {
  static String getErrorMessage(int statusCode, dynamic data) {
    switch (statusCode) {
      case 400:
        return 'error_400';
      case 401:
        return 'error_401';
      case 403:
        return 'error_403';
      case 404:
        return 'error_404';
      case 500:
        return 'error_500';
      default:
        return 'error_unknown';
    }
  }
}

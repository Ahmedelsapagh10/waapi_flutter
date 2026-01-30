/// Exception thrown when Waapi returns an error.
///
/// استثناء يتم رميه عندما تعيد Waapi خطأ.
class WaapiException implements Exception {
  /// The error message.
  ///
  /// رسالة الخطأ.
  final String message;

  /// The HTTP status code (if applicable).
  ///
  /// كود حالة HTTP (إذا وجد).
  final int? statusCode;

  /// The raw response data.
  ///
  /// بيانات الاستجابة الخام.
  final dynamic data;

  WaapiException({required this.message, this.statusCode, this.data});

  @override
  String toString() =>
      'WaapiException(statusCode: $statusCode, message: $message)';
}

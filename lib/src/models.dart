/// Represents a generic response from Waapi.
///
/// تمثل استجابة عامة من Waapi.
class WaapiResponse<T> {
  /// The status of the response (e.g., 'success', 'error').
  ///
  /// حالة الاستجابة (مثلاً: 'success', 'error').
  final String status;

  /// A descriptive message from the API.
  ///
  /// رسالة وصفية من الـ API.
  final String? message;

  /// The data returned by the API (generic).
  ///
  /// البيانات التي أعادتها الـ API (عامة).
  final T? data;

  WaapiResponse({required this.status, this.message, this.data});

  factory WaapiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    return WaapiResponse<T>(
      status: json['status'] as String? ?? 'unknown',
      message: json['message'] as String?,
      data: json.containsKey('data') && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
    );
  }

  @override
  String toString() =>
      'WaapiResponse(status: $status, message: $message, data: $data)';
}

/// Represents a location object to be sent.
///
/// تمثل كائن موقع ليتم إرساله.
class WaapiLocation {
  /// Latitude of the location.
  ///
  /// خط العرض للموقع.
  final double latitude;

  /// Longitude of the location.
  ///
  /// خط الطول للموقع.
  final double longitude;

  /// Name of the location (title).
  ///
  /// اسم الموقع (العنوان).
  final String name;

  /// Address of the location (details).
  ///
  /// عنوان الموقع (التفاصيل).
  final String address;

  WaapiLocation({
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.address,
  });

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'name': name,
    'address': address,
  };
}

/// Represents a contact card (vCard) to be sent.
///
/// تمثل بطاقة جهة اتصال (vCard) ليتم إرسالها.
class WaapiContact {
  /// The name of the contact.
  ///
  /// اسم جهة الاتصال.
  final String name;

  /// The phone number of the contact.
  ///
  /// رقم هاتف جهة الاتصال.
  final String phoneNumber;

  /// The organization of the contact.
  ///
  /// مؤسسة جهة الاتصال.
  final String? organization;

  WaapiContact({
    required this.name,
    required this.phoneNumber,
    this.organization,
  });

  /// Generates a simple vCard string.
  ///
  /// تنشئ نص vCard بسيط.
  String toVCard() {
    return 'BEGIN:VCARD\n'
        'VERSION:3.0\n'
        'FN:$name\n'
        'TEL;TYPE=CELL:$phoneNumber\n'
        '${organization != null ? 'ORG:$organization\n' : ''}'
        'END:VCARD';
  }
}

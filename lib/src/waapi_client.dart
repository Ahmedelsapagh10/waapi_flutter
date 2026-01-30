import 'package:dio/dio.dart';
import 'models.dart';
import 'exceptions.dart';

/// Client to interact with the Waapi WhatsApp Gateway API.
///
/// عميل للتفاعل مع بوابة Waapi WhatsApp API.
class WaapiClient {
  final Dio _dio;
  final String baseUrl;
  final String appKey;
  final String authKey;

  /// Creates a new instance of [WaapiClient].
  ///
  /// [baseUrl]: The base URL of the API (e.g., https://waapi.octopusteam.net).
  /// [appKey]: The application key.
  /// [authKey]: The authentication key.
  ///
  /// ينشئ نسخة جديدة من [WaapiClient].
  ///
  /// [baseUrl]: رابط الـ API الأساسي.
  /// [appKey]: مفتاح التطبيق.
  /// [authKey]: مفتاح المصادقة.
  WaapiClient({
    required this.baseUrl,
    required this.appKey,
    required this.authKey,
    BaseOptions? dioOptions,
  }) : _dio = Dio(dioOptions ?? BaseOptions()) {
    _dio.options.baseUrl = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    // Authentication is passed in BODY (FormData), so no global headers needed for keys.
    _dio.options.headers['Accept'] = 'application/json';
  }

  /// Helper to handle Dio errors and convert them to [WaapiException].
  Future<T> _handleRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (e) {
      String message = 'Unknown error occurred';
      if (e.response?.data is Map &&
          (e.response?.data as Map).containsKey('message')) {
        message = e.response?.data['message'];
      } else if (e.message != null) {
        message = e.message!;
      }

      throw WaapiException(
        message: message,
        statusCode: e.response?.statusCode,
        data: e.response?.data,
      );
    } catch (e) {
      throw WaapiException(message: e.toString());
    }
  }

  /// Adds authentication fields to the form data.
  FormData _createFormData(Map<String, dynamic> fields) {
    final map = {'appkey': appKey, 'authkey': authKey, ...fields};
    return FormData.fromMap(map);
  }

  /// Sends a text message to a specific number.
  ///
  /// [chatId]: The phone number with country code (e.g., 201xxxxxxxxx).
  /// [message]: The text message to send.
  Future<WaapiResponse> sendText({
    required String chatId,
    required String message,
  }) async {
    return _handleRequest(() async {
      final data = _createFormData({'to': chatId, 'message': message});

      final response = await _dio.post('api/create-message', data: data);
      return WaapiResponse.fromJson(response.data, null);
    });
  }

  /// Sends a media message (Image, Video, Document).
  ///
  /// [chatId]: The phone number.
  /// [mediaUrl]: The URL of the media file.
  /// [caption]: Optional caption (sent as message).
  /// Sends a media message (Image, Video, Document).
  ///
  /// [chatId]: The phone number.
  /// [mediaUrl]: The URL of the media file (direct link).
  /// [caption]: Optional caption (sent as message).
  ///
  /// يرسل رسالة وسائط (صورة، فيديو، مستند).
  Future<WaapiResponse> sendMedia({
    required String chatId,
    required String mediaUrl,
    String? caption,
  }) async {
    return _handleRequest(() async {
      final data = _createFormData({
        'to': chatId,
        'message': caption ?? '',
        'file': mediaUrl,
      });

      final response = await _dio.post('api/create-message', data: data);
      return WaapiResponse.fromJson(response.data, null);
    });
  }

  /// Sends a sticker message.
  ///
  /// [chatId]: The phone number.
  /// [stickerUrl]: The URL of the sticker image.
  ///
  /// يرسل رسالة ملصق.
  Future<WaapiResponse> sendSticker({
    required String chatId,
    required String stickerUrl,
  }) async {
    return _handleRequest(() async {
      final data = _createFormData({'to': chatId, 'url': stickerUrl});

      final response = await _dio.post('api/send-sticker', data: data);
      return WaapiResponse.fromJson(response.data, null);
    });
  }

  /// Sends a voice note (PTT).
  ///
  /// [chatId]: The phone number.
  /// [audioUrl]: The URL of the audio file.
  ///
  /// يرسل رسالة صوتية.
  Future<WaapiResponse> sendVoiceNote({
    required String chatId,
    required String audioUrl,
  }) async {
    return _handleRequest(() async {
      final data = _createFormData({'to': chatId, 'url': audioUrl});

      final response = await _dio.post('api/send-voice', data: data);
      return WaapiResponse.fromJson(response.data, null);
    });
  }

  /// Sends a location.
  ///
  /// [chatId]: The phone number.
  /// [location]: The location object.
  Future<WaapiResponse> sendLocation({
    required String chatId,
    required WaapiLocation location,
  }) async {
    return _handleRequest(() async {
      final data = _createFormData({
        'to': chatId,
        'latitude': location.latitude.toString(),
        'longitude': location.longitude.toString(),
      });

      final response = await _dio.post('api/send-location', data: data);
      return WaapiResponse.fromJson(response.data, null);
    });
  }

  /// Sends a contact (vCard).
  ///
  /// [chatId]: The phone number.
  /// [contact]: The contact object.
  Future<WaapiResponse> sendContact({
    required String chatId,
    required WaapiContact contact,
  }) async {
    return _handleRequest(() async {
      // Waapi expects array format: contact[name], contact[number]
      // We construct FormData with keys manually since generic map might not handle nested brackets correctly in all dio versions automatically implies strict map.
      // FormData.fromMap handles simple key-values.

      final map = <String, dynamic>{
        'appkey': appKey,
        'authkey': authKey,
        'to': chatId,
        'contact[name]': contact.name,
        'contact[number]': contact.phoneNumber,
      };

      if (contact.organization != null) {
        map['contact[organization]'] = contact.organization;
      }

      final response = await _dio.post(
        'api/send-contact',
        data: FormData.fromMap(map),
      );
      return WaapiResponse.fromJson(response.data, null);
    });
  }

  /// Sends a template message.
  ///
  /// [chatId]: The phone number.
  /// [templateName]: The ID or name of the template.
  /// [parameters]: List of parameters for the template.
  ///
  /// يرسل رسالة قالب.
  Future<WaapiResponse> sendTemplate({
    required String chatId,
    required String templateName,
    List<String> parameters = const [],
  }) async {
    return _handleRequest(() async {
      final Map<String, dynamic> variables = {};
      for (int i = 0; i < parameters.length; i++) {
        // Waapi expects variables[{1}], variables[{2}], etc.
        variables['variables[{${i + 1}}]'] = parameters[i];
      }

      final data = _createFormData({
        'to': chatId,
        'template_id': templateName, // Correct param name from screenshot
        ...variables,
      });

      final response = await _dio.post('api/create-message', data: data);
      return WaapiResponse.fromJson(response.data, null);
    });
  }

  // Management methods like getDeviceStatus require device_id which we may not have.
  // We will expose a method that takes deviceId if known.

  Future<WaapiResponse<Map<String, dynamic>>> getDeviceStatus({
    required String deviceId,
  }) async {
    return _handleRequest(() async {
      final data = _createFormData({'device_id': deviceId});
      final response = await _dio.post('api/get-status', data: data);
      return WaapiResponse.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
    });
  }

  Future<WaapiResponse<Map<String, dynamic>>> getQrCode({
    required String deviceId,
  }) async {
    return _handleRequest(() async {
      final data = _createFormData({'device_id': deviceId});
      final response = await _dio.post('api/get-qr', data: data);
      return WaapiResponse.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
    });
  }
}

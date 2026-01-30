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
  /// [baseUrl]: The base URL of the API.
  /// [appKey]: The application key (x-app-key).
  /// [authKey]: The authentication key (x-auth-key).
  ///
  /// ينشئ نسخة جديدة من [WaapiClient].
  ///
  /// [baseUrl]: رابط الـ API الأساسي.
  /// [appKey]: مفتاح التطبيق (x-app-key).
  /// [authKey]: مفتاح المصادقة (x-auth-key).
  WaapiClient({
    required this.baseUrl,
    required this.appKey,
    required this.authKey,
    BaseOptions? dioOptions,
  }) : _dio = Dio(dioOptions ?? BaseOptions()) {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers['x-app-key'] = appKey;
    _dio.options.headers['x-auth-key'] = authKey;
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.options.headers['Accept'] = 'application/json';
  }

  /// Helper to handle Dio errors and convert them to [WaapiException].
  ///
  /// مساعد لمعالجة أخطاء Dio وتحويلها إلى [WaapiException].
  /// Helper to handle Dio errors and convert them to [WaapiException].
  ///
  /// مساعد لمعالجة أخطاء Dio وتحويلها إلى [WaapiException].
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

  /// Sends a text message to a specific number.
  ///
  /// [chatId]: The chat ID (phone number with country code, e.g., 201xxxxxxxxx).
  /// [message]: The text message to send.
  ///
  /// يرسل رسالة نصية إلى رقم محدد.
  ///
  /// [chatId]: معرف المحادثة (رقم الهاتف مع كود الدولة).
  /// [message]: الرسالة النصية المراد إرسالها.
  Future<WaapiResponse> sendText({
    required String chatId,
    required String message,
  }) async {
    return _handleRequest(() async {
      final response = await _dio.post(
        '/send-text', // Assumed endpoint based on convention
        data: {'chatId': chatId, 'text': message},
      );
      return WaapiResponse.fromJson(response.data, null);
    });
  }

  /// Sends a media message (Image, Video, Document).
  ///
  /// [chatId]: The chat ID.
  /// [mediaUrl]: The URL of the media file.
  /// [caption]: Optional caption for the media.
  /// [filename]: Optional filename.
  ///
  /// يرسل رسالة وسائط (صورة، فيديو، مستند).
  ///
  /// [chatId]: معرف المحادثة.
  /// [mediaUrl]: رابط ملف الوسائط.
  /// [caption]: شرح اختياري للوسائط.
  /// [filename]: اسم ملف اختياري.
  Future<WaapiResponse> sendMedia({
    required String chatId,
    required String mediaUrl,
    String? caption,
    String? filename,
  }) async {
    return _handleRequest(() async {
      final response = await _dio.post(
        '/send-media',
        data: {
          'chatId': chatId,
          'mediaUrl': mediaUrl,
          if (caption != null) 'caption': caption,
          if (filename != null) 'filename': filename,
        },
      );
      return WaapiResponse.fromJson(response.data, null);
    });
  }

  /// Sends a sticker message.
  ///
  /// [chatId]: The chat ID.
  /// [stickerUrl]: The URL of the sticker image.
  ///
  /// يرسل ملصق.
  ///
  /// [chatId]: معرف المحادثة.
  /// [stickerUrl]: رابط صورة الملصق.
  Future<WaapiResponse> sendSticker({
    required String chatId,
    required String stickerUrl,
  }) async {
    return _handleRequest(() async {
      final response = await _dio.post(
        '/send-sticker',
        data: {'chatId': chatId, 'stickerUrl': stickerUrl},
      );
      return WaapiResponse.fromJson(response.data, null);
    });
  }

  /// Sends a voice note (PTT).
  ///
  /// [chatId]: The chat ID.
  /// [audioUrl]: The URL of the audio file.
  ///
  /// يرسل ملاحظة صوتية (PTT).
  ///
  /// [chatId]: معرف المحادثة.
  /// [audioUrl]: رابط الملف الصوتي.
  Future<WaapiResponse> sendVoiceNote({
    required String chatId,
    required String audioUrl,
  }) async {
    return _handleRequest(() async {
      final response = await _dio.post(
        '/send-voice',
        data: {'chatId': chatId, 'audioUrl': audioUrl},
      );
      return WaapiResponse.fromJson(response.data, null);
    });
  }

  /// Sends a location.
  ///
  /// [chatId]: The chat ID.
  /// [location]: The location object.
  ///
  /// يرسل موقع.
  ///
  /// [chatId]: معرف المحادثة.
  /// [location]: كائن الموقع.
  Future<WaapiResponse> sendLocation({
    required String chatId,
    required WaapiLocation location,
  }) async {
    return _handleRequest(() async {
      final response = await _dio.post(
        '/send-location',
        data: {'chatId': chatId, ...location.toJson()},
      );
      return WaapiResponse.fromJson(response.data, null);
    });
  }

  /// Sends a contact (vCard).
  ///
  /// [chatId]: The chat ID.
  /// [contact]: The contact object.
  ///
  /// يرسل جهة اتصال.
  ///
  /// [chatId]: معرف المحادثة.
  /// [contact]: كائن جهة الاتصال.
  Future<WaapiResponse> sendContact({
    required String chatId,
    required WaapiContact contact,
  }) async {
    return _handleRequest(() async {
      final response = await _dio.post(
        '/send-contact',
        data: {
          'chatId': chatId,
          'vCard': contact.toVCard(),
          'name': contact.name,
        },
      );
      return WaapiResponse.fromJson(response.data, null);
    });
  }

  /// Sends a template message.
  ///
  /// [chatId]: The chat ID.
  /// [templateName]: The name of the template.
  /// [parameters]: List of parameters for the template.
  ///
  /// يرسل رسالة قالب.
  ///
  /// [chatId]: معرف المحادثة.
  /// [templateName]: اسم القالب.
  /// [parameters]: قائمة المتغيرات للقالب.
  Future<WaapiResponse> sendTemplate({
    required String chatId,
    required String templateName,
    List<String> parameters = const [],
  }) async {
    return _handleRequest(() async {
      final response = await _dio.post(
        '/send-template',
        data: {
          'chatId': chatId,
          'templateName': templateName,
          'parameters': parameters,
        },
      );
      return WaapiResponse.fromJson(response.data, null);
    });
  }

  /// Gets the device status.
  ///
  /// يعيد حالة الجهاز.
  Future<WaapiResponse<Map<String, dynamic>>> getDeviceStatus() async {
    return _handleRequest(() async {
      final response = await _dio.get('/status');
      return WaapiResponse.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
    });
  }

  /// Gets the QR code as a base64 string or URL.
  ///
  /// يعيد رمز QR كنص base64 أو رابط.
  Future<WaapiResponse<Map<String, dynamic>>> getQrCode() async {
    return _handleRequest(() async {
      final response = await _dio.get('/qr-code');
      return WaapiResponse.fromJson(
        response.data,
        (json) => json as Map<String, dynamic>,
      );
    });
  }

  /// Reboots the WhatsApp instance.
  ///
  /// يعيد تشغيل نسخة واتساب.
  Future<WaapiResponse> rebootInstance() async {
    return _handleRequest(() async {
      final response = await _dio.post('/reboot');
      return WaapiResponse.fromJson(response.data, null);
    });
  }
}

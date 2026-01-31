/// WhatsApp Business Messaging SDK for Flutter.
///
/// A production-ready package for the Waapi WhatsApp Gateway API.
/// Send OTP codes, notifications, media messages, and templates with ease.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:waapi_flutter/waapi_flutter.dart';
///
/// final client = WaapiClient(
///   baseUrl: 'https://waapi.octopusteam.net',
///   appKey: 'YOUR_APP_KEY',
///   authKey: 'YOUR_AUTH_KEY',
/// );
///
/// // Send OTP
/// await client.sendText(
///   chatId: '201xxxxxxxxx@c.us',
///   message: 'Your OTP code is: 123456',
/// );
/// ```
///
/// ## Features
///
/// - **Text Messaging**: Send text messages to WhatsApp users
/// - **Media Sharing**: Images, videos, documents with captions
/// - **Template Messages**: Pre-approved WhatsApp Business templates
/// - **Location Sharing**: GPS coordinates with address details
/// - **Contact Cards**: vCard format contact sharing
/// - **Voice Notes**: Audio PTT messages
/// - **Device Management**: QR code generation & connection status
///
/// ## Learn More
///
/// - [API Documentation](https://waapi.octopusteam.net/docs)
/// - [GitHub Repository](https://github.com/octopus-software-team/waapi_flutter)
library waapi_flutter;

export 'src/waapi_client.dart';
export 'src/models.dart';
export 'src/exceptions.dart';

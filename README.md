# Waapi Flutter

<p align="center">
  <img src="https://raw.githubusercontent.com/Ahmedelsapagh10/waapi_flutter/main/assets/waapi.png" width="150" alt="Waapi Logo">
</p>

<p align="center">
  <strong>WhatsApp Business Messaging SDK for Flutter</strong><br>
  Send OTP codes, notifications, media & templates via the Waapi Gateway API.
</p>

<p align="center">
  <a href="https://pub.dev/packages/waapi_flutter"><img src="https://img.shields.io/pub/v/waapi_flutter.svg" alt="Pub Version"></a>
  <a href="https://pub.dev/packages/waapi_flutter/score"><img src="https://img.shields.io/pub/points/waapi_flutter" alt="Pub Points"></a>
  <a href="https://pub.dev/packages/waapi_flutter"><img src="https://img.shields.io/pub/likes/waapi_flutter" alt="Pub Likes"></a>
  <a href="https://pub.dev/packages/waapi_flutter"><img src="https://img.shields.io/pub/popularity/waapi_flutter" alt="Pub Popularity"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License"></a>
</p>

<p align="center">
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-3.0+-02569B?logo=flutter" alt="Flutter"></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-3.0+-0175C2?logo=dart" alt="Dart"></a>
  <a href="https://pub.dev/packages/dio"><img src="https://img.shields.io/badge/HTTP-Dio-success" alt="Dio"></a>
</p>

---

## 📱 Screenshot

<p align="center">
  <img src="https://raw.githubusercontent.com/Ahmedelsapagh10/waapi_flutter/main/assets/example.png" width="300" alt="Waapi Flutter Example App">
</p>

---

## 🚀 Features

| Feature | Status | Description |
|---------|:------:|-------------|
| **Text Messaging** | ✅ | Send text messages to WhatsApp users |
| **Media Sharing** | ✅ | Images, videos, documents with captions |
| **Template Messages** | ✅ | Pre-approved WhatsApp Business templates |
| **Location Sharing** | ✅ | GPS coordinates with address details |
| **Contact Cards** | ✅ | vCard format contact sharing |
| **Voice Notes** | ✅ | Audio PTT (Push-to-Talk) messages |
| **Stickers** | ✅ | Send sticker images |
| **Device Management** | ✅ | QR code generation & connection status |
| **Error Handling** | ✅ | Centralized `WaapiException` handling |
| **Type Safety** | ✅ | Strongly typed models & responses |

---

## 💼 Use Cases

### 🔐 WhatsApp OTP Authentication
Send dynamic OTP verification codes for secure user authentication.

```dart
Future<void> sendOtpCode(String phoneNumber, String otpCode) async {
  try {
    final response = await client.sendText(
      chatId: '$phoneNumber@c.us',
      message: '🔐 Your verification code is: $otpCode\n\nThis code expires in 5 minutes.',
    );
    
    if (response.status == 'success') {
      print('OTP sent successfully!');
    }
  } on WaapiException catch (e) {
    print('Failed to send OTP: ${e.message}');
  }
}
```

### 📢 Marketing Notifications
Broadcast promotional messages, updates, and announcements.

```dart
await client.sendMedia(
  chatId: '201xxxxxxxxx@c.us',
  mediaUrl: 'https://cdn.example.com/promo-banner.png',
  caption: '🎉 Flash Sale! 50% off all items.\nShop now: example.com/sale',
);
```

### 💬 Customer Support Gateway
Automate support ticket notifications and updates.

```dart
await client.sendTemplate(
  chatId: '201xxxxxxxxx@c.us',
  templateName: 'ticket_update',
  parameters: ['#12345', 'resolved', 'Your issue has been fixed!'],
);
```

---

## 📦 Installation

Add `waapi_flutter` to your `pubspec.yaml`:

```yaml
dependencies:
  waapi_flutter: ^1.0.4
```

Then run:
```bash
flutter pub get
```

---

## 🔧 Quick Start

### Initialization

```dart
import 'package:waapi_flutter/waapi_flutter.dart';

final client = WaapiClient(
  baseUrl: 'https://waapi.octopusteam.net',
  appKey: 'YOUR_APP_KEY',
  authKey: 'YOUR_AUTH_KEY',
);
```

### Send Text Message

```dart
try {
  final response = await client.sendText(
    chatId: '201xxxxxxxxx@c.us', 
    message: 'Hello from Flutter!',
  );
  print('Status: ${response.status}');
} on WaapiException catch (e) {
  print('Error: ${e.message} (${e.statusCode})');
}
```

### Send Media

```dart
await client.sendMedia(
  chatId: '201xxxxxxxxx@c.us',
  mediaUrl: 'https://example.com/image.png',
  caption: 'Check this out!',
);
```

### Send Location

```dart
await client.sendLocation(
  chatId: '201xxxxxxxxx@c.us',
  location: WaapiLocation(
    latitude: 30.0444, 
    longitude: 31.2357, 
    name: 'Cairo Tower', 
    address: 'Cairo, Egypt',
  ),
);
```

### Send Contact

```dart
await client.sendContact(
  chatId: '201xxxxxxxxx@c.us',
  contact: WaapiContact(
    name: 'John Doe',
    phoneNumber: '+1234567890',
    organization: 'Acme Corp',
  ),
);
```

### Check Device Status

```dart
final status = await client.getDeviceStatus(deviceId: 'YOUR_DEVICE_ID');
print('Connected: ${status.data}');
```

---

## 🧠 Pro Tips for Senior Developers

### Global Instance

```dart
import 'package:waapi_flutter/waapi_flutter.dart';

// Simple global instance
final client = WaapiClient(
  baseUrl: 'https://waapi.octopusteam.net',
  appKey: 'YOUR_APP_KEY',
  authKey: 'YOUR_AUTH_KEY',
);

// Usage anywhere in your app
await client.sendText(chatId: '...', message: '...');
```

### State Management with Cubit

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waapi_flutter/waapi_flutter.dart';

// State
abstract class MessageState {}
class MessageInitial extends MessageState {}
class MessageSending extends MessageState {}
class MessageSent extends MessageState {
  final WaapiResponse response;
  MessageSent(this.response);
}
class MessageError extends MessageState {
  final String error;
  MessageError(this.error);
}

// Cubit
class MessageCubit extends Cubit<MessageState> {
  final WaapiClient _client;
  
  MessageCubit(this._client) : super(MessageInitial());
  
  Future<void> sendOtp(String phone, String code) async {
    emit(MessageSending());
    try {
      final response = await _client.sendText(
        chatId: '$phone@c.us',
        message: 'Your OTP: $code',
      );
      emit(MessageSent(response));
    } on WaapiException catch (e) {
      emit(MessageError(e.message));
    }
  }
}
```

### Custom Dio Configuration

```dart
import 'package:dio/dio.dart';
import 'package:waapi_flutter/waapi_flutter.dart';

final client = WaapiClient(
  baseUrl: 'https://waapi.octopusteam.net',
  appKey: 'YOUR_APP_KEY',
  authKey: 'YOUR_AUTH_KEY',
  dioOptions: BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
    sendTimeout: const Duration(seconds: 30),
  ),
);
```

### Check Connection Before Sending

```dart
Future<bool> sendMessageSafely({
  required String deviceId,
  required String chatId,
  required String message,
}) async {
  // 1. Check device connection status first
  final status = await client.getDeviceStatus(deviceId: deviceId);
  
  if (status.status != 'success') {
    print('Device not connected. Please scan QR code.');
    return false;
  }
  
  // 2. Send message only if connected
  final response = await client.sendText(chatId: chatId, message: message);
  return response.status == 'success';
}
```

---

## 🔥 Troubleshooting

### Common WhatsApp API Errors

| Error Code | Cause | Solution |
|:----------:|-------|----------|
| **401** | Invalid `appKey` or `authKey` | Verify your API credentials in the Waapi dashboard |
| **403** | Number not registered on WhatsApp | Ensure the recipient has an active WhatsApp account |
| **404** | Invalid endpoint or device ID | Check the API endpoint and device configuration |
| **429** | Rate limit exceeded | Implement exponential backoff; respect API limits |
| **500** | Server error | Retry with backoff; contact support if persistent |

### Error Handling Best Practices

```dart
try {
  final response = await client.sendText(
    chatId: '201xxxxxxxxx@c.us',
    message: 'Hello!',
  );
} on WaapiException catch (e) {
  switch (e.statusCode) {
    case 401:
      print('Authentication failed. Check your API keys.');
      break;
    case 403:
      print('This number is not registered on WhatsApp.');
      break;
    case 429:
      print('Rate limited. Please wait before retrying.');
      await Future.delayed(const Duration(seconds: 60));
      break;
    default:
      print('Error ${e.statusCode}: ${e.message}');
  }
}
```

### Connection Issues

```dart
// Always verify device connection before bulk operations
Future<void> sendBulkMessages(List<String> recipients, String message) async {
  final status = await client.getDeviceStatus(deviceId: 'YOUR_DEVICE_ID');
  
  if (status.status != 'success') {
    throw Exception('WhatsApp device not connected. Scan QR to reconnect.');
  }
  
  for (final phone in recipients) {
    await client.sendText(chatId: '$phone@c.us', message: message);
    await Future.delayed(const Duration(milliseconds: 500)); // Avoid rate limits
  }
}
```

---

## 📚 API Reference

| Method | Description |
|--------|-------------|
| `sendText()` | Send a text message |
| `sendMedia()` | Send image, video, or document |
| `sendSticker()` | Send a sticker image |
| `sendVoiceNote()` | Send an audio voice note |
| `sendLocation()` | Send GPS location with address |
| `sendContact()` | Send a contact card (vCard) |
| `sendTemplate()` | Send a pre-approved template message |
| `getDeviceStatus()` | Check WhatsApp connection status |
| `getQrCode()` | Get QR code for device pairing |

---

## 🤝 Contributing

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

---

## 👨‍💻 Author

<p align="center">
  <img src="https://raw.githubusercontent.com/Ahmedelsapagh10/waapi_flutter/main/assets/me3.webp" width="120" style="border-radius: 50%;" alt="Eng Ahmed Mohamed Elsapagh">
</p>

<p align="center">
  <strong>Eng Ahmed Mohamed Elsapagh</strong>
</p>

- 🌐 **Portfolio**: [elsapagh.octopusteam.net](https://elsapagh.octopusteam.net/)
- 💼 **Role**: Co-founder & Mobile Lead at [Octopus Team](https://octopusteam.net)

---

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

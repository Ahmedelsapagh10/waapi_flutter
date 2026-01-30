# Waapi Flutter

<p align="center">
  <img src="assets/waapi.png" width="150" alt="Waapi Logo">
</p>

<p align="center">
  <a href="https://pub.dev/packages/waapi_flutter"><img src="https://img.shields.io/pub/v/waapi_flutter.svg" alt="Pub Version"></a>
  <a href="https://pub.dev/packages/waapi_flutter/score"><img src="https://img.shields.io/pub/points/waapi_flutter" alt="Pub Points"></a>
  <a href="https://opensource.org/licenses/MIT"><img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="License"></a>
</p>

<p align="center">
  <strong>A production-ready Flutter package for the Waapi WhatsApp Gateway API.</strong><br>
  Send text, media, stickers, voice notes, locations, contacts, and templates with ease.
</p>

---

## Platform Support

| Android | iOS | Web | macOS | Windows | Linux |
|:-------:|:---:|:---:|:-----:|:-------:|:-----:|
|    ✅    |  ✅  |  ✅  |   ✅   |    ✅    |   ✅   |

---

## Features

- **Messaging**: Send text, media, stickers, voice notes, locations, contacts, and templates.
- **Device Management**: Check device status and get QR codes.
- **Strongly Typed**: Includes models for `WaapiResponse`, `WaapiLocation`, `WaapiContact`.
- **Error Handling**: Centralized `WaapiException` handling.

---

## Screenshot

<p align="center">
  <img src="assets/waapi.png" width="200" alt="Waapi Screenshot">
</p>

---

## Installation

Add `waapi_flutter` to your `pubspec.yaml`:

```yaml
dependencies:
  waapi_flutter: ^0.0.1
```

Then run:
```bash
flutter pub get
```

---

## Usage

### Initialization

```dart
import 'package:waapi_flutter/waapi_flutter.dart';

final client = WaapiClient(
  baseUrl: 'https://waapi.octopusteam.net',
  appKey: 'YOUR_APP_KEY',
  authKey: 'YOUR_AUTH_KEY',
);
```

### Messaging

#### Send Text
```dart
try {
  final response = await client.sendText(
    chatId: '201xxxxxxxxx@c.us', 
    message: 'Hello from Flutter!',
  );
  print('Status: ${response.status}');
} catch (e) {
  print('Error: $e');
}
```

#### Send Media
```dart
await client.sendMedia(
  chatId: '201xxxxxxxxx@c.us',
  mediaUrl: 'https://example.com/image.png',
  caption: 'Check this out!',
);
```

#### Send Location
```dart
await client.sendLocation(
  chatId: '201xxxxxxxxx@c.us',
  location: WaapiLocation(
    latitude: 30.0444, 
    longitude: 31.2357, 
    name: 'Cairo Tower', 
    address: 'Cairo, Egypt'
  ),
);
```

#### Send Contact
```dart
await client.sendContact(
  chatId: '201xxxxxxxxx@c.us',
  contact: WaapiContact(
    name: 'John Doe',
    phoneNumber: '+1234567890',
  ),
);
```

### Device Management

```dart
final status = await client.getDeviceStatus(deviceId: 'YOUR_DEVICE_ID');
print(status.data);
```

---

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

## Author

**Eng Ahmed Mohamed Elsapagh**

Senior Flutter Developer with 4+ years of experience specializing in Tracking Apps, E-learning, and Flutter Web. Currently working at DomApp on building inspection compliance apps for Saudi Arabia. Key projects include Elmazoon (13k+ students) and 6+ freelance apps serving 20k+ users.

- 🌐 **Portfolio**: [elsapagh.octopusteam.net](https://elsapagh.octopusteam.net/)
- 💼 **Role**: Co-founder & Mobile Lead at [Octopus Team](https://octopusteam.net)
- 🎓 **Instructor**: Flutter Developer & Tech Content Creator

---

## License

MIT License - see [LICENSE](LICENSE) for details.

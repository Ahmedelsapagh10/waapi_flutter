# Waapi Flutter

A production-ready Flutter package for the Waapi WhatsApp Gateway API.
Helper package to easily integrate Waapi services into your Flutter application.

## Features

- **Messaging**: Send text, media, stickers, voice notes, locations, contacts, and templates.
- **Device Management**: Check device status, get QR codes, and reboot instances.
- **Strongly Typed**: Includes models for `WaapiResponse`, `WaapiLocation`, `WaapiContact`.
- **Error Handling**: Centralized `WaapiException` handling.

## Installation

Add `waapi_flutter` to your `pubspec.yaml`:

```yaml
dependencies:
  waapi_flutter:
    path: ./ # Or git/pub url
```

## Usage

### Initialization

```dart
import 'package:waapi_flutter/waapi_flutter.dart';

final client = WaapiClient(
  baseUrl: 'https://waapi.octopusteam.net/api',
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
final status = await client.getDeviceStatus();
print(status.data);

await client.rebootInstance();
```

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

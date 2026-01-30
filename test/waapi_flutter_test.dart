import 'package:flutter_test/flutter_test.dart';
import 'package:waapi_flutter/waapi_flutter.dart';

void main() {
  group('WaapiClient Tests', () {
    test('Client instantiation', () {
      final client = WaapiClient(
        baseUrl: 'https://waapi.octopusteam.net',
        appKey: 'test_app_key',
        authKey: 'test_auth_key',
      );
      expect(client, isNotNull);
    });

    test('Location model serialization', () {
      final location = WaapiLocation(
        latitude: 30.0,
        longitude: 31.0,
        name: 'Cairo',
        address: 'Egypt',
      );
      final json = location.toJson();
      expect(json['latitude'], 30.0);
      expect(json['name'], 'Cairo');
    });

    test('Contact model vCard generation', () {
      final contact = WaapiContact(name: 'Test User', phoneNumber: '123456');
      final vCard = contact.toVCard();
      expect(vCard, contains('FN:Test User'));
      expect(vCard, contains('TEL;TYPE=CELL:123456'));
    });
  });
}

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:waapi_flutter/waapi_flutter.dart';
import 'app_constants.dart';

void main() {
  runApp(const MaterialApp(home: WaapiExampleApp()));
}

class WaapiExampleApp extends StatefulWidget {
  const WaapiExampleApp({super.key});

  @override
  State<WaapiExampleApp> createState() => _WaapiExampleAppState();
}

class _WaapiExampleAppState extends State<WaapiExampleApp> {
  // Credentials Controllers
  final _baseUrlController = TextEditingController(text: AppConstants.baseUrl);
  final _appKeyController = TextEditingController(text: AppConstants.appKey);
  final _authKeyController = TextEditingController(text: AppConstants.authKey);

  // Message Controllers
  final _chatIdController = TextEditingController();
  final _messageController = TextEditingController();
  final _captionController = TextEditingController();
  final _latitudeController = TextEditingController(text: '30.0444');
  final _longitudeController = TextEditingController(text: '31.2357');

  // State
  String _selectedType = 'text';
  String _log = 'Ready to send messages.';
  String? _selectedFilePath;
  bool _isLoading = false;
  WaapiClient? _client;

  final List<String> _messageTypes = [
    'text',
    'media',
    'sticker',
    'voice',
    'location',
    'contact',
    'template',
  ];

  void _initClient() {
    if (_appKeyController.text.isEmpty || _authKeyController.text.isEmpty) {
      _appendLog('Error: App Key and Auth Key are required.');
      return;
    }
    _client = WaapiClient(
      baseUrl: _baseUrlController.text,
      appKey: _appKeyController.text,
      authKey: _authKeyController.text,
    );
    _appendLog('Client initialized.');
  }

  Future<void> _pickContact() async {
    try {
      if (await Permission.contacts.request().isGranted) {
        final contact = await FlutterContacts.openExternalPick();
        if (contact != null) {
          if (contact.phones.isNotEmpty) {
            String phone = contact.phones.first.number.replaceAll(
              RegExp(r'[^0-9]'),
              '',
            );
            // Basic formatting assumption, user might need to adjust manually
            _chatIdController.text = '$phone@c.us';
            _appendLog('Selected contact: ${contact.displayName} ($phone)');
          } else {
            _appendLog('Contact has no phone number.');
          }
        }
      } else {
        _appendLog('Permission denied: Contacts');
      }
    } catch (e) {
      _appendLog('Error picking contact: $e');
    }
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _selectedFilePath = result.files.single.path;
          _appendLog('Selected file: ${result.files.single.name}');
          // Note: Waapi expects a URL for media usually, but we will pass path here
          // and let the user know they might need to upload it first or if the API supports local files (via dio FormData).
          // **Correction**: The WaapiClient implemented sends JSON with URLs.
          // This example assumes providing a URL string in the text box for simplicity unless we implement file upload.
          // For now, let's treat the "File" input as a URL input primarily, or clarify that local file upload isn't directly supported by the current client methods which take 'mediaUrl'.

          // If the user picked a file, we can populate the URL field with the path,
          // but the API requires a public URL.
          // We will fallback to using the text field as the "URL" input.
          _messageController.text = _selectedFilePath ?? '';
        });
      }
    } catch (e) {
      _appendLog('Error picking file: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_client == null) _initClient();
    if (_client == null) return;

    setState(() => _isLoading = true);
    final chatId = _chatIdController.text;

    try {
      WaapiResponse response;
      switch (_selectedType) {
        case 'text':
          response = await _client!.sendText(
            chatId: chatId,
            message: _messageController.text,
          );
          break;
        case 'media':
          response = await _client!.sendMedia(
            chatId: chatId,
            mediaUrl: _messageController.text, // Using text field as URL input
            caption: _captionController.text,
          );
          break;
        case 'sticker':
          response = await _client!.sendSticker(
            chatId: chatId,
            stickerUrl: _messageController.text,
          );
          break;
        case 'voice':
          response = await _client!.sendVoiceNote(
            chatId: chatId,
            audioUrl: _messageController.text,
          );
          break;
        case 'location':
          response = await _client!.sendLocation(
            chatId: chatId,
            location: WaapiLocation(
              latitude: double.parse(_latitudeController.text),
              longitude: double.parse(_longitudeController.text),
              name: 'Selected Location',
              address: 'Address details',
            ),
          );
          break;
        case 'contact':
          // For demo, sending a fixed contact or parsed from fields
          response = await _client!.sendContact(
            chatId: chatId,
            contact: WaapiContact(
              name: 'Demo Contact',
              phoneNumber: '123456789',
            ),
          );
          break;
        case 'template':
          response = await _client!.sendTemplate(
            chatId: chatId,
            templateName: _messageController.text,
          );
          break;
        default:
          throw Exception('Unknown type');
      }
      _appendLog('Success: ${response.status} - ${response.message}');
    } catch (e) {
      _appendLog('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _appendLog(String message) {
    setState(() {
      _log = '$message\n\n$_log';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Waapi Flutter Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  'assets/waapi.png',
                  package: 'waapi_flutter',
                  height: 100,
                ),
              ),
              const SizedBox(height: 20),
              _buildCredentialsSection(),
              const Divider(height: 32),
              _buildMessageSection(),
              const Divider(height: 32),
              const Text(
                'Logs:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                height: 200,
                padding: const EdgeInsets.all(8),
                color: Colors.grey[200],
                child: SingleChildScrollView(child: Text(_log)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCredentialsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text(
              'Credentials',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _baseUrlController,
              decoration: const InputDecoration(labelText: 'Base URL'),
            ),
            TextField(
              controller: _appKeyController,
              decoration: const InputDecoration(
                labelText: 'App Key (x-app-key)',
              ),
            ),
            TextField(
              controller: _authKeyController,
              decoration: const InputDecoration(
                labelText: 'Auth Key (x-auth-key)',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const Text(
              'Send Message',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _chatIdController,
                    decoration: const InputDecoration(
                      labelText: 'Chat ID (e.g. 201xxxx@c.us)',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.contacts),
                  onPressed: _pickContact,
                  tooltip: 'Pick Contact',
                ),
              ],
            ),
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: _messageTypes
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedType = val!),
              decoration: const InputDecoration(labelText: 'Message Type'),
            ),
            const SizedBox(height: 10),
            if (_selectedType == 'location') ...[
              TextField(
                controller: _latitudeController,
                decoration: const InputDecoration(labelText: 'Latitude'),
              ),
              TextField(
                controller: _longitudeController,
                decoration: const InputDecoration(labelText: 'Longitude'),
              ),
            ] else if (_selectedType != 'contact') ...[
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        labelText: _selectedType == 'text'
                            ? 'Message Text'
                            : 'Media/Audio URL',
                      ),
                    ),
                  ),
                  if (['media', 'sticker', 'voice'].contains(_selectedType))
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: _pickFile,
                      tooltip: 'Pick File',
                    ),
                ],
              ),
              if (_selectedType == 'media')
                TextField(
                  controller: _captionController,
                  decoration: const InputDecoration(labelText: 'Caption'),
                ),
            ],

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendMessage,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('SEND'),
            ),
          ],
        ),
      ),
    );
  }
}

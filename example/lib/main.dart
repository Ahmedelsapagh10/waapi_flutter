import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:waapi_flutter/waapi_flutter.dart';
import 'app_constants.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const WaapiExampleApp());
}

class WaapiExampleApp extends StatelessWidget {
  const WaapiExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Waapi Flutter Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00A884),
          primary: const Color(0xFF00A884),
          secondary: const Color(0xFF25D366),
          surface: const Color(0xFFF0F2F5),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF0F2F5),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF00A884), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 2,
            shadowColor: const Color(0x4000A884),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF00A884),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _baseUrlController = TextEditingController(text: AppConstants.baseUrl);
  final _appKeyController = TextEditingController(text: AppConstants.appKey);
  final _authKeyController = TextEditingController(text: AppConstants.authKey);

  final _chatIdController = TextEditingController();
  final _messageController = TextEditingController();

  String _log = '• Ready to send messages.';
  bool _isLoading = false;
  WaapiClient? _client;

  @override
  void dispose() {
    _baseUrlController.dispose();
    _appKeyController.dispose();
    _authKeyController.dispose();
    _chatIdController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _initClient() {
    if (_appKeyController.text.isEmpty || _authKeyController.text.isEmpty) {
      _appendLog('⚠️ Error: App Key and Auth Key are required.');
      return;
    }
    _client = WaapiClient(
      baseUrl: _baseUrlController.text,
      appKey: _appKeyController.text,
      authKey: _authKeyController.text,
    );
  }

  Future<void> _sendMessage() async {
    if (_client == null) _initClient();
    if (_client == null) return;

    if (_chatIdController.text.isEmpty || _messageController.text.isEmpty) {
      _appendLog('⚠️ Chat ID and Message are required.');
      return;
    }

    setState(() => _isLoading = true);
    final chatId = _chatIdController.text.trim();

    try {
      final response = await _client!.sendText(
        chatId: chatId,
        message: _messageController.text,
      );
      _appendLog('✅ Sent! Status: ${response.status}');
      _messageController.clear();
    } catch (e) {
      _appendLog('❌ Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _appendLog(String message) {
    setState(() {
      _log = '$message\n$_log';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Custom Gradient App Bar
          Container(
            padding: const EdgeInsets.only(
              top: 48,
              bottom: 24,
              left: 24,
              right: 24,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00A884), Color(0xFF008069)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    'assets/waapi.png',
                    package: 'waapi_flutter',
                    height: 40,
                    width: 40,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Waapi Composer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                // Input Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Message',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _chatIdController,
                        decoration: InputDecoration(
                          labelText: 'Chat ID',
                          hintText: '201xxxxxxxxx@c.us',
                          prefixIcon: Icon(
                            Icons.perm_identity,
                            color: Colors.grey.shade400,
                          ),
                          fillColor: const Color(0xFFF8F9FA),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          labelText: 'Your Message',
                          hintText: 'Type something...',
                          prefixIcon: Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.grey.shade400,
                          ),
                          fillColor: const Color(0xFFF8F9FA),
                        ),
                        maxLines: 4,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _sendMessage,
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.send_rounded, size: 20),
                                    SizedBox(width: 8),
                                    Text('Send Message'),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Logs Terminal
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.terminal,
                            color: Colors.greenAccent.shade400,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Console Output',
                            style: TextStyle(
                              color: Colors.greenAccent.shade400,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white24, height: 24),
                      SizedBox(
                        height: 100,
                        child: SingleChildScrollView(
                          child: Text(
                            _log,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontFamily: 'Courier',
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

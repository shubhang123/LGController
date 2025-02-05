import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lg_controller/models/config.dart';
import 'package:lg_controller/models/connection_status.dart';
import 'package:lg_controller/services/lg_services.dart';
import 'package:lg_controller/widgets/form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portController =
      TextEditingController(text: '22');
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _connectToLG();
  }

  Future<void> _loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _hostController.text = prefs.getString('ipAddress') ?? '';
      _usernameController.text = prefs.getString('username') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _portController.text = prefs.getString('port') ?? '22';
    });
  }

  Future<void> _saveSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_hostController.text.isNotEmpty) {
      await prefs.setString('ipAddress', _hostController.text);
    }
    if (_usernameController.text.isNotEmpty) {
      await prefs.setString('username', _usernameController.text);
    }
    if (_passwordController.text.isNotEmpty) {
      await prefs.setString('password', _passwordController.text);
    }
    if (_portController.text.isNotEmpty) {
      await prefs.setString('port', _portController.text);
    }
  }

  Future<void> _connectToLG() async {
    setState(() {
      _isConnecting = true;
    });
    await AppConfig.ssh.connect();
    if (AppConfig.ssh.connected) {
      AppConfig.lg = LGService(AppConfig.ssh.client);
    }
    setState(() {
      _isConnecting = false;
    });
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SizedBox(
          height: 60,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFF424242),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headingStyle = GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w900,
      color: Colors.white,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/logos/LGLogo.png',
                  alignment: Alignment.center,
                  scale: 2,
                ),
                Row(
                  children: [
                    Text(
                      'Settings',
                      style: headingStyle,
                    ),
                    const Spacer(),
                    const ConnectionStatusDot(),
                  ],
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Host IP
                      CustomTextFormField(
                        controller: _hostController,
                        label: 'Host IP',
                        hint: '192.168.x.x',
                        icon: Icons.computer,
                        validatorMsg: 'Please enter the host IP',
                      ),
                      const SizedBox(height: 16),

                      CustomTextFormField(
                        controller: _portController,
                        label: 'Port',
                        hint: '22',
                        icon: Icons.settings_ethernet,
                        keyboardType: TextInputType.number,
                        validatorMsg: 'Please enter the port',
                      ),
                      const SizedBox(height: 16),

                      CustomTextFormField(
                        controller: _usernameController,
                        label: 'Username',
                        hint: 'lg',
                        icon: Icons.person,
                        validatorMsg: 'Please enter the username',
                      ),
                      const SizedBox(height: 16),

                      CustomPasswordFormField(
                        controller: _passwordController,
                        label: 'Password',
                        hint: 'Enter your password',
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isConnecting
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        try {
                                          await _saveSettings();

                                          await _connectToLG();

                                          showSnackBar(AppConfig.ssh.connected
                                              ? 'Connected successfully!'
                                              : 'Connection failed!');
                                        } on TimeoutException catch (_) {
                                          showSnackBar('Connection timed out!');
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.amber,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isConnecting
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'Connect',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: Text(
                          AppConfig.ssh.connected
                              ? 'Connected'
                              : 'Disconnected',
                          style: TextStyle(
                            color: AppConfig.ssh.connected
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

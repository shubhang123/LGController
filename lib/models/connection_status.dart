import 'dart:async';
import 'package:flutter/material.dart';
import 'config.dart';

class ConnectionStatusDot extends StatefulWidget {
  const ConnectionStatusDot({Key? key}) : super(key: key);

  @override
  State<ConnectionStatusDot> createState() => _ConnectionStatusDotState();
}

class _ConnectionStatusDotState extends State<ConnectionStatusDot> {
  late Timer _pollTimer;
  bool isConnected = AppConfig.ssh.connected;

  @override
  void initState() {
    super.initState();
    _pollTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      bool newStatus = AppConfig.ssh.connected;
      if (newStatus != isConnected) {
        setState(() {
          isConnected = newStatus;
        });
      }
    });
  }

  @override
  void dispose() {
    _pollTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.circle,
      color: isConnected ? Colors.green : Colors.red,
      size: 20,
    );
  }
}

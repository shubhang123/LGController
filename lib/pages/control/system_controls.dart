// lib/widgets/system_controls.dart

import 'package:flutter/material.dart';
import '../../models/config.dart';
import '../../widgets/control_button.dart';

class SystemControls extends StatelessWidget {
  const SystemControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ControlCard(
                onPressed: () {
                  AppConfig.lg.relaunch();
                },
                icon: Icons.refresh,
                label: 'Relaunch',
                color: Colors.cyan,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ControlCard(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.indigo[900],
                      title: const Text('Reboot',
                          style: TextStyle(color: Colors.white)),
                      content: const Text('Are you sure you want to reboot?',
                          style: TextStyle(color: Colors.white)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.cyanAccent)),
                        ),
                        TextButton(
                          onPressed: () {
                            AppConfig.lg.reboot();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Confirm',
                              style: TextStyle(color: Colors.cyanAccent)),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icons.restart_alt,
                label: 'Reboot',
                color: Colors.deepOrange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ControlCard(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.indigo[900],
                      title: const Text('Power Off',
                          style: TextStyle(color: Colors.white)),
                      content: const Text('Are you sure you want to power off?',
                          style: TextStyle(color: Colors.white)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancel',
                              style: TextStyle(color: Colors.cyanAccent)),
                        ),
                        TextButton(
                          onPressed: () {
                            AppConfig.lg.poweroff();
                            Navigator.of(context).pop();
                          },
                          child: const Text('Confirm',
                              style: TextStyle(color: Colors.cyanAccent)),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icons.power_settings_new,
                label: 'Power Off',
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lg_controller/models/connection_status.dart';
import 'package:lg_controller/pages/control/system_controls.dart';

class ControlPage extends StatelessWidget {
  const ControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SafeArea(
            child: Column(
              children: [
                Image.asset(
                  'assets/logos/LGLogo.png',
                  alignment: Alignment.center,
                  scale: 2,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'System Actions',
                          style: GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        Spacer(),
                        ConnectionStatusDot(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const SystemControls(),
                    SizedBox(
                      height: 200,
                    ),
                  
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lg_controller/models/connection_status.dart';
import 'manage_controls.dart';

class ManagePage extends StatelessWidget {
  const ManagePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Controls',
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
                    const SizedBox(height: 12),
                    const ManageControls(),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Made by Shubhang\nfor Liquid Galaxy',
                      style: GoogleFonts.poppins(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    )
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

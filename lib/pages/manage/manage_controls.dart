import 'package:flutter/material.dart';
import 'package:lg_controller/widgets/control_button.dart';
import '../../models/config.dart';

class ManageControls extends StatelessWidget {
  const ManageControls({super.key});

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
                  AppConfig.lg.setLogos();
                },
                icon: Icons.add,
                label: 'Set LG Logo',
                color: Colors.blueAccent,
              ),
            ),
            Expanded(
              child: ControlCard(
                onPressed: () {
                  AppConfig.lg.clearKml(keepLogos: false);
                },
                icon: Icons.clear,
                label: 'Clear Logos',
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: ControlCard(
                onPressed: () async {
                  AppConfig.lg.showOrbitBalloon();
                },
                icon: Icons.send,
                label: 'send KML 1',
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ControlCard(
                onPressed: () async {
                  AppConfig.lg.sendKml1();
                },
                icon: Icons.send,
                label: 'send KML 2',
                color: Colors.teal,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: ControlCard(
                onPressed: () {
                  AppConfig.lg.clearKml(keepLogos: true);
                },
                icon: Icons.delete,
                label: 'Clear KML',
                color: Colors.pinkAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

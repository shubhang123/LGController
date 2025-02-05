import 'dart:convert';
import 'dart:async';
import 'package:dartssh2/dartssh2.dart';
import 'package:lg_controller/models/kml_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LGService {
  final SSHClient _client;
  LGService(SSHClient client) : _client = client;

  int screenAmount = 3;
  int getLogoScreen() {
    if (screenAmount == 1) {
      return 1;
    }
    return (screenAmount / 2).floor() + 2;
  }

  Future<String?> getScreenAmount() async {
    final session = await _client
        .execute("grep -oP '(?<=DHCP_LG_FRAMES_MAX=).*' personavars.txt");
    final result = await utf8.decoder.bind(session.stdout).join();
    return result;
  }

  int get firstScreen {
    if (screenAmount == 1) {
      return 1;
    }
    return (screenAmount / 2).floor() + 2;
  }

  int get lastScreen {
    if (screenAmount == 1) {
      return 1;
    }
    return (screenAmount / 2).floor();
  }

  Future<void> setRefresh() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final pw = prefs.getString('password') ?? '';

    const search = '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href>';
    const replace =
        '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
    final command =
        'echo $pw | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml';

    final clear =
        'echo $pw | sudo -S sed -i "s/$replace/$search/" ~/earth/kml/slave/myplaces.kml';

    for (var i = 2; i <= screenAmount; i++) {
      final clearCmd = clear.replaceAll('{{slave}}', i.toString());
      final cmd = command.replaceAll('{{slave}}', i.toString());
      String query = 'sshpass -p $pw ssh -t lg$i \'{{cmd}}\'';

      try {
        await _client.execute(query.replaceAll('{{cmd}}', clearCmd));
        await _client.execute(query.replaceAll('{{cmd}}', cmd));
        await reboot();
      } catch (e) {
        print('error occured');
      }
    }
  }

  Future<void> resetRefresh() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final pw = prefs.getString('password') ?? '';

    const search =
        '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href><refreshMode>onInterval<\\/refreshMode><refreshInterval>2<\\/refreshInterval>';
    const replace = '<href>##LG_PHPIFACE##kml\\/slave_{{slave}}.kml<\\/href>';

    final clear =
        'echo $pw | sudo -S sed -i "s/$search/$replace/" ~/earth/kml/slave/myplaces.kml';

    for (var i = 2; i <= screenAmount; i++) {
      final cmd = clear.replaceAll('{{slave}}', i.toString());
      String query = 'sshpass -p $pw ssh -t lg$i \'$cmd\'';

      try {
        await _client.execute(query);
      } catch (e) {
        print(e);
      }
    }

    await reboot();
  }

  Future<void> relaunch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final pw = prefs.getString('password') ?? '';

    final user = _client.username;

    for (var i = screenAmount; i >= 1; i--) {
      try {
        final relaunchCommand = """RELAUNCH_CMD="\\
              if [ -f /etc/init/lxdm.conf ]; then
                export SERVICE=lxdm
              elif [ -f /etc/init/lightdm.conf ]; then
                export SERVICE=lightdm
              else
                exit 1
              fi
              if  [[ \\\$(service \\\$SERVICE status) =~ 'stop' ]]; then
                echo $pw | sudo -S service \\\${SERVICE} start
              else
                echo $pw | sudo -S service \\\${SERVICE} restart
              fi
              " && sshpass -p $pw ssh -x -t lg@lg$i "\$RELAUNCH_CMD\"""";
        await _client
            .execute('"/home/$user/bin/lg-relaunch" > /home/$user/log.txt');
        await _client.execute(relaunchCommand);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> poweroff() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final pw = prefs.getString('password') ?? '';

    for (var i = screenAmount; i >= 1; i--) {
      try {
        await _client.execute(
            'sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S poweroff"');
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> reboot() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final pw = prefs.getString('password') ?? '';
    for (var i = screenAmount; i >= 1; i--) {
      try {
        await _client
            .execute('sshpass -p $pw ssh -t lg$i "echo $pw | sudo -S reboot"');
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> clearKml({bool keepLogos = true}) async {
    int logoScreen = getLogoScreen();
    String query =
        'echo "exittour=true" > /tmp/query.txt && > /var/www/html/kmls.txt';

    for (var i = 2; i <= screenAmount; i++) {
      String blankKml = KMLModel.generateBlank('slave_$i');
      query += " && echo '$blankKml' > /var/www/html/kml/slave_$i.kml";
    }

    if (keepLogos) {
      final kml = KMLModel(
        name: 'SVT-logos',
        content: '<name>Logos</name>',
        screenOverlay: ScreenOverlayModel.logos().tag,
      );

      query +=
          " && echo '${kml.body}' > /var/www/html/kml/slave_$logoScreen.kml";
    }
    try {
      await _client.execute(query);
    } catch (e) {
      print(e);
    }
  }

  Future<void> setLogos({
    String name = 'ARCA-Dashboard',
    String content = '<name>Logos</name>',
  }) async {
    final screenOverlay = ScreenOverlayModel.logos();

    final kml = KMLModel(
      name: name,
      content: content,
      screenOverlay: screenOverlay.tag,
    );

    try {
      final result = await getScreenAmount();
      if (result != null) {
        screenAmount = int.parse(result);
      }

      await sendKMLToSlave(firstScreen, kml.body);
    } catch (e) {
      print(e);
    }
  }

  searchPlace(String placeName) async {
    try {
      final execResult =
          await _client.execute('echo "search=$placeName" >/tmp/query.txt');
      return execResult;
    } catch (e) {
      print('An error occurred while executing the command: $e');
      return null;
    }
  }

  Future<void> sendKMLToSlave(int screen, String content) async {
    try {
      await _client
          .execute("echo '$content' > /var/www/html/kml/slave_$screen.kml");
    } catch (e) {
      print(e);
    }
  }

  Future<void> showOrbitBalloon() async {
    String img =
        'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e1/Indore_Rajwada01.jpg/250px-Indore_Rajwada01.jpg';
    await _client.execute(
        "echo '${KMLModel.orbitBalloon(img)}' > /var/www/html/kml/slave_2.kml");

    String longitude = '75.855217';
    String latitude = '22.718435';
    String range = '400';
    String tilt = '60';
    String heading = '10';

    await _client.execute(
        'echo "flytoview=${KMLModel.generateLinearString(longitude, latitude, range, tilt, heading)}" > /tmp/query.txt');
  }

  Future<void> query(String content) async {
    await _client.execute('echo "$content" > /tmp/query.txt');
  }

  buildOrbit(String content) async {
    try {
      await _client.run("echo '$content' > /var/www/html/Orbit.kml");
      await _client.execute(
          "echo '\nhttp://lg1:81/Orbit.kml' >> /var/www/html/kmls.txt");
      return await query('playtour=Orbit');
    } catch (e) {
      return Future.error(e);
    }
  }

  startOrbit() async {
    try {
      return await query('playtour=Orbit');
    } catch (e) {
      return Future.error(e);
    }
  }

  stopOrbit() async {
    try {
      return await query('exittour=true');
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> sendKml1() async {
    try {
      await _client
          .execute("echo '${KMLModel.newKML()}' > /var/www/html/shubhang.kml");
      await _client.execute(
          "echo '\nhttp://lg1:81/shubhang.kml' > /var/www/html/kmls.txt");

      String longitude = '78.0421012636558';
      String latitude = '27.1750075';
      String range = '400';
      String tilt = '60';
      String heading = '10';

      return await query(
          'flytoview=${KMLModel.generateLinearString(longitude, latitude, range, tilt, heading)}');
    } catch (e) {
      return Future.error(e);
    }
  }
}

class Orbit {
  static String generateOrbitTag() {
    double heading = 0;
    int orbit = 0;
    String content = '';
    String range = '4500';
    double latvalue = 22.718435;
    double longvalue = 75.855217;

    while (orbit <= 36) {
      if (heading >= 360) heading -= 360;
      content += '''
            <gx:FlyTo>
              <gx:duration>2</gx:duration>
              <gx:flyToMode>smooth</gx:flyToMode>
              <LookAt>
                  <longitude>$longvalue</longitude>
                  <latitude>$latvalue</latitude>
                  <heading>$heading</heading>
                  <tilt>60</tilt>
                  <range>$range</range>
                  <gx:fovy>60</gx:fovy> 
                  <altitude>0</altitude> 
                  <gx:altitudeMode>relativeToGround</gx:altitudeMode>
              </LookAt>
            </gx:FlyTo>
          ''';
      heading += 10;
      orbit += 1;
    }
    return content;
  }

  static String buildOrbit(String content) {
    String kmlOrbit = '''
<?xml version="1.0" encoding="UTF-8"?>
      <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
        <gx:Tour>
          <name>Orbit Around Indore Rajwada</name>
          <gx:Playlist> 
            $content
          </gx:Playlist>
        </gx:Tour>
      </kml>
    ''';
    return kmlOrbit;
  }
}

class KMLModel {
  String name;
  String content;
  String screenOverlay;

  KMLModel({
    required this.name,
    required this.content,
    this.screenOverlay = '',
  });

  String get body => '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document>
    <name>$name</name>
    <open>1</open>
    <Folder>
      $content
      $screenOverlay
    </Folder>
  </Document>
</kml>
  ''';
  static String generateBlank(String id) {
    return '''
<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
  <Document id="$id">
  </Document>
</kml>
    ''';
  }

  static String generateLinearString(
      String lng, String lat, String range, String tilt, String heading) {
    return '<LookAt><longitude>$lng</longitude><latitude>$lat</latitude><range>$range</range><tilt>$tilt</tilt><heading>$heading</heading><gx:altitudeMode>relativeToGround</gx:altitudeMode></LookAt>';
  }

  static String orbitBalloon(
    String cityImage,
  ) {
    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2"
     xmlns:gx="http://www.google.com/kml/ext/2.2"
     xmlns:kml="http://www.opengis.net/kml/2.2"
     xmlns:atom="http://www.w3.org/2005/Atom">
<Document>
  <name>About Rajwada Palace</name>
  <Style id="about_style">
    <BalloonStyle>
      <textColor>ffffffff</textColor>
      <text>
        <![CDATA[
        <h1>Rajwada Palace</h1>
        <h1>Indore, Madhya Pradesh</h1>
        <img src="$cityImage" alt="Rajwada Palace" width="300" height="200" />
        ]]>
      </text>
      <bgColor>ff15151a</bgColor>
    </BalloonStyle>
  </Style>
  <Placemark id="ab">
    <description></description>
    <LookAt>
      <longitude>75.8677</longitude>
      <latitude>22.7196</latitude>
      <heading>0</heading>
      <tilt>0</tilt>
      <range>200</range>
    </LookAt>
    <styleUrl>#about_style</styleUrl>
    <gx:balloonVisibility>1</gx:balloonVisibility>
    <Point>
      <coordinates>75.8677,22.7196,0</coordinates>
    </Point>
  </Placemark>
</Document>
</kml>

''';
  }

  static String newKML() {
    return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Document>
    <name>Taj Mahal - Agra</name>
    <Style id="fancyPlacemark">
      <IconStyle>
        <color>ff00ffff</color>
        <scale>1.5</scale>
        <Icon>
          <href>https://maps.google.com/mapfiles/kml/shapes/square.png</href>
        </Icon>
      </IconStyle>
      <LabelStyle>
        <color>ffffaa00</color>
        <scale>1.2</scale>
      </LabelStyle>
    </Style>
    <Style id="colorfulPolygon">
      <PolyStyle>
        <color>7dff0000</color>
        <outline>1</outline>
      </PolyStyle>
      <LineStyle>
        <color>ff0000ff</color>
        <width>2</width>
      </LineStyle>
    </Style>
    <Placemark>
      <name>Taj Mahal</name>
      <description>A UNESCO World Heritage Site and one of the Seven Wonders of the World.</description>
      <styleUrl>#fancyPlacemark</styleUrl>
      <Point>
        <coordinates>78.042068,27.173891,0</coordinates>
      </Point>
    </Placemark>
    <Placemark>
      <name>Taj Mahal Area</name>
      <description>A polygon marking the area around the Taj Mahal.</description>
      <styleUrl>#colorfulPolygon</styleUrl>
      <Polygon>
        <outerBoundaryIs>
          <LinearRing>
            <coordinates>
              78.0418,27.1745,0
              78.0424,27.1745,0
              78.0424,27.1755,0
              78.0418,27.1755,0
              78.0418,27.1745,0
            </coordinates>
          </LinearRing>
        </outerBoundaryIs>
      </Polygon>
    </Placemark>
  </Document>
</kml>
''';
  }
}

class ScreenOverlayModel {
  String name;
  String icon;
  double overlayX;
  double overlayY;
  double screenX;
  double screenY;
  double sizeX;
  double sizeY;

  ScreenOverlayModel({
    required this.name,
    this.icon = '',
    required this.overlayX,
    required this.overlayY,
    required this.screenX,
    required this.screenY,
    required this.sizeX,
    required this.sizeY,
  });

  String get tag => '''
      <ScreenOverlay>
        <name>$name</name>
        <Icon>
          <href>$icon</href>
        </Icon>
        <color>ffffffff</color>
        <overlayXY x="$overlayX" y="$overlayY" xunits="fraction" yunits="fraction"/>
        <screenXY x="$screenX" y="$screenY" xunits="fraction" yunits="fraction"/>
        <rotationXY x="0" y="0" xunits="fraction" yunits="fraction"/>
        <size x="$sizeX" y="$sizeY" xunits="pixels" yunits="pixels"/>
      </ScreenOverlay>
    ''';

  factory ScreenOverlayModel.logos() {
    return ScreenOverlayModel(
      name: 'LogoSO',
      icon:
          'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgXmdNgBTXup6bdWew5RzgCmC9pPb7rK487CpiscWB2S8OlhwFHmeeACHIIjx4B5-Iv-t95mNUx0JhB_oATG3-Tq1gs8Uj0-Xb9Njye6rHtKKsnJQJlzZqJxMDnj_2TXX3eA5x6VSgc8aw/s320-rw/LOGO+LIQUID+GALAXY-sq1000-+OKnoline.png',
      overlayX: 0,
      overlayY: 1,
      screenX: 0.02,
      screenY: 0.95,
      sizeX: 500,
      sizeY: 400,
    );
  }
}

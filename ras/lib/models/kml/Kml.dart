import 'package:ras/models/kml/Placemark.dart';
import 'package:ras/models/kml/Polygon.dart';

class KML {
  String name;
  String content;
  String style; //TO DO: Implement different styles for markers

  KML(this.name, this.content,{this.style = ''});

  static buildKMLContent(List<Placemark> placemarks, Polygon polygon) {
    String kmlContent = '';
    if(polygon.coord.length > 0) kmlContent += '\n ${polygon.generateTag()}';
    placemarks.forEach((element) {
      kmlContent += '\n ${element.generateTag()}';
    });

    return kmlContent;
  }

  mount() {
    return '''
<?xml version="1.0" encoding="UTF-8"?>
  <kml xmlns="http://www.opengis.net/kml/2.2" xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns:kml="http://www.opengis.net/kml/2.2" xmlns:atom="http://www.w3.org/2005/Atom">
    <Document>
      <name>$name</name>
        <Style id="s_ylw-pushpin">
          <IconStyle>
            <scale>1.1</scale>
            <Icon>
              <href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
            </Icon>
            <hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
          </IconStyle>
          <LineStyle>
            <color>ff00ffff</color>
          </LineStyle>
          <PolyStyle>
            <color>807fffff</color>
          </PolyStyle>
        </Style>
        <Style id="sn_grn-diamond">
          <IconStyle>
            <scale>1.1</scale>
            <Icon>
              <href>http://maps.google.com/mapfiles/kml/paddle/grn-diamond.png</href>
            </Icon>
            <hotSpot x="32" y="1" xunits="pixels" yunits="pixels"/>
          </IconStyle>
          <BalloonStyle>
          </BalloonStyle>
          <ListStyle>
            <ItemIcon>
              <href>http://maps.google.com/mapfiles/kml/paddle/grn-diamond-lv.png</href>
            </ItemIcon>
          </ListStyle>
        </Style>
        <Style id="s_ylw-pushpin_hl">
          <IconStyle>
            <scale>1.3</scale>
            <Icon>
              <href>http://maps.google.com/mapfiles/kml/pushpin/ylw-pushpin.png</href>
            </Icon>
            <hotSpot x="20" y="2" xunits="pixels" yunits="pixels"/>
          </IconStyle>
          <LineStyle>
            <color>ff00ffff</color>
          </LineStyle>
          <PolyStyle>
            <color>807fffff</color>
          </PolyStyle>
        </Style>
        <StyleMap id="m_ylw-pushpin">
          <Pair>
            <key>normal</key>
            <styleUrl>#s_ylw-pushpin</styleUrl>
          </Pair>
          <Pair>
            <key>highlight</key>
            <styleUrl>#s_ylw-pushpin_hl</styleUrl>
          </Pair>
        </StyleMap>
        <Style id="sh_grn-diamond">
          <IconStyle>
            <scale>1.3</scale>
            <Icon>
              <href>http://maps.google.com/mapfiles/kml/paddle/grn-diamond.png</href>
            </Icon>
            <hotSpot x="32" y="1" xunits="pixels" yunits="pixels"/>
          </IconStyle>
          <BalloonStyle>
          </BalloonStyle>
          <ListStyle>
            <ItemIcon>
              <href>http://maps.google.com/mapfiles/kml/paddle/grn-diamond-lv.png</href>
            </ItemIcon>
          </ListStyle>
        </Style>
        <StyleMap id="msn_grn-diamond">
          <Pair>
            <key>normal</key>
            <styleUrl>#sn_grn-diamond</styleUrl>
          </Pair>
          <Pair>
            <key>highlight</key>
            <styleUrl>#sh_grn-diamond</styleUrl>
          </Pair>
        </StyleMap>
        <Folder>
        $content
        </Folder>
    </Document>
  </kml>
''';
  }
}

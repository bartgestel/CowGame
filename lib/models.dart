import 'package:latlong2/latlong.dart';

enum SpawnType { cow, cloud }

class Spawn {
  final String id;
  final SpawnType type;
  final LatLng position;

  Spawn({required this.id, required this.type, required this.position});
}

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../geo_utils.dart';
import '../models.dart';
import 'catch_cow_screen.dart';
import 'fine_warning_screen.dart';
import 'nitrogen_cloud_screen.dart';
import 'season_end_screen.dart';
import 'shared_widgets.dart';

const _proximityM = 60.0; // how close you must walk to tap a spawn open
const _maxCows = 4; // cap per type — stops spawning that type until some are caught/cleared
const _maxClouds = 3;
const _spawnInterval = Duration(seconds: 12);
const _cowChance = 0.7; // more cows than nitrogen clouds, when both can still spawn
const _spawnMinM = 20.0;
const _spawnMaxM = 70.0;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _mapController = MapController();
  final _random = Random();
  StreamSubscription<Position>? _positionSub;
  Timer? _spawnTimer;
  Timer? _seasonTimer;
  bool _navigating = false;
  bool _fineWarningShown = false; // latched so it only pops up once per high-nitrogen episode

  @override
  void initState() {
    super.initState();
    _startLocation();
    _spawnTimer = Timer.periodic(_spawnInterval, (_) => _maybeSpawn());
    _seasonTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tickSeason());
  }

  Future<void> _startLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }
    if (!await Geolocator.isLocationServiceEnabled()) return;

    _positionSub = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(distanceFilter: 3),
    ).listen(_onPosition);
  }

  void _onPosition(Position position) {
    final appState = context.read<AppState>();
    final wasNull = appState.playerPosition == null;
    appState.playerPosition = position;
    if (wasNull) {
      _mapController.move(LatLng(position.latitude, position.longitude), 17);
      _maybeSpawn(); // seed the first spawn once we know where the player is
    }
    setState(() {}); // refresh marker in-range styling as the player moves
  }

  void _maybeSpawn() {
    final appState = context.read<AppState>();
    final player = appState.playerPosition;
    if (player == null) return;

    final cowCount = appState.spawns.where((s) => s.type == SpawnType.cow).length;
    final cloudCount = appState.spawns.where((s) => s.type == SpawnType.cloud).length;
    final canSpawnCow = cowCount < _maxCows;
    final canSpawnCloud = cloudCount < _maxClouds;
    if (!canSpawnCow && !canSpawnCloud) return; // both types capped — wait for some to clear

    final SpawnType type;
    if (canSpawnCow && canSpawnCloud) {
      type = _random.nextDouble() < _cowChance ? SpawnType.cow : SpawnType.cloud;
    } else {
      type = canSpawnCow ? SpawnType.cow : SpawnType.cloud;
    }

    final center = LatLng(player.latitude, player.longitude);
    final spawn = Spawn(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: type,
      position: randomOffset(center, _spawnMinM, _spawnMaxM),
    );
    setState(() => appState.spawns = [...appState.spawns, spawn]);
  }

  // Walking close enough only unlocks a spawn — it no longer auto-opens the
  // catch screen. The player still has to tap the bubble to enter it.
  void _onSpawnTap(Spawn spawn) {
    if (_navigating) return;
    final player = context.read<AppState>().playerPosition;
    if (player == null ||
        !isWithin(LatLng(player.latitude, player.longitude), spawn.position, _proximityM)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Walk closer to reach it!'), duration: Duration(seconds: 1)),
      );
      return;
    }
    _navigating = true;
    final route = spawn.type == SpawnType.cow
        ? MaterialPageRoute(builder: (_) => CatchCowScreen(spawn: spawn))
        : MaterialPageRoute(builder: (_) => NitrogenCloudScreen(spawn: spawn));
    Navigator.of(context).push(route).then((_) {
      _navigating = false;
    });
  }

  void _tickSeason() {
    final appState = context.read<AppState>();
    appState.tickSecond();

    if (appState.nitrogen < AppState.fineThreshold) {
      _fineWarningShown = false; // reset the latch once nitrogen drops back down
    } else if (!_fineWarningShown && !_navigating) {
      _fineWarningShown = true;
      _navigating = true;
      appState.applyFine();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const FineWarningScreen()))
          .then((_) => _navigating = false);
    }

    if (appState.seasonOver) {
      _spawnTimer?.cancel();
      _seasonTimer?.cancel();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SeasonEndScreen()),
      );
    }
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _spawnTimer?.cancel();
    _seasonTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final player = appState.playerPosition;
    final center = player == null
        ? const LatLng(52.0907, 5.1214) // Utrecht, NL — fallback until GPS fixes
        : LatLng(player.latitude, player.longitude);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(initialCenter: center, initialZoom: 17),
            children: [
              TileLayer(
                // Esri World Imagery: free satellite tiles, no API key —
                // closer to the Figma's Google satellite look than plain OSM.
                urlTemplate:
                    'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                userAgentPackageName: 'com.example.cow_game',
              ),
              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('Esri, Maxar, Earthstar Geographics'),
                ],
              ),
              MarkerLayer(
                markers: [
                  if (player != null)
                    Marker(
                      point: center,
                      width: 44,
                      height: 44,
                      alignment: Alignment.topCenter,
                      child: const _MapPin(color: Color(0xFFE8720B), emoji: '📍'),
                    ),
                  for (final spawn in appState.spawns)
                    Marker(
                      point: spawn.position,
                      width: 44,
                      height: 44,
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () => _onSpawnTap(spawn),
                        child: Opacity(
                          opacity: player != null &&
                                  isWithin(center, spawn.position, _proximityM)
                              ? 1.0
                              : 0.5,
                          child: _MapPin(
                            color: spawn.type == SpawnType.cow
                                ? const Color(0xFF1E8A56)
                                : const Color(0xFFF4A15D),
                            emoji: spawn.type == SpawnType.cow ? '🐄' : '☁️',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NitrogenHud(nitrogen: appState.nitrogen),
                  _SeasonTimer(remaining: appState.seasonRemaining),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: _StatBadge(icon: '💰', value: '€${appState.money.round()}'),
          ),
        ],
      ),
    );
  }
}

// Teardrop map pin with an emoji face, matching the Figma's pin-style
// markers (instead of a bare floating emoji).
class _MapPin extends StatelessWidget {
  final Color color;
  final String emoji;
  const _MapPin({required this.color, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Icon(Icons.location_on, size: 44, color: color),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(emoji, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}

class _SeasonTimer extends StatelessWidget {
  final Duration remaining;
  const _SeasonTimer({required this.remaining});

  @override
  Widget build(BuildContext context) {
    final minutes = remaining.inMinutes;
    final seconds = remaining.inSeconds % 60;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('⏱ $minutes:${seconds.toString().padLeft(2, '0')}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String icon;
  final String value;
  const _StatBadge({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('$icon $value', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
}

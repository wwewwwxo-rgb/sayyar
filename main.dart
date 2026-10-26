import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(const IraqRouteApp());

class IraqRouteApp extends StatelessWidget {
  const IraqRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'درب العراق',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087E8B),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF101820),
      ),
      home: const NavigationHome(),
    );
  }
}

class NavigationHome extends StatefulWidget {
  const NavigationHome({super.key});

  @override
  State<NavigationHome> createState() => _NavigationHomeState();
}

class _NavigationHomeState extends State<NavigationHome> {
  final MapController _mapController = MapController();

  // Initial view: Hillah, Iraq. This is only the starting map view.
  LatLng _center = const LatLng(32.481, 44.433);
  bool _locating = false;
  String _status = 'الخريطة جاهزة — تحديد الموقع يحتاج إذن GPS';

  Future<void> _goToMyLocation() async {
    setState(() {
      _locating = true;
      _status = 'جاري تحديد موقعك...';
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _status = 'فعّل خدمة الموقع GPS من إعدادات الهاتف');
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() => _status = 'لم تمنح إذن الموقع');
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _status = 'إذن الموقع مرفوض نهائياً؛ فعّله من إعدادات التطبيق');
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      final point = LatLng(position.latitude, position.longitude);
      _mapController.move(point, 16);
      setState(() {
        _center = point;
        _status = 'تم تحديد موقعك';
      });
    } catch (_) {
      setState(() => _status = 'تعذّر تحديد الموقع. تحقق من GPS والأذونات والإنترنت');
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature — راح نضيفها بالمرحلة التالية')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 12,
              onTap: (_, point) {
                setState(() => _center = point);
                _showComingSoon('اختيار الوجهة');
              },
            ),
            children: [
              TileLayer(
                // OpenStreetMap standard tiles: respect its usage policy.
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.iraq_route',
              ),
              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('© OpenStreetMap contributors'),
                ],
              ),
            ],
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(18),
                    color: const Color(0xF21B2732),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          const Icon(Icons.route, color: Color(0xFF54D6C8), size: 30),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('درب العراق', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                Text('ملاحة عراقية — نسخة أولية', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'موقعي',
                            onPressed: _locating ? null : _goToMyLocation,
                            icon: _locating
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.my_location),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Material(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xF21B2732),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Icon(Icons.search),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'ابحث عن وجهة — ستُفعّل بالمرحلة القادمة',
                              textAlign: TextAlign.right,
                              style: TextStyle(color: Colors.white70),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _showComingSoon('البحث عن الوجهات'),
                            icon: const Icon(Icons.arrow_back),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Material(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xF21B2732),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(_status, textAlign: TextAlign.right),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton.icon(
                                  onPressed: () => _showComingSoon('بلاغ زحام أو حادث'),
                                  icon: const Icon(Icons.warning_amber_rounded),
                                  label: const Text('بلاغ طريق'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _goToMyLocation,
                                  icon: const Icon(Icons.gps_fixed),
                                  label: const Text('موقعي'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'تنبيه: هذه نسخة تأسيسية؛ لا تعرض ازدحاماً حقيقياً ولا تحسب المسارات بعد.',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 11, color: Colors.orangeAccent),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

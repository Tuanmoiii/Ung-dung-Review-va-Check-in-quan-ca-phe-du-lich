import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class WebMapScreen extends StatelessWidget {
  final List<dynamic> shops;

  const WebMapScreen({super.key, required this.shops});

  @override
  Widget build(BuildContext context) {
    // Lấy vị trí trung tâm từ quán đầu tiên hoặc mặc định
    LatLng center = const LatLng(37.7749, -122.4194); // San Francisco

    if (shops.isNotEmpty && shops[0]['latitude'] != null) {
      center = LatLng(
        shops[0]['latitude'].toDouble(),
        shops[0]['longitude'].toDouble(),
      );
    }

    final markers = shops.where((shop) => shop['latitude'] != null).map((shop) {
      return Marker(
        width: 80,
        height: 80,
        point: LatLng(
          shop['latitude'].toDouble(),
          shop['longitude'].toDouble(),
        ),
        child: GestureDetector(
          onTap: () {
            _showShopDetails(context, shop);
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff9f3b00),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.local_cafe, color: Colors.white, size: 24),
          ),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Shops Map'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xff9f3b00),
        elevation: 0,
      ),
      body: FlutterMap(
        options: MapOptions(initialCenter: center, initialZoom: 12),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(markers: markers),
        ],
      ),
    );
  }

  void _showShopDetails(BuildContext context, dynamic shop) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      shop['imageUrl'] ?? '',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 30),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          shop['name'] ?? 'Unknown',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Color(0xfff8ad1f),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              (shop['rating'] ?? 0).toStringAsFixed(1),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              shop['city'] ?? 'Nearby',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                shop['description'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(
                      context,
                      '/venue-detail',
                      arguments: shop['id'],
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff9f3b00),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('View Details'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

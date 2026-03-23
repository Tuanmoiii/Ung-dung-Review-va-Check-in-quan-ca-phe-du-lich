import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:btl_mobile/services/api_service.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({super.key});

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> with SingleTickerProviderStateMixin {
  String status = 'Scan QR code at partner location';
  bool isProcessing = false;
  bool isCompleted = false;
  int shopId = 1;
  String selectedPanel = 'checkin';
  int _currentNavIndex = 2;
  late AnimationController _scanAnim;

  @override
  void initState() {
    super.initState();
    _scanAnim = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _scanAnim.dispose();
    super.dispose();
  }

  Future<void> _handleCheckIn() async {
    setState(() {
      isProcessing = true;
      status = 'Kiểm tra vị trí GPS...';
    });

    final permissionGranted = await _checkLocationPermission();
    if (!permissionGranted) {
      setState(() {
        status = 'Cần quyền vị trí để kiểm tra check-in.';
        isProcessing = false;
      });
      return;
    }

    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
    } catch (e) {
      setState(() {
        status = 'Không lấy được vị trí GPS: $e';
        isProcessing = false;
      });
      return;
    }

    final shop = await ApiService.getCoffeeShopDetail(shopId);
    if (shop == null) {
      setState(() {
        status = 'Không tìm thấy địa điểm đối tác.';
        isProcessing = false;
      });
      return;
    }

    final shopLat = shop['latitude'];
    final shopLng = shop['longitude'];

    double distance = double.infinity;
    if (shopLat != null && shopLng != null) {
      distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        (shopLat as num).toDouble(),
        (shopLng as num).toDouble(),
      );
    }

    if (distance > 120) {
      setState(() {
        status = 'Khoảng cách ${distance.toStringAsFixed(0)}m, quá xa so với địa điểm. Cần vào gần hơn.';
        isProcessing = false;
      });
      return;
    }

    setState(() {
      status = 'Đang gửi dữ liệu check-in...';
    });

    final result = await ApiService.checkIn(shopId);
    if (result != null) {
      final points = result['pointsEarned'] ?? 0;
      setState(() {
        status = 'Check-in thành công! +$points điểm.';
        isProcessing = false;
        isCompleted = true;
      });
      if (mounted) {
        await ApiService.getUserProfile(result['userId'] ?? 0);
      }
      _showSuccessDialog(shop['name'] ?? 'Địa điểm', points, distance);
      return;
    }

    setState(() {
      status = 'Check-in thất bại. Vui lòng thử lại.';
      isProcessing = false;
    });
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) return false;
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  void _showSuccessDialog(String shopName, int points, double distance) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          title: const Text('Check-in thành công 🎉'),
          content: Text('Bạn đã check-in tại $shopName. +$points điểm\nKhoảng cách: ${distance.toStringAsFixed(0)}m.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(true);
              },
              child: const Text('Hoàn tất'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Go & Chill'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.grey),
        titleTextStyle: const TextStyle(
          color: Color(0xff9f3b00),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Color(0xff9f3b00), size: 18),
                SizedBox(width: 6),
                Text(
                  '1,240 pts',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Go & Chill', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              _drawerItem('Check-in', 'checkin', Icons.qr_code_scanner),
              _drawerItem('Rewards', 'rewards', Icons.card_giftcard),
              _drawerItem('7-day Streak', 'streak', Icons.local_fire_department),
              _drawerItem('Recommended', 'recommended', Icons.thumb_up),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Close'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Ready to Chill?',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Scan the QR code at any partner lounge or cafe to start earning rewards.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 350,
                      child: Image.network(
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBbyIx0CanmEkU_ZpyuVvGq5BIx3SfhaiZYzGzYp5wQDhdYbdNrNHKUFPaJhjrwDxmcrzBnHXhMoF_bzwIcOooBOpeERhyghKKjrfO3MtdnrlVMR1HFsXLeJW2JbrKTBlY6oGx2e0SCNXt-QkqmK_LAZX1oXdtlOgugdOWvcUaARmwkbuitUfFM82ARLKIVLsp2KaBYOFBiwhNz-EkMu7AL93HDDCkXB4Vbl0EZ5OHyojykAXI6kmYSLt9d-vs-8_yZ2uYOfvN0wtM',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 350,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.black.withOpacity(0.35),
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          Text(
                            'NEAR "The Roast"',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Expanded(
                            child: Center(
                              child: Stack(
                                children: [
                                  Container(
                                    width: 220,
                                    height: 220,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.orange.withOpacity(0.8), width: 3),
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  AnimatedBuilder(
                                    animation: _scanAnim,
                                    builder: (context, child) {
                                      return Positioned(
                                        top: _scanAnim.value * 220,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                          height: 2,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.transparent,
                                                Colors.orange.withOpacity(0.9),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  const Center(
                                    child: Icon(
                                      Icons.qr_code_scanner,
                                      color: Colors.white70,
                                      size: 60,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            status,
                            style: const TextStyle(color: Colors.white, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              if (selectedPanel == 'checkin')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: isProcessing || isCompleted ? null : _handleCheckIn,
                    icon: const Icon(Icons.bolt),
                    label: const Text('Check-in to earn points'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff9f3b00),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              if (selectedPanel != 'checkin')
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      selectedPanel == 'rewards'
                          ? 'Unlockable rewards will show here in next step.'
                          : selectedPanel == 'streak'
                              ? 'Complete daily check-ins to grow your streak.'
                              : 'Recommended spots for you will appear here.',
                      style: const TextStyle(fontSize: 14, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              const SizedBox(height: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Unlockable Rewards',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'See all',
                            style: TextStyle(fontSize: 14, color: Color(0xff9f3b00), fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'LIMITED TIME',
                                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Free Oat Milk\nUpgrade',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Check-in at 3 more cafes',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Icon(Icons.coffee, size: 48, color: Colors.blue[700]),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: const Border(bottom: BorderSide(color: Color(0xff9f3b00), width: 4)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.local_fire_department, color: Color(0xff9f3b00), size: 24),
                                  const SizedBox(height: 8),
                                  const Text('7-Day Streak', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 2),
                                  Text('+500 Bonus Pts', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: const Border(bottom: BorderSide(color: Color(0xff2d6084), width: 4)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.confirmation_number, color: Color(0xff2d6084), size: 24),
                                  const SizedBox(height: 8),
                                  const Text('Half Price Day', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 2),
                                  Text('Unlocks at Level 5', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 70,
                        height: 90,
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuArCTsJMe59qdlTW_K3btrSYVUyExHjVjwIOepfsR9H4ZYdVxrKlAOLN0KhacY0Y0aNCqRl8NeMRs0fzwRMf7SGnMAA3CXEol4McwK17-vpH09YyUKAbHbw09K3r1Ci0DiGbsHaER2S2CJ4K9OWjQwQlu5Pjv9xVAcVgdoKpdIZdGLHBxfUpWvfXGFJu3PR9jTnq0vPszeUWwpKebMYYdo60ahPCR-04x8f4TJh6ldp3SOnO_EBxmJ4uGmXlmAlT1BZomuM4AWJ7d0',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'RECOMMENDED SPOT',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xff9f3b00)),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.star, size: 16, color: Color(0xff9f3b00)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'The Roast & Co.',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Artisan brews and quiet corners for focused deep work.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('Wi-Fi 6', style: TextStyle(fontSize: 10)),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text('Quiet Zone', style: TextStyle(fontSize: 10)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavButton('Home', Icons.home, 0),
              _buildNavButton('Search', Icons.search, 1),
              _buildCheckInButton(),
              _buildNavButton('Community', Icons.group, 3),
              _buildNavButton('Profile', Icons.person, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(String label, IconData icon, int index) {
    bool isActive = _currentNavIndex == index;
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (index == 1) {
          Navigator.pushReplacementNamed(context, '/explore');
        } else if (index == 3) {
          Navigator.pushReplacementNamed(context, '/community');
        } else if (index == 4) {
          Navigator.pushReplacementNamed(context, '/profile');
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? const Color(0xff9f3b00) : Colors.grey[600], size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              color: isActive ? const Color(0xff9f3b00) : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckInButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xff9f3b00).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.qr_code_scanner, color: Color(0xff9f3b00), size: 24),
          const SizedBox(height: 4),
          const Text(
            'Check-in',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Color(0xff9f3b00),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(String label, String key, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: selectedPanel == key,
      onTap: () {
        setState(() {
          selectedPanel = key;
        });
        Navigator.of(context).pop();
      },
    );
  }
}



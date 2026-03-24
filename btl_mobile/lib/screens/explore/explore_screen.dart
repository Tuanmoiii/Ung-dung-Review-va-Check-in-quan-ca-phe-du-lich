import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:btl_mobile/services/api_service.dart';
import 'package:btl_mobile/screens/explore/web_map_screen.dart';
import 'package:btl_mobile/screens/checkin/checkin_code_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All'; // Đổi mặc định thành 'All'
  bool _isLoading = true;
  List<dynamic> _allShops = [];
  List<dynamic> _filteredShops = [];

  final List<Map<String, dynamic>> _filters = [
    {'label': 'All', 'icon': Icons.apps, 'tag': ''}, // Thêm nút All
    {'label': 'Aesthetic', 'icon': Icons.auto_awesome, 'tag': 'aesthetic'},
    {'label': 'Nature', 'icon': Icons.forest, 'tag': 'nature'},
    {'label': 'Quiet', 'icon': Icons.volume_off, 'tag': 'quiet'},
    {'label': 'WiFi', 'icon': Icons.wifi, 'tag': 'wifi'},
    {'label': 'Parking', 'icon': Icons.local_parking, 'tag': 'parking'},
  ];

  @override
  void initState() {
    super.initState();
    _loadCoffeeShops();
    _searchController.addListener(_onSearchChanged);
    print('✅ Search listener added');
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCoffeeShops() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final shops = await ApiService.getCoffeeShops();

      // Debug: In ra cấu trúc của shop đầu tiên
      if (shops.isNotEmpty) {
        print('=== First shop structure ===');
        print(shops[0].keys);
        print('Name: ${shops[0]['name']}');
        print('Description: ${shops[0]['description']}');
        print('City: ${shops[0]['city']}');
        print('Tags: ${shops[0]['tags']}');
        print('============================');
      }

      setState(() {
        _allShops = shops;
        _filteredShops = shops;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading coffee shops: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged() {
    print('🔍 Search changed: "${_searchController.text}"'); // Thêm debug
    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase().trim();
    final selectedFilter = _filters.firstWhere(
      (f) => f['label'] == _selectedFilter,
      orElse: () => {'tag': ''},
    );
    final selectedTag = selectedFilter['tag'];

    print('=== FILTER DEBUG ===');
    print('Query: "$query"');
    print('Selected filter: ${selectedFilter['label']}');
    print('Selected tag: "$selectedTag"');

    // Bước 1: Lọc theo search
    var filtered = _allShops.where((shop) {
      final name = shop['name']?.toLowerCase() ?? '';
      return query.isEmpty || name.contains(query);
    }).toList();

    // Bước 2: Lọc theo tag (chỉ lọc nếu không phải "All")
    if (selectedTag.isNotEmpty) {
      filtered = filtered.where((shop) {
        if (shop['tags'] == null) return false;
        final tags = List<String>.from(shop['tags']);
        return tags.any((tag) => tag.toLowerCase().contains(selectedTag));
      }).toList();
    }

    print('Filtered results: ${filtered.length}');
    for (var shop in filtered) {
      print('  ✅ ${shop['name']}');
    }

    setState(() {
      _filteredShops = filtered;
    });
  }

  void _onFilterSelected(String label) {
    setState(() {
      _selectedFilter = label;
    });
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xff4b2508)),
        title: const Text(
          'Go & Chill',
          style: TextStyle(
            color: Color(0xff9f3b00),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadCoffeeShops,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  // Search Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Find your next retreat...',
                          hintStyle: TextStyle(color: Colors.grey[500]),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey[600],
                          ),
                          suffixIcon: Icon(
                            Icons.tune,
                            color: const Color(0xff9f3b00),
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Filters Scrollable
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: _filters.map((filter) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _filterChip(
                            filter['label'],
                            filter['icon'],
                            _selectedFilter == filter['label'],
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Map Preview Hero
                  _buildMapPreview(),

                  const SizedBox(height: 32),

                  // Search Results Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _searchController.text.isEmpty
                              ? 'Curated for You'
                              : 'Search Results (${_filteredShops.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_filteredShops.length > 3)
                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              'See all',
                              style: TextStyle(
                                color: Color(0xff9f3b00),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Results List
                  if (_filteredShops.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No results found',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try a different search or filter',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // Hiển thị 3 quán đầu tiên
                          for (
                            int i = 0;
                            i < _filteredShops.length && i < 3;
                            i++
                          )
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _venueCard(_filteredShops[i]),
                            ),

                          // Recommended Card (chỉ hiển thị nếu có đủ dữ liệu)
                          if (_filteredShops.length > 2)
                            _recommendedCard(_filteredShops[2]),
                        ],
                      ),
                    ),

                  const SizedBox(height: 120),
                ],
              ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildMapPreview() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 192,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: NetworkImage(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuA5S74VvJSa6M81AC6m6tRItNAvBIT13iqN-eARNgssNKAwY-bBTU4MJMEuk4PZvyocS1Tmn2Rp3rdNWkOA73MkSBONNF4Kr1JIUm1RJ7cclN5eUAbjiMcIaxXwHNu21iVIhw9sMLCRjYgRgHqYR8cPF4fKvU5AzRcSwHq3ytfx6ZCMad4gmdiPeCwHsEJOW_Vsr7LUrBaCqXPgxazr3-Ve3r7896xNfeyzp8iBrNmOcLPcQRqVyRHaLUUujDAe7yjRk2ffzWqySKs',
            ),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0),
                  ],
                ),
              ),
            ),
            ..._getMapMarkers(),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Orbit',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Nearby in Copenhagen',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              WebMapScreen(shops: _filteredShops),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xff4b2508),
                      elevation: 8,
                      shadowColor: Colors.black.withOpacity(0.3),
                    ),
                    child: const Text(
                      'Expand Map',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getMapMarkers() {
    List<Widget> markers = [];
    final positions = [
      {'top': 96, 'left': 128},
      {'top': 48, 'right': 96},
      {'bottom': 80, 'left': 200},
    ];

    for (int i = 0; i < _filteredShops.length && i < 3; i++) {
      final pos = positions[i % positions.length];
      markers.add(
        Positioned(
          top: pos['top'] as double?,
          bottom: pos['bottom'] as double?,
          left: pos['left'] as double?,
          right: pos['right'] as double?,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: const Color(0xff9f3b00),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
              ],
            ),
          ),
        ),
      );
    }
    return markers;
  }

  Widget _filterChip(String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => _onFilterSelected(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xff7c5300) : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 14,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _venueCard(dynamic shop) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/venue-detail',
          arguments: shop['id'], // Truyền trực tiếp id (int)
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Image.network(
                    shop['imageUrl'] ??
                        'https://via.placeholder.com/400x300?text=No+Image',
                    height: 256,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 256,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image, size: 50),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.favorite_border,
                            color: shop['isFeatured'] == true
                                ? const Color(0xff9f3b00)
                                : Colors.grey[600],
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (shop['isFeatured'] == true)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff934600),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'FEATURED',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            shop['name'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xfff8ad1f).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Color(0xff7c5300),
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                (shop['rating'] ?? 0).toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff7c5300),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      shop['description'] ?? '',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.verified,
                              color: Color(0xff9f3b00),
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Verified Check-in',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff9f3b00),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          shop['city'] ?? 'Nearby',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _recommendedCard(dynamic shop) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/venue-detail',
          arguments: shop['id'], // Truyền trực tiếp id (int)
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.near_me, color: Color(0xff9f3b00)),
                const SizedBox(width: 8),
                const Text(
                  'Recommended Spot',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff9f3b00),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              shop['name'] ?? 'Recommended',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              shop['description'] ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuBvIurIghX2bNN7m8V9a3Vb2TzkWOgVkUgT89FlXkZ836XkLuF_5WDU95QP5qH1sHD27bpl-0-w-e9bQkN_5Rjq5yFAktAvwNETFvgIAE4a6afbHGVNxG7Y_v3YK5nnk36QJYPEy4F9TFdaG5LtygUQwWStsFmCuHkbzeNXOIWMqgUfCml2ZjiLpPMqy722u-r4dQfO6rpXvGVkNrP-Z2slFD8iGlf2FEqlDKUI6Hz7F6m6vIJTewELpfCGPr6BRpt7f66OMQBFCHg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuDiJ9I7w6oBgeATiyOWYTQ4OJkI9HINt8HjGgBvrUBilxiGlzlfjpu9ARJ2eeYY2O2dL_LCQ1hBI4hwx9zw4MbcT7eijeNeZmfz1sd68XiMpmsLZhW743Au6Lg3w6zkNT8n7A-FMdPhHXz2SzJeskUJSI9Wd2_A_cHmyGwmC3Qt7yu6rVq_Kd8ZijM6oRUcKL_vzklx5RbWk4sRFqQAN0iPh1fdrhk0K7QNVoR5QDgLKkLzTMVs7bP2xk9okqP3EqZspKmmoGcbtBk',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 40,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: Color(0xff9f3b00),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '+12',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                const Text(
                  'Friends checked-in here',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff9f3b00),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navButton('Home', Icons.home, 0, () {
              Navigator.pushReplacementNamed(context, '/home');
            }),
            _navButton('Search', Icons.search, 1, () {}, isActive: true),
            _fabCheckIn(() {}),
            _navButton('Community', Icons.group, 3, () {
              Navigator.pushReplacementNamed(context, '/community');
            }),
            _navButton('Profile', Icons.person, 4, () {
              Navigator.pushReplacementNamed(context, '/profile');
            }),
          ],
        ),
      ),
    );
  }

  Widget _navButton(
    String label,
    IconData icon,
    int index,
    VoidCallback onTap, {
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xff9f3b00) : Colors.grey[600],
            size: 24,
          ),
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

  Widget _fabCheckIn(VoidCallback onTap) {
    return Transform.translate(
      offset: const Offset(0, -16),
      child: GestureDetector(
        onTap: () {
          _showCheckInDialog(); // Bỏ qua onTap tham số
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xff9f3b00),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff9f3b00).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Check-in',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCheckInDialog() {
    int? selectedShopId;
    String? selectedShopName;
    final TextEditingController searchController = TextEditingController();
    List<dynamic> allShops = [];
    List<dynamic> filteredShops = [];
    bool isLoading = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          // Load tất cả quán khi mở dialog
          if (allShops.isEmpty && isLoading) {
            ApiService.getCoffeeShops().then((shops) {
              setStateDialog(() {
                allShops = shops;
                filteredShops = shops;
                isLoading = false;
              });
            });
          }

          return AlertDialog(
            title: const Text('Check-in'),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Thanh tìm kiếm
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setStateDialog(() {
                        if (value.isEmpty) {
                          filteredShops = allShops;
                        } else {
                          filteredShops = allShops.where((shop) {
                            final name = shop['name']?.toLowerCase() ?? '';
                            return name.contains(value.toLowerCase());
                          }).toList();
                        }
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Tìm quán cà phê...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Danh sách quán
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (filteredShops.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('Không tìm thấy quán nào'),
                    )
                  else
                    Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredShops.length,
                        itemBuilder: (context, index) {
                          final shop = filteredShops[index];
                          final isSelected = selectedShopId == shop['id'];
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                shop['imageUrl'] ?? '',
                                width: 44,
                                height: 44,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 44,
                                      height: 44,
                                      color: Colors.grey[200],
                                      child: const Icon(Icons.image, size: 24),
                                    ),
                              ),
                            ),
                            title: Text(
                              shop['name'] ?? 'Coffee Shop',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              shop['city'] ?? 'Nearby',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            trailing: isSelected
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Color(0xff9f3b00),
                                  )
                                : null,
                            onTap: () {
                              setStateDialog(() {
                                selectedShopId = shop['id'];
                                selectedShopName = shop['name'];
                              });
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (selectedShopId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng chọn quán')),
                    );
                    return;
                  }

                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckinCodeScreen(
                        coffeeShopId: selectedShopId!,
                        coffeeShopName: selectedShopName ?? 'Coffee Shop',
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff9f3b00),
                ),
                child: const Text('Check-in'),
              ),
            ],
          );
        },
      ),
    );
  }
}

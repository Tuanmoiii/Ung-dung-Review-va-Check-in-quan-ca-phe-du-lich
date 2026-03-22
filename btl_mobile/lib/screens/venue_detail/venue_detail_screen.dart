import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:btl_mobile/services/api_service.dart'; // Thêm import

const Color _colorSecondaryContainer = Color(0xFFFFD8C2);
const Color _colorOnPrimaryContainer = Color(0xFFFFFFFF);
const Color _colorPrimary = Color(0xFF9F3B00);
const Color _colorSecondary = Color(0xFF934600);
const Color _colorSurface = Color(0xFFFFF4F0);
const Color _colorSurfaceContainer = Color(0xFFFFE3D3);
const Color _colorSurfaceContainerLow = Color(0xFFFFEDE4);
const Color _colorSurfaceContainerLowest = Color(0xFFFFFFFF);
const Color _colorOnSurface = Color(0xFF4B2508);
const Color _colorOnSurfaceVariant = Color(0xFF805030);
const Color _colorOutlineVariant = Color(0xFFDCA07A);
const Color _colorTertiaryContainer = Color(0xFFF8AD1F);
const Color _colorOnTertiaryContainer = Color(0xFF4F3300);
const Color _colorOnSecondaryContainer = Color(0xFF743600);
const Color _colorPrimaryContainer = Color(0xFFFF793A);

class VenueDetailScreen extends StatefulWidget {
  final int? venueId; // Thêm venueId

  const VenueDetailScreen({super.key, this.venueId});

  @override
  State<VenueDetailScreen> createState() => _VenueDetailScreenState();
}

class _VenueDetailScreenState extends State<VenueDetailScreen> {
  int _currentNavIndex = 0;
  bool _isLoading = true;
  Map<String, dynamic>? _venueData;
  List<dynamic> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadVenueDetail();
  }

  Future<void> _loadVenueDetail() async {
    if (widget.venueId == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final venue = await ApiService.getCoffeeShopDetail(widget.venueId!);
      final reviews = await ApiService.getReviewsByCoffeeShop(widget.venueId!);

      setState(() {
        _venueData = venue;
        _reviews = reviews;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading venue: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Lấy tên quán
  String get _shopName {
    return _venueData?['name'] ?? 'The Roasted Bean';
  }

  // Lấy rating
  double get _rating {
    return (_venueData?['rating'] ?? 4.9).toDouble();
  }

  // Lấy số lượng reviews
  int get _totalReviews {
    return _venueData?['totalReviews'] ?? 248;
  }

  // Lấy price range
  String get _priceRange {
    return _venueData?['priceRange'] ?? '\$\$';
  }

  // Lấy địa chỉ
  String get _address {
    return _venueData?['address'] ??
        '124 Artisan Alley, Creative District\nSan Francisco, CA 94103';
  }

  // Lấy ảnh chính
  String get _imageUrl {
    return _venueData?['imageUrl'] ??
        'https://lh3.googleusercontent.com/aida-public/AB6AXuD7gvByok6ygUOqgD9kZporoKWyXMLjOigZrpQ7lyEbAs4xVd3xvFbqQs05qtnNqFx_0SvFpGvKs0w5ngRIB7HUtf8a9XXmRnBbIzgahIMtuU6Sbf3Fd2jCD8kuiyqfskR42scGdVWgTDZDTJos0Ppgnk3VqL8URJObZj-iqM7XD74y_cj8uaAwZ8vaAsK4u_6eB8PXL4jCHJ5kZLGS6xegdS0P_6dlTlxb3nNJ8js_Ymbx7EL0DMeOgoFnr9LOXNAGiqW71a--FG0';
  }

  String _getPriceRangeText(String? priceRange) {
    if (priceRange == r'$$$') return 'Expensive Pricing';
    if (priceRange == r'$$') return 'Moderate Pricing';
    return 'Affordable Pricing';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: _colorSurface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: _colorSurface,
      body: CustomScrollView(
        slivers: [
          // Top Navigation
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Color.lerp(_colorSurface, Colors.black, 0.05),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: _colorOnSurface),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Go & Chill',
              style: TextStyle(
                color: _colorOnSurface,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.share, color: _colorOnSurface),
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: _colorSurfaceContainerLow,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.favorite_border, color: _colorOnSurface),
                onPressed: () {},
                style: IconButton.styleFrom(
                  backgroundColor: _colorSurfaceContainerLow,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
          // Main Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Gallery
                _heroGallery(_imageUrl),
                const SizedBox(height: 32),
                // Header Info
                _headerInfo(_shopName, _rating, _totalReviews, _priceRange),
                const SizedBox(height: 40),
                // Location & Hours Grid
                _locationHoursGrid(_address),
                const SizedBox(height: 48),
                // Menu Highlights
                _menuHighlights(),
                const SizedBox(height: 48),
                // Community Buzz
                _communityBuzz(),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNav(),
      floatingActionButton: _fab(),
    );
  }

  Widget _heroGallery(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 450,
        child: GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Main image
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: _colorSurfaceContainer,
                        child: const Icon(Icons.image),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      left: 16,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _colorSurface.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified,
                                  size: 14,
                                  color: _colorPrimary,
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Top Rated 2024',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: _colorOnSurface,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Side image 1 (có thể thay bằng ảnh từ API gallery nếu có)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCBWRBz7sNwXzpE28KlcRF6hXCQwlHOLsn_-4uLwr3IuPXhz3LJtqJsnkk6KOzJm5mGaWZPZJ5DmtUimp41L3ODh5RV0iCCniBgVxkeJ9ZenpRhB0dQFazlfz2E61VG9q_r7k1V8YGgTY9935hCiQoIYMl1pAKsFIm5tk4w0i7BYh2gqjVMaMBWQMjOlP-IP_4EW238DYdBP5vmupoGmgU9qHWBXRUEsTuTuXFz17s2PJadJoF98yG_7CugX_yFCI16xBiVF0ZaltA',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: _colorSurfaceContainer,
                    child: const Icon(Icons.image),
                  ),
                ),
              ),
            ),
            // Side image 2
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuBVSoajGFj6fQG1nUMhV8uhOwj8RBtHxuUZUb_xb99_PBQrdmR2TJHBMYxEOwM2eOeQRmzpvQcN4EUB-OgLkzFCc76EGBGSHnpDg-RtY50_n6Fo7tovUyG_v3g0z0CZ266JzQ8hPYXf3pIbP4ZU9P6-fH3ACDIn0MAhCLl1arYxFif_pjJTcQJeZ4WpxEmibgpOhesM3OKUz59XkKdx2gug2ZyMtLpUmAzuY8rzQExVfGXLDdoqXZCyGlP9S8kgHQ9u3uFBG57aduI',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withOpacity(0.3),
                      colorBlendMode: BlendMode.darken,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: _colorSurfaceContainer,
                        child: const Icon(Icons.image),
                      ),
                    ),
                    const Center(
                      child: Text(
                        '+12',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerInfo(
    String name,
    double rating,
    int totalReviews,
    String priceRange,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: _colorOnSurface,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _colorTertiaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      size: 14,
                      color: _colorOnTertiaryContainer,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _colorOnTertiaryContainer,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '($totalReviews reviews)',
                      style: TextStyle(
                        fontSize: 12,
                        color: _colorOnTertiaryContainer.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  const Icon(
                    Icons.payments,
                    size: 14,
                    color: _colorOnSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _getPriceRangeText(priceRange),
                    style: const TextStyle(
                      fontSize: 13,
                      color: _colorOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                if (widget.venueId != null) {
                  ApiService.checkIn(widget.venueId!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Check-in thành công! +10 points'),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Check-in Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _colorPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 4,
                shadowColor: _colorPrimary.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationHoursGrid(String address) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Location Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _colorSurfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _colorOnSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: _colorPrimary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(
                            color: _colorOnSurfaceVariant,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[300],
                    ),
                    child: const Center(
                      child: Text(
                        'Open in Maps',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _colorOnSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Hours Card
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: _colorSurfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Operating Hours',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _colorOnSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _hoursRow('Mon - Fri', '07:30 AM - 06:00 PM'),
                  _hoursRow('Saturday', '08:00 AM - 08:00 PM'),
                  _hoursRow('Sunday', '09:00 AM - 04:00 PM', isToday: true),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _colorSurfaceContainerLowest.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bolt, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        const Text(
                          'Peak Hours: 10:00 AM - 12:00 PM',
                          style: TextStyle(
                            fontSize: 12,
                            color: _colorOnSurfaceVariant,
                          ),
                        ),
                      ],
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

  Widget _hoursRow(String day, String hours, {bool isToday = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                day,
                style: TextStyle(
                  fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                  color: isToday ? _colorPrimary : _colorOnSurface,
                ),
              ),
              if (isToday) ...[
                const SizedBox(width: 8),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: _colorPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
          Text(
            hours,
            style: TextStyle(
              fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
              color: isToday ? _colorPrimary : _colorOnSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuHighlights() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Menu Highlights',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _colorOnSurface,
                ),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Text('View Full Menu'),
                label: const Icon(Icons.arrow_forward, size: 16),
                style: TextButton.styleFrom(
                  foregroundColor: _colorPrimary,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _menuItem(
                  'Double Espresso',
                  'Ethopian Yirgacheffe',
                  '\$4.50',
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuD7t-FL58M4NNQOFgd33iWftaUgVMfxQoUsDdTJUSileRCDDdNi3ql4cbKjNd8RMm5mGaWZPZJ5DmtUimp41L3ODh5RV0iCCniBgVxkeJ9ZenpRhB0dQFazlfz2E61VG9q_r7k1V8YGgTY9935hCiQoIYMl1pAKsFIm5tk4w0i7BYh2gqjVMaMBWQMjOlP-IP_4EW238DYdBP5vmupoGmgU9qHWBXRUEsTuTuXFz17s2PJadJoF98yG_7CugX_yFCI16xBiVF0ZaltA',
                ),
                const SizedBox(width: 16),
                _menuItem(
                  'Signature Avo-Toast',
                  'Sourdough & Chili Flakes',
                  '\$14.00',
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDxCR2u9ZAPqQjPDneQrrTX8aMpDuXyZFZF2oN_Z1u_21klp_c8tdwuggymfYSxfCjHzaFsTUCSPIQ1D4F-HZGn909WWntnIsp566_yaS43i39ajt4T3o8Y5qN1XjpBexEeITdsekswWriza5h-xNxfm0qJU9U9QyWboXqN6jFhxSUlxKr1iyxrIFOnj_mX5Iufu6oxoOy7UaPJuXX9Y-k9sjKTIYRxzJo7zw35MRNAtaqcEVtwN0Cb3fz6MUEdUrTsKExl43l0WV0',
                ),
                const SizedBox(width: 16),
                _menuItem(
                  '12hr Cold Brew',
                  'Nutty & Smooth',
                  '\$6.50',
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuDBVo5pp8-B0MX8w3kZ962idnWHah-xGdnWqTAD-v4QRaAbPePJyVpSoviuposZjtcGHJVzrFwlDqctVQAj26ngfB_KSaw_p3jDBLzi0H4R2fwbjglZNx1_R9qBW4EhgyAYCvviE3As1FVoVnh96w5Ym-7Jqu85V_TBjUZdxmSGLDd_ldQHsYMQnC3rbAuCAG1DPu_70XOQGxyuF0DFZxeDHCfLZRGnwEUzd7GMJnOBr1LQxa6x8jbumWFdteGWuXTcylC5tRlrCwg',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
    String name,
    String description,
    String price,
    String imageUrl,
  ) {
    return Container(
      width: 256,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _colorSurfaceContainerLowest,
        border: Border.all(color: _colorOutlineVariant.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: _colorSurfaceContainer,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: _colorSurfaceContainer,
                    child: const Icon(Icons.restaurant),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: _colorOnSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _colorOnSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: _colorPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _communityBuzz() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Community Buzz',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _colorOnSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _colorSurfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Sort by: Recent',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _colorOnSurface,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.expand_more,
                      size: 16,
                      color: _colorOnSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (_reviews.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Text('Chưa có đánh giá nào'),
              ),
            )
          else
            ..._reviews.map(
              (review) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _reviewCard(
                  review['userName'] ?? 'Anonymous',
                  review['isVerified'] == true ? "Verified ✓" : "User",
                  review['content'] ?? '',
                  _formatTime(review['createdAt']),
                  review['likes'].toString(),
                  '0',
                  review['userAvatar'],
                  review['images'] != null
                      ? List<String>.from(review['images'])
                      : [],
                ),
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _colorSurfaceContainerLow,
                foregroundColor: _colorOnSurface,
                padding: const EdgeInsets.symmetric(vertical: 16),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Write a review',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String? dateTime) {
    if (dateTime == null) return 'Recently';
    try {
      final date = DateTime.parse(dateTime);
      final difference = DateTime.now().difference(date);
      if (difference.inDays > 7)
        return '${(difference.inDays / 7).floor()} weeks ago';
      if (difference.inDays > 0) return '${difference.inDays} days ago';
      if (difference.inHours > 0) return '${difference.inHours} hours ago';
      if (difference.inMinutes > 0)
        return '${difference.inMinutes} minutes ago';
      return 'Just now';
    } catch (e) {
      return 'Recently';
    }
  }

  Widget _reviewCard(
    String name,
    String subtitle,
    String review,
    String time,
    String likes,
    String comments,
    String? avatarUrl,
    List<String> photos,
  ) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _colorSurfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _colorPrimaryContainer,
                        width: 2,
                      ),
                    ),
                    child: avatarUrl != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(
                              avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    color: _colorSecondaryContainer,
                                    child: const Icon(
                                      Icons.person,
                                      color: _colorOnSecondaryContainer,
                                    ),
                                  ),
                            ),
                          )
                        : Container(
                            color: _colorSecondaryContainer,
                            child: const Icon(
                              Icons.person,
                              color: _colorOnSecondaryContainer,
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _colorOnSurface,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: _colorOnSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (subtitle.contains('Verified'))
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _colorOnSecondaryContainer.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.verified_user,
                        size: 12,
                        color: _colorOnSecondaryContainer,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Verified',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: _colorOnSecondaryContainer,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            review,
            style: const TextStyle(color: _colorOnSurfaceVariant, height: 1.5),
          ),
          if (photos.isNotEmpty) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 96,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: photos
                    .map(
                      (photo) => Container(
                        width: 96,
                        height: 96,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: _colorSurfaceContainer,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            photo,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: _colorSurfaceContainer,
                                  child: const Icon(Icons.image),
                                ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: _colorOutlineVariant.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _interactionButton(Icons.thumb_up_outlined, likes),
                    const SizedBox(width: 16),
                    _interactionButton(Icons.chat_bubble_outline, comments),
                  ],
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: _colorOnSurfaceVariant,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _interactionButton(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _colorOnSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          count,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _colorOnSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _bottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: _colorSurface.withOpacity(0.8),
        border: Border(
          top: BorderSide(color: _colorOutlineVariant.withOpacity(0.2)),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(color: _colorSurface.withOpacity(0.8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.home, 'Home', 0),
                _navItem(Icons.search, 'Search', 1),
                _navItem(Icons.qr_code_scanner, 'Check-in', 2),
                _navItem(Icons.group, 'Community', 3),
                _navItem(Icons.person, 'Profile', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isActive = index == _currentNavIndex;
    return GestureDetector(
      onTap: () {
        setState(() => _currentNavIndex = index);
        final routes = ['/home', '/explore', '/community', '/profile'];
        if (index < routes.length && index != 2) {
          Navigator.pushReplacementNamed(context, routes[index]);
        }
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: isActive ? _colorPrimaryContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive
                  ? _colorOnPrimaryContainer
                  : _colorOnSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isActive
                    ? _colorOnPrimaryContainer
                    : _colorOnSurfaceVariant,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fab() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: _colorOnSurface,
      foregroundColor: _colorSurface,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: const Icon(Icons.add_shopping_cart),
    );
  }
}

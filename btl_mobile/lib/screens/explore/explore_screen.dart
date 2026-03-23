import 'dart:ui';
import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'Aesthetic';

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
      body: ListView(
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
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  suffixIcon: Icon(Icons.tune, color: const Color(0xff9f3b00)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
              children: [
                _filterChip('Aesthetic', Icons.auto_awesome, true),
                const SizedBox(width: 8),
                _filterChip('Nature', Icons.forest, false),
                const SizedBox(width: 8),
                _filterChip('Quiet', Icons.volume_off, false),
                const SizedBox(width: 8),
                _filterChip('WiFi', Icons.wifi, false),
                const SizedBox(width: 8),
                _filterChip('Parking', Icons.local_parking, false),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Map Preview Hero
          Padding(
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
                  // Mock Map Pins
                  Positioned(
                    top: 96,
                    left: 128,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xff9f3b00),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 48,
                    right: 96,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: const Color(0xff7c5300),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
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
                          onPressed: () {},
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
          ),

          const SizedBox(height: 32),

          // Search Results Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Curated for You',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Result 1
                _venueCard(
                  title: 'The Arch Brews',
                  image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBZuD04YLn673cGSkOh_tTANlS8nQMH7tXcNCJf04pEyRerfKslaCdh-n7d78QvKAh7Gy5XUuZ8uEY7ku4ijN3C0iMP_m7L0ueES1td-7BDHGGc1wm-keMoApYFBNr-Xis3Khbq9qfnxIQ_JwDYT-ycAON777OsjCQCTi0IZDVkfc-F6s4GR55VD8byzW-D4P9G03_JRilOGAoJYDzsskAxBHxiwdXu14cjJriUQWuLUNH90m2zXU1c18fMHWl71LgxW0wV5xYKH7s',
                  rating: 4.9,
                  description: 'Art-deco inspired space with curated indie playlists.',
                  isFeatured: true,
                  distance: '0.4 km away',
                  onTap: () => Navigator.pushNamed(context, '/venue-detail'),
                ),

                const SizedBox(height: 16),

                // Result 2
                _venueCard(
                  title: 'Pages & Steam',
                  image: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD99ejRGnUhjM6e1MLLfaK_p1mfUGmJXyjG8RvXSj5pQTwg8aGUe49syARvXE3RbGt_4hZdDu56buJtEwvL2jsm6qid9w9hIeUgWQZ_pYg7V8cEyXXhrYANNqaMkiBl_Nt__Fe1FBYMDZBmiRxraTpW2bTwGSgSAx7T32THx4-GJcX_iKXrOFydVQSsAQ75LmIzAnx6xaGKa685TIyjqXW3ZUx8eAJjLsZSaCKtcmJ-kZj8G3dR1CZRZAa1po1VdSI9OlGbOWVSc74',
                  rating: 4.7,
                  description: 'A sanctuary for book lovers. No laptops after 6 PM.',
                  isFeatured: false,
                  distance: '1.2 km away',
                  onTap: () => Navigator.pushNamed(context, '/venue-detail'),
                ),

                const SizedBox(height: 16),

                // Result 3 - Asymmetric Bento
                _recommendedCard(
                  title: 'Wild Garden Loft',
                  description: 'Outdoor greenhouse seating with ultra-fast WiFi and artisan matchas.',
                  onTap: () => Navigator.pushNamed(context, '/venue-detail'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 120),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          border: Border(
            top: BorderSide(color: Colors.grey[200]!),
          ),
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
      ),
    );
  }

  Widget _filterChip(String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
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

  Widget _venueCard({
    required String title,
    required String image,
    required double rating,
    required String description,
    required bool isFeatured,
    required String distance,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
                    image,
                    height: 256,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                            color: isFeatured ? const Color(0xff9f3b00) : Colors.grey[600],
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isFeatured)
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xfff8ad1f).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Color(0xff7c5300), size: 12),
                              const SizedBox(width: 4),
                              Text(
                                rating.toString(),
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
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.verified, color: Color(0xff9f3b00), size: 14),
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
                          distance,
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

  Widget _recommendedCard({
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
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
        onTap: onTap,
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
}

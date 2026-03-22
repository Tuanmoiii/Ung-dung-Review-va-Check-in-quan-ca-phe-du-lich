import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:btl_mobile/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  Map<String, dynamic>? userData;
  List<dynamic> trendingShops = [];

  @override
  void initState() {
    super.initState();
    _loadTrendingShops();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserData();
  }

  void _loadUserData() {
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      userData = args;
    } else {
      userData = ApiService.currentUser;
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadTrendingShops() async {
    final shops = await ApiService.getTrendingShops(limit: 5);
    if (mounted) {
      setState(() {
        trendingShops = shops;
      });
    }
  }

  String get _userName {
    if (userData != null && userData!['username'] != null) {
      return userData!['username'];
    }
    return 'Alex';
  }

  String get _membershipTier {
    if (userData != null && userData!['membershipTier'] != null) {
      return userData!['membershipTier'];
    }
    return 'Bronze';
  }

  int get _points {
    if (userData != null && userData!['points'] != null) {
      return userData!['points'];
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xff9f3b00)),
        title: const Text(
          'Go & Chill',
          style: TextStyle(
            color: Color(0xff9f3b00),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        children: [
          // Greeting Section
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, $_userName',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Text(
                  'Find your vibe.',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff9f3b00),
                  ),
                ),
                if (userData != null)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff9f3b00).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          size: 16,
                          color: Color(0xff9f3b00),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$_membershipTier Member • $_points pts',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff9f3b00),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // AI Recommendation Bento
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAfPxdneJYt9y0o3mAn2WF_WCPWT59VHiH8058XYAeq5pCNE6fohziNHYCF_yrOCyTjH9MRG-PvkLebRGuZYtbU2Q16TVgk47jo1UjwF84w_9EAqb6k-qiPmnC7lgcW8JCc6H9oZ7YzsyvZs7V7pt-lPq0JYE7GLICpGfTPyAN0Oy70DDAp2-sq4crMyHYtG6Q1HOhiCGhSiRKQrvjJb7E03_nbwAc-DxsXXIkJrvT6eglhisMhxxSEg5Xcptdb-Ji2_sxj56d9oHQ',
                        ),
                        fit: BoxFit.cover,
                        opacity: 0.9,
                      ),
                    ),
                  ),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff7c5300),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'SUGGESTED FOR YOU',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Roast & Ritual: The Morning Blend',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Based on your love for minimalist aesthetics',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.8),
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

          // Trending Destinations
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trending Destinations',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/explore'),
                  child: const Text(
                    'View all',
                    style: TextStyle(
                      color: Color(0xff9f3b00),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 280,
            child: trendingShops.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      for (int i = 0; i < trendingShops.length; i++)
                        _trendingCard(
                          title: trendingShops[i]['name'] ?? 'Coffee Shop',
                          image:
                              trendingShops[i]['imageUrl'] ??
                              'https://via.placeholder.com/300',
                          description:
                              trendingShops[i]['description'] ??
                              'Great coffee shop',
                          rating: (trendingShops[i]['rating'] ?? 4.5)
                              .toDouble(),
                          tags: trendingShops[i]['tags'] != null
                              ? List<String>.from(trendingShops[i]['tags'])
                              : ['COFFEE'],
                          onTap: () {
                            print(
                              'Click vào quán ID: ${trendingShops[i]['id']}',
                            );
                            Navigator.pushNamed(
                              context,
                              '/venue-detail',
                              arguments: trendingShops[i]['id'],
                            );
                          },
                        ),
                    ],
                  ),
          ),
          const SizedBox(height: 32),

          // Nearby Gems
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nearby Gems',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Hidden within 2km of you',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Bento Layout for Gems
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _largeGemCard(
                  title: 'Cedar & Smoke',
                  image:
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuDotQpUvPQmkbyUnY07w6-EE9lmC1esnH3WaNHNVdLFDHNaV6eIkl5eRuKg3OdGd8pzYW_VkxxiuKvp3YpnCA3YOhO60sKeprxoT7fWMm57YNtX-31Mg3xAQJHYu5TGjWD8xMWii8Mrayb3s7PhX9xfN0PIEwU37_imEzCARwJ86tQcSoTeiA4GF4E2SsW40lKXbbBKtBMdIACUI8PttdDeOGW3eEjhEhCbGIfEKH4Z-RAdmoZfof-QfUXBES5eDJ522BPQiN7pc0U',
                  subtitle: 'Artisanal Bakery • 0.4km',
                  onTap: () {
                    Navigator.pushNamed(context, '/venue-detail', arguments: 1);
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _smallGemCard(
                        title: 'Steam & Steel',
                        image:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuA3iXiB5W6i0hIJMdTdnUJUeKWOVBTE-S1A8_05tdAOVPA9Syjba_tNRQ8UJhJsY7X3zkK4ZsFAk5xBRvoA-AngoXWXhJchtKzdEN8APHm_ym34VPA2-twZ6gE1RfHavv-UwW9X6x6JZfcePwmV5Wi1DkpglDBzvR0wUvNyjT_dSFvNAOhbhuO8pfZQm9aOGhjPWQ4t4UwrD5HxESexRwyo460K8K-J5cNH4VEkczZbsSCdr6p_CJ8j3wuxTjGJqTdK4Uu1-g7I2yk',
                        subtitle: 'Industrial Style • 1.2km',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/venue-detail',
                            arguments: 2,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _smallGemCard(
                        title: 'The Greenhouse',
                        image:
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuAsSXIt8KLjjdIzIej5O8TjmVS5OvtE46sfn0g23dZKNFsAc591TvfzUr8ASMKzEy38W6VPf3-uVZX0bhUxqAsFSMGe3ZIA_aHFELqDxzFiyVilFG0ho3dbvKOJzZ5eFTGkp3Q7bEACGs3KgBEf3Harw8BIkBg_2Nv5dUQNzOHk92xkb48E-WglA_VR1KXMT59cuS7sA1NXBQ1DdEBLncbbp4LK8peTAa9-BLD8wWS_402pozFWvnTNqsyufOaVjc9S_VlGTeOynKY',
                        subtitle: 'Botanical Bliss • 0.8km',
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/venue-detail',
                            arguments: 3,
                          );
                        },
                      ),
                    ),
                  ],
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
          border: Border(top: BorderSide(color: Colors.grey[200]!)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navButton('Home', Icons.home, 0, () {
                setState(() => _currentIndex = 0);
              }),
              _navButton('Search', Icons.search, 1, () {
                Navigator.pushReplacementNamed(context, '/explore');
              }),
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

  Widget _trendingCard({
    required String title,
    required String image,
    required String description,
    required double rating,
    required List<String> tags,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 260,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white,
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
              Stack(
                children: [
                  Image.network(
                    image,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 160,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
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
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xff9f3b00),
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff9f3b00),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: tags
                          .take(2)
                          .map(
                            (tag) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          )
                          .toList(),
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

  Widget _largeGemCard({
    required String title,
    required String image,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  image,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 96,
                    height: 96,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffe89f09),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'OPEN NOW',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
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

  Widget _smallGemCard({
    required String title,
    required String image,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                image,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 11, color: Colors.grey[600]),
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

  Widget _navButton(
    String label,
    IconData icon,
    int index,
    VoidCallback onTap,
  ) {
    bool isActive = _currentIndex == index;
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

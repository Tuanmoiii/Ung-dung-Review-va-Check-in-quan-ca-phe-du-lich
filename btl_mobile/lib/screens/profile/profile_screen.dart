import 'package:flutter/material.dart';
import 'dart:ui';

const Color _colorPrimary = Color(0xFFA03B00);
const Color _colorSecondary = Color(0xFF465F6F);
const Color _colorSurface = Color(0xFFF8F6F3);
const Color _colorSurfaceContainer = Color(0xFFE9E8E5);
const Color _colorSurfaceContainerLowest = Color(0xFFFFFFFF);
const Color _colorOnSurface = Color(0xFF2E2F2D);
const Color _colorOnSurfaceVariant = Color(0xFF5B5C59);
const Color _colorSecondaryContainer = Color(0xFFCCE6FA);
const Color _colorOnSecondaryContainer = Color(0xFF3C5565);
const Color _colorTertiary = Color(0xFF2D6084);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentNavIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorSurface,
      body: CustomScrollView(
        slivers: [
          // Top App Bar
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Color.lerp(_colorSurface, Colors.black, 0.05),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            title: Row(
              children: [
                const Icon(Icons.menu, color: _colorOnSurface),
                const SizedBox(width: 16),
                const Text(
                  'Go & Chill',
                  style: TextStyle(
                    color: _colorOnSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  _profileHeader(),
                  const SizedBox(height: 32),
                  // Stats Bento Grid
                  _statsBento(),
                  const SizedBox(height: 32),
                  // Check-in Map
                  _checkInMapSection(),
                  const SizedBox(height: 32),
                  // Rewards Section
                  _rewardsSection(),
                  const SizedBox(height: 32),
                  // Activity Feed
                  _activityFeedSection(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _profileHeader() {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: _colorSurfaceContainerLowest, width: 4),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(48),
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuCZV7-Ba03FU_znEYU2cLhpb96ln-_XRyDm-_VmwB_-TrR6Vnlx6Nl6eWEIpdLy2cUiQD_jd3xRp9jOjpG_gOOKdmEy9eDl8mCSsshfYl-PTiFupkK86EbfXqmZOE9yaml8YxSg0mDt11o99M4pc8T6mcERBsYjZyQuFkHkIEygJVih6Q6RuW4mmaxbEtBlz-fxrtS25jmCT1etawLCqWWrVvcFrQFOkKcz6uLM7LF5cYXJS0m4Qxv4VIFc1nWR3r750mDr_P0IYl4',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: _colorSurfaceContainer, child: const Icon(Icons.person)),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _colorPrimary,
                  border: Border.all(color: _colorSurface, width: 2),
                ),
                child: const Icon(Icons.check_circle, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Alex Rivera',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: _colorOnSurface,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _colorSecondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.military_tech, size: 12, color: _colorOnSecondaryContainer),
                    const SizedBox(width: 6),
                    const Text(
                      'Gold Nomad',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _colorOnSecondaryContainer,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit_rounded, size: 16),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _colorPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,
                      shadowColor: _colorPrimary.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, '/settings'),
                    icon: const Icon(Icons.settings_rounded),
                    color: _colorOnSurface,
                    style: IconButton.styleFrom(backgroundColor: _colorSurfaceContainer),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statsBento() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _colorSurfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: [
                const Text(
                  '1,240',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _colorPrimary,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'PTS',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: _colorOnSurfaceVariant, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _colorSurfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: [
                const Text(
                  '42',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _colorOnSurface,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'VISITS',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: _colorOnSurfaceVariant, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _colorSurfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              children: [
                const Text(
                  '18',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _colorOnSurface,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'REVIEWS',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: _colorOnSurfaceVariant, letterSpacing: 0.5),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _checkInMapSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Check-in Map',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _colorOnSurface,
              ),
            ),
            Text(
              'View All',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _colorPrimary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Stack(
          children: [
            Container(
              height: 176,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAJG7lkeEn8SeYueMu4N4clVlpoF0zG71Nqh_n0FWhRSlVB6umkjqnkciruq5TXIlAqe1_90hi_yJU_-t6VQYMdwFFVJHGjAi48I7uW3dRV9vAHKMizHdI40vw-YR6Q3Tcgppxaijl0qD4NsTl4KWPyKOBoCBY5Rbt6Wa_RdSYHT8dWFjqaVwiNdgaugDlztV1ZpYuky-Qquc6sT-laT-G8ltYcl255-uXnS0q1X0v8SZZllNAtADDjNbFtiivffhx1-3BWN_MX1nk',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(color: _colorSurfaceContainer),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.05)),
            ),
            // Mock pins
            Positioned(
              top: 44,
              left: 110,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _colorPrimary,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
            Positioned(
              top: 88,
              left: 176,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _colorPrimary,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
            Positioned(
              bottom: 73,
              left: 55,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _colorPrimary,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
            // Info badge
            Positioned(
              bottom: 12,
              left: 12,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, size: 14, color: _colorPrimary),
                        const SizedBox(width: 6),
                        const Text(
                          '3 Active Cities',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _colorOnSurface,
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
      ],
    );
  }

  Widget _rewardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Rewards',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _colorOnSurface,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Voucher Card
              Container(
                width: 200,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF2D6084), const Color(0xFF4A8BC7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: _colorTertiary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: -16,
                      right: -16,
                      child: Opacity(
                        opacity: 0.2,
                        child: Icon(Icons.local_cafe, size: 120, color: Colors.white),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'VOUCHER',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Colors.white70,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          '15% Off\nCoffee',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Valid at Roast & Co.',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Badge 1
              Container(
                width: 140,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _colorSurfaceContainerLowest,
                  border: Border.all(color: _colorSurfaceContainer),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _colorSecondaryContainer,
                      ),
                      child: const Icon(Icons.eco, size: 24, color: _colorOnSecondaryContainer),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Eco Traveler',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _colorOnSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'UNLOCKED',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: _colorOnSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Badge 2
              Container(
                width: 140,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _colorSurfaceContainerLowest,
                  border: Border.all(color: _colorSurfaceContainer),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _colorPrimary.withOpacity(0.2),
                      ),
                      child: const Icon(Icons.nights_stay, size: 24, color: _colorPrimary),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Late Owl',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _colorOnSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'UNLOCKED',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                        color: _colorOnSurfaceVariant,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _activityFeedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _colorOnSurface,
              ),
            ),
            Icon(Icons.history, color: _colorOnSurfaceVariant, size: 20),
          ],
        ),
        const SizedBox(height: 16),
        ...[
          {
            'name': 'The Morning Brew',
            'time': 'Checked in 2 hours ago',
            'points': '+15 pts',
            'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAsdISC1hDj7NKVdtI75T8W-3AY5LqvNdnr8CGokW-JzshwwhWqHlHShn9kfyBO8s0iPVv268gNurxb74yBJGra3q_cOFxUP_v6nra4yg-21-2W9TSAqDKArJJVMZ_4tzJlGDaWgLdWocBghImleSRxuDReRNxfsWtDgZaBGXOHtca-Ry6gdQmpRLeFong0V5r4799Yh5DqNIxvYphcDkXPpAAb6ZaGxnYaz0O_YRtZZx54UBukHC-WEi29n56HzwLZlYeWHnwrstw'
          },
          {
            'name': 'Urban Oasis',
            'time': 'Visited Yesterday',
            'points': '+10 pts',
            'image': 'https://lh3.googleusercontent.com/aida-public/AB6AXuCnQUvWWIA2TnWYUet16QCPqH61HEDZgNT9Uxa8f2d4yNznQn-g-5vJ5cE5A1bvV9oUnSfhKN7pGnkQIoNgP9IFgytl94iGrY_I2i2xLKbzl-zOwYTiO5jDGXOVEV5yJCeGhOBpqaHtoERhTuzSqEMYIV5re0I9jjQLWCvvGE1VcFc8XQyarRE8ls_llqRCqd9fIuVvYW5BJVImrXG5k7XgjfKWxbUFs7WSXMen2e7QrcXEYT5Y8s7xaUIJzFsrmxQIJggkJvlr81c'
          },
        ].map((item) => _activityItem(item['name']!, item['time']!, item['points']!, item['image']!)).toList(),
      ],
    );
  }

  Widget _activityItem(String name, String time, String points, String image) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _colorSurfaceContainerLowest,
          border: Border.all(color: _colorSurfaceContainer.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: _colorSurfaceContainer,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.image),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _colorOnSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: _colorOnSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              points,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _colorPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton(IconData icon, String label, int index) {
    final isActive = index == _currentNavIndex;
    return GestureDetector(
      onTap: () {
        setState(() => _currentNavIndex = index);
        final routes = ['/', '/explore', '/community', '/rewards', '/profile'];
        if (index < routes.length && index != 2) {
          Navigator.pushNamed(context, routes[index]);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? _colorPrimary : _colorOnSurfaceVariant,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: isActive ? _colorPrimary : _colorOnSurfaceVariant,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fabCheckIn() {
    return FloatingActionButton(
      onPressed: () {},
      backgroundColor: _colorPrimary,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
    );
  }

  Widget _bottomNav() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: _colorSurface.withOpacity(0.8),
          border: Border(top: BorderSide(color: _colorSurfaceContainer)),
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: _colorSurface.withOpacity(0.8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _navButton(Icons.home_outlined, 'Home', 0),
                      _navButton(Icons.search_rounded, 'Search', 1),
                      SizedBox(width: 56),
                      _navButton(Icons.group_rounded, 'Community', 3),
                      _navButton(Icons.person_rounded, 'Profile', 4),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: _fabCheckIn(),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFFA03B00);
    final surfaceColor = Color(0xFFF8F6F3);
    final onSurfaceColor = Color(0xFF2E2F2D);
    final onSurfaceVariantColor = Color(0xFF5B5C59);
    final surfaceContainerLowest = Color(0xFFFFFFFF);
    final tertiaryContainerColor = Color(0xFF9CCCF6);
    final onTertiaryContainerColor = Color(0xFF034467);
    final secondaryContainerColor = Color(0xFFCCE6FA);
    final onSecondaryContainerColor = Color(0xFF3C5565);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurfaceColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Rewards & Loyalty',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: onSurfaceColor,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: onSurfaceColor),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Quick View Section
          Row(
            children: [
              // Main Profile Card
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAbrnjH-Ih8OmspIpwqDoNfbZ2_m_vcq12fiXKa6QLP9v9EUqQxt4saGkclOf1aeu8diuuq64KGnXTmfMW4LywvghsDid4IE_HuBn8vIK82YhTTpDlnU3Zi2QGVbxXE2zUuR5ZobvJkOiZb5jiamLbS19iU7P_FovrSDB73GBPgUd1XTHN4nHRp6VcioFjlwuJsqOP9QnV5mfWuZCj0cFGfVBS72YZNIfpb66CAZ6fUImhVxCmGPUr9bv9xjFzyGxEyQ3bGFmVVOR4',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Alex Rivers',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: onSurfaceColor,
                                  ),
                                ),
                                Text(
                                  'alex.roams@email.com',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: onSurfaceVariantColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: secondaryContainerColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Pro Member',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: onSecondaryContainerColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Rewards Card
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: tertiaryContainerColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.card_giftcard_outlined,
                        size: 32,
                        color: onTertiaryContainerColor,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Your Points',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: onTertiaryContainerColor.withValues(alpha: 0.8),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '2,450',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: onTertiaryContainerColor,
                        ),
                      ),
                      Text(
                        'pts',
                        style: TextStyle(
                          fontSize: 11,
                          color: onTertiaryContainerColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Available Rewards Section
          Text(
            'Available Rewards',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          ..._buildRewardsList(
            primaryColor: primaryColor,
            surfaceContainerLowest: surfaceContainerLowest,
            onSurfaceColor: onSurfaceColor,
            onSurfaceVariantColor: onSurfaceVariantColor,
          ),
          const SizedBox(height: 24),
          // Redeemed Rewards Section
          Text(
            'Redeemed',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryColor,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          ..._buildRedeemedList(
            surfaceContainerLowest: surfaceContainerLowest,
            onSurfaceColor: onSurfaceColor,
            onSurfaceVariantColor: onSurfaceVariantColor,
          ),
          const SizedBox(height: 100),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          border: Border(
            top: BorderSide(color: Colors.grey[200]!),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavButton('Explore', Icons.search, 0, () {
                Navigator.pushReplacementNamed(context, '/explore');
              }),
              _buildNavButton('Community', Icons.group, 1, () {
                Navigator.pushReplacementNamed(context, '/community');
              }),
              IconButton(
                icon: Icon(Icons.favorite, color: Colors.grey[600], size: 24),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/profile');
                },
                tooltip: 'Favorites',
              ),
              _buildNavButton(
                'Rewards',
                Icons.card_giftcard,
                2,
                () {},
                isActive: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRewardsList({
    required Color primaryColor,
    required Color surfaceContainerLowest,
    required Color onSurfaceColor,
    required Color onSurfaceVariantColor,
  }) {
    final rewards = [
      {
        'title': 'Free Oat Milk Upgrade',
        'points': 150,
        'icon': Icons.coffee_outlined,
        'color': Colors.blue,
      },
      {
        'title': 'Free Espresso Shot',
        'points': 100,
        'icon': Icons.local_cafe_outlined,
        'color': Colors.brown,
      },
      {
        'title': '20% Off Next Purchase',
        'points': 250,
        'icon': Icons.percent,
        'color': Colors.orange,
      },
      {
        'title': 'Free Pastry Item',
        'points': 120,
        'icon': Icons.bakery_dining_outlined,
        'color': Colors.amber,
      },
    ];

    return rewards
        .map(
          (reward) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey[200]!,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: (reward['color'] as Color).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      reward['icon'] as IconData,
                      color: reward['color'] as Color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reward['title'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: onSurfaceColor,
                          ),
                        ),
                        Text(
                          '${reward['points']} points',
                          style: TextStyle(
                            fontSize: 12,
                            color: onSurfaceVariantColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Reward "${reward['title']}" redeemed! Check your email for details.',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: const Text(
                      'Redeem',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  List<Widget> _buildRedeemedList({
    required Color surfaceContainerLowest,
    required Color onSurfaceColor,
    required Color onSurfaceVariantColor,
  }) {
    final redeemed = [
      {
        'title': 'Free Regular Coffee (Redeemed)',
        'date': 'Mar 15, 2026',
        'icon': Icons.check_circle_outlined,
      },
      {
        'title': '15% Off Coupon (Redeemed)',
        'date': 'Mar 10, 2026',
        'icon': Icons.check_circle_outlined,
      },
    ];

    return redeemed
        .map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceContainerLowest,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.green[200]!,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outlined,
                    color: Colors.green,
                    size: 28,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'] as String,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: onSurfaceColor,
                          ),
                        ),
                        Text(
                          item['date'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: onSurfaceVariantColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _buildNavButton(
    String label,
    IconData icon,
    int index,
    VoidCallback onTap, {
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? Color(0xFFA03B00) : Colors.grey[600],
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isActive ? Color(0xFFA03B00) : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

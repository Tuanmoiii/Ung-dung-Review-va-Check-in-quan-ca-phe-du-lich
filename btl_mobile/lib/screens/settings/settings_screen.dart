import 'package:flutter/material.dart';
import 'dart:ui';

const Color _colorPrimary = Color(0xFFA03B00);
const Color _colorSecondary = Color(0xFF465F6F);
const Color _colorSurface = Color(0xFFF8F6F3);
const Color _colorSurfaceContainer = Color(0xFFE9E8E5);
const Color _colorSurfaceContainerLowest = Color(0xFFFFFFFF);
const Color _colorSurfaceContainerLow = Color(0xFFF2F0ED);
const Color _colorSurfaceContainerHigh = Color(0xFFE4E2DF);
const Color _colorSurfaceContainerHighest = Color(0xFFDEDCD9);
const Color _colorOnSurface = Color(0xFF2E2F2D);
const Color _colorOnSurfaceVariant = Color(0xFF5B5C59);
const Color _colorOutlineVariant = Color(0xFF777775);
const Color _colorTertiaryContainer = Color(0xFF9CCCF6);
const Color _colorOnTertiaryContainer = Color(0xFF034467);
const Color _colorPrimaryContainer = Color(0xFFFF793B);
const Color _colorOnPrimaryContainer = Color(0xFF421400);
const Color _colorError = Color(0xFFB31B25);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailAlerts = false;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorSurface,
      body: CustomScrollView(
        slivers: [
          // Top AppBar
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
              'Settings',
              style: TextStyle(
                color: _colorOnSurface,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_vert, color: _colorOnSurface),
                onPressed: () {},
              ),
            ],
          ),
          // Main Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Quick View (Asymmetric Bento)
                  _profileQuickView(),
                  const SizedBox(height: 32),
                  // Settings Groups
                  _accountSection(),
                  const SizedBox(height: 24),
                  _notificationsSection(),
                  const SizedBox(height: 24),
                  _preferencesSection(),
                  const SizedBox(height: 24),
                  _supportSection(),
                  const SizedBox(height: 32),
                  // Logout Button
                  _logoutButton(),
                  const SizedBox(height: 24),
                  // Version Info
                  const Center(
                    child: Text(
                      'Version 2.4.1 (Build 882)',
                      style: TextStyle(
                        fontSize: 12,
                        color: _colorOnSurfaceVariant,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
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

  Widget _profileQuickView() {
    return Row(
      children: [
        // Profile Card (2/3 width)
        Expanded(
          flex: 2,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _colorSurfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: _colorSurfaceContainerLowest, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuAbrnjH-Ih8OmspIpwqDoNfbZ2_m_vcq12fiXKa6QLP9v9EUqQxt4saGkclOf1aeu8diuuq64KGnXTmfMW4LywvghsDid4IE_HuBn8vIK82YhTTpDlnU3Zi2QGVbxXE2zUuR5ZobvJkOiZb5jiamLbS19iU7P_FovrSDB73GBPgUd1XTHN4nHRp6VcioFjlwuJsqOP9QnV5mfWuZCj0cFGfVBS72YZNIfpb66CAZ6fUImhVxCmGPUr9bv9xjFzyGxEyQ3bGFmVVOR4',
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
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _colorPrimary,
                          border: Border.all(color: _colorSurfaceContainerLowest, width: 2),
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 12),
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
                        'Alex Rivers',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _colorOnSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'alex.roams@email.com',
                        style: TextStyle(
                          fontSize: 13,
                          color: _colorOnSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _colorSecondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Pro Wanderer',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _colorSecondary,
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
        const SizedBox(width: 16),
        // Rewards Card (1/3 width)
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _colorTertiaryContainer,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.workspace_premium, size: 28, color: _colorOnTertiaryContainer),
                const Spacer(),
                const Text(
                  'REWARDS',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: _colorOnTertiaryContainer,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '2,450 pts',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: _colorOnTertiaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _accountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            'ACCOUNT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _colorPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _colorSurfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _settingsButton(
                icon: Icons.person,
                title: 'Edit Profile',
                onTap: () {},
                showBorder: false,
              ),
              _settingsButton(
                icon: Icons.security,
                title: 'Security',
                onTap: () {},
                showBorder: true,
              ),
              _settingsButton(
                icon: Icons.lock,
                title: 'Privacy',
                onTap: () {},
                showBorder: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _notificationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            'NOTIFICATIONS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _colorPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _colorSurfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _toggleSetting(
                icon: Icons.notifications_active,
                title: 'Push Notifications',
                value: _pushNotifications,
                onChanged: (value) => setState(() => _pushNotifications = value),
                showBorder: false,
              ),
              _toggleSetting(
                icon: Icons.mail,
                title: 'Email Alerts',
                value: _emailAlerts,
                onChanged: (value) => setState(() => _emailAlerts = value),
                showBorder: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _preferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            'PREFERENCES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _colorPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _colorSurfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _toggleSetting(
                icon: Icons.dark_mode,
                title: 'Dark Mode',
                value: _darkMode,
                onChanged: (value) => setState(() => _darkMode = value),
                showBorder: false,
              ),
              _settingsButton(
                icon: Icons.language,
                title: 'Language',
                subtitle: 'English (US)',
                onTap: () {},
                showBorder: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _supportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            'SUPPORT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _colorPrimary,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _colorSurfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _settingsButton(
                icon: Icons.help,
                title: 'Help Center',
                onTap: () {},
                showBorder: false,
              ),
              _settingsButton(
                icon: Icons.chat_bubble,
                title: 'Feedback',
                onTap: () {},
                showBorder: true,
              ),
              _settingsButton(
                icon: Icons.info,
                title: 'About Us',
                onTap: () {},
                showBorder: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _settingsButton({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required bool showBorder,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: showBorder ? Border(top: BorderSide(color: _colorSurfaceContainerLow, width: 1)) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _colorSurfaceContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: _colorOnSurfaceVariant),
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
                      fontWeight: FontWeight.w500,
                      color: _colorOnSurface,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _colorOnSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: _colorOutlineVariant),
          ],
        ),
      ),
    );
  }

  Widget _toggleSetting({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool showBorder,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: showBorder ? Border(top: BorderSide(color: _colorSurfaceContainerLow, width: 1)) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _colorSurfaceContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: _colorOnSurfaceVariant),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _colorOnSurface,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: _colorPrimary,
            activeTrackColor: _colorPrimary.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _logoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
        icon: const Icon(Icons.logout),
        label: const Text('Logout'),
        style: ElevatedButton.styleFrom(
          backgroundColor: _colorSurfaceContainerHighest,
          foregroundColor: _colorError,
          padding: const EdgeInsets.symmetric(vertical: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _bottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: _colorSurface.withOpacity(0.8),
        border: Border(top: BorderSide(color: _colorSurfaceContainer)),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              color: _colorSurface.withOpacity(0.8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(Icons.search, 'Explore', false),
                _navItem(Icons.event, 'Bookings', false),
                _navItem(Icons.favorite, 'Saved', false),
                _navItem(Icons.settings, 'Settings', true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }
}

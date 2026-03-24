// lib/screens/auth/login_screen.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:btl_mobile/services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;
  bool _passwordVisible = false;

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập email và mật khẩu')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await ApiService.login(
        _emailController.text,
        _passwordController.text,
      );

      if (user != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đăng nhập thành công! Chào ${user['username']}'),
              backgroundColor: Colors.green,
            ),
          );
          // Chuyển sang home và truyền user data
          Navigator.pushReplacementNamed(context, '/home', arguments: user);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sai email hoặc mật khẩu'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF9F3B00);
    final onPrimaryColor = Color(0xFFFFEFEA);
    final surfaceColor = Color(0xFFFFF4F0);
    final onSurfaceColor = Color(0xFF4B2508);
    final onSurfaceVariantColor = Color(0xFF805030);
    final surfaceContainerLowest = Color(0xFFFFFFFF);
    const outlineVariantColor = Color(0xFFDCA07A);

    return Scaffold(
      backgroundColor: surfaceColor,
      body: SafeArea(
        child: Column(
          children: [
            // TopAppBar Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.explore, color: primaryColor, size: 32),
                      const SizedBox(width: 8),
                      Text(
                        'Go & Chill',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: onSurfaceVariantColor),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome Header
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chào mừng trở lại',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: onSurfaceColor,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sẵn sàng cho chuyến phiêu lưu tiếp theo của bạn chưa?',
                            style: TextStyle(
                              fontSize: 14,
                              color: onSurfaceVariantColor,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      // Login Form
                      Column(
                        children: [
                          // Email Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: onSurfaceVariantColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  hintText: 'example@email.com',
                                  prefixIcon: Icon(
                                    Icons.mail_outline,
                                    color: onSurfaceVariantColor,
                                    size: 20,
                                  ),
                                  filled: true,
                                  fillColor: surfaceContainerLowest,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: outlineVariantColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: outlineVariantColor.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Password Field
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mật khẩu',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: onSurfaceVariantColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _passwordController,
                                obscureText: !_passwordVisible,
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: onSurfaceVariantColor,
                                    size: 20,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: onSurfaceVariantColor,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                  filled: true,
                                  fillColor: surfaceContainerLowest,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: outlineVariantColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: outlineVariantColor.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Remember Me & Forgot Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _rememberMe = !_rememberMe;
                                      });
                                    },
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: _rememberMe
                                            ? primaryColor
                                            : surfaceContainerLowest,
                                        border: Border.all(
                                          color: _rememberMe
                                              ? primaryColor
                                              : outlineVariantColor,
                                          width: 1,
                                        ),
                                      ),
                                      child: _rememberMe
                                          ? Icon(
                                              Icons.check,
                                              size: 14,
                                              color: onPrimaryColor,
                                            )
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Ghi nhớ đăng nhập',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: onSurfaceVariantColor,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Quên mật khẩu?',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Login Button
                          _isLoading
                              ? SizedBox(
                                  height: 56,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        primaryColor,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: ElevatedButton(
                                    onPressed: _handleLogin,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryColor,
                                      foregroundColor: onPrimaryColor,
                                      elevation: 8,
                                      shadowColor: primaryColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Đăng nhập',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: onPrimaryColor,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: onPrimaryColor,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          const SizedBox(height: 24),
                          // Divider
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: outlineVariantColor.withValues(
                                    alpha: 0.3,
                                  ),
                                  height: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Text(
                                  'HOẶC TIẾP TỤC VỚI',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: onSurfaceVariantColor,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Divider(
                                  color: outlineVariantColor.withValues(
                                    alpha: 0.3,
                                  ),
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Social Login Buttons
                          Row(
                            children: [
                              Expanded(
                                child: _buildSocialButton(
                                  label: 'Google',
                                  icon: Icons.g_mobiledata,
                                  onPressed: () {},
                                  backgroundColor: surfaceContainerLowest,
                                  textColor: onSurfaceColor,
                                  surfaceColor: surfaceContainerLowest,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildSocialButton(
                                  label: 'Facebook',
                                  icon: Icons.facebook,
                                  onPressed: () {},
                                  backgroundColor: surfaceContainerLowest,
                                  textColor: onSurfaceColor,
                                  surfaceColor: surfaceContainerLowest,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),
                      // Sign Up Link
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Chưa có tài khoản? ',
                            style: TextStyle(
                              fontSize: 14,
                              color: onSurfaceVariantColor,
                            ),
                            children: [
                              TextSpan(
                                text: 'Đăng ký',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                  decoration: TextDecoration.underline,
                                  decorationThickness: 2,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, '/register');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            // Bottom Ornament Line
            Container(
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor,
                    const Color(0xFF7C5300),
                    const Color(0xFF934600),
                  ],
                  stops: const [0, 0.5, 1],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color textColor,
    required Color surfaceColor,
  }) {
    const outlineVariantColor = Color(0xFFDCA07A);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(
            color: outlineVariantColor.withValues(alpha: 0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Color(0xFF1877F2), size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

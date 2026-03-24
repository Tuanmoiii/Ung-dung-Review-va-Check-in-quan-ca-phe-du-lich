// lib/screens/auth/register_screen.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:btl_mobile/services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  Future<void> _handleRegister() async {
    if (_usernameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin')),
      );
      return;
    }

    if (_passwordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu xác nhận không khớp')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = await ApiService.register(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
        _confirmController.text,
      );

      if (user != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đăng ký thành công! Chào ${user['username']}'),
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
              content: Text('Đăng ký thất bại, email hoặc username đã tồn tại'),
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
    final surfaceContainerLow = Color(0xFFFFede4);
    const outlineVariantColor = Color(0xFFDCA07A);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: AppBar(
        backgroundColor: Color(0xFFF8F6F3),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Go & Chill',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: primaryColor,
            letterSpacing: -0.5,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Hero Header
                Column(
                  children: [
                    Text(
                      'Tạo tài khoản mới',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                        letterSpacing: -0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Khám phá những điểm đến bình yên cùng chúng tôi.',
                      style: TextStyle(
                        fontSize: 14,
                        color: onSurfaceVariantColor,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Registration Form Container
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Username Field
                      _buildInputField(
                        label: 'Tên người dùng',
                        placeholder: 'Nguyễn Văn A',
                        controller: _usernameController,
                        icon: Icons.person_outline,
                        primaryColor: primaryColor,
                        onSurfaceVariantColor: onSurfaceVariantColor,
                        surfaceContainerLow: surfaceContainerLow,
                        outlineVariantColor: outlineVariantColor,
                      ),
                      const SizedBox(height: 24),
                      // Email Field
                      _buildInputField(
                        label: 'Email',
                        placeholder: 'example@gmail.com',
                        controller: _emailController,
                        icon: Icons.mail_outline,
                        keyboardType: TextInputType.emailAddress,
                        primaryColor: primaryColor,
                        onSurfaceVariantColor: onSurfaceVariantColor,
                        surfaceContainerLow: surfaceContainerLow,
                        outlineVariantColor: outlineVariantColor,
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
                              fillColor: surfaceContainerLow,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: primaryColor.withValues(alpha: 0.2),
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Confirm Password Field
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Xác nhận mật khẩu',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: onSurfaceVariantColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _confirmController,
                            obscureText: !_confirmPasswordVisible,
                            decoration: InputDecoration(
                              hintText: '••••••••',
                              prefixIcon: Icon(
                                Icons.lock_reset_outlined,
                                color: onSurfaceVariantColor,
                                size: 20,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _confirmPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: onSurfaceVariantColor,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _confirmPasswordVisible =
                                        !_confirmPasswordVisible;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: surfaceContainerLow,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: primaryColor.withValues(alpha: 0.2),
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Register Button
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
                                onPressed: _handleRegister,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: onPrimaryColor,
                                  elevation: 8,
                                  shadowColor: primaryColor.withValues(
                                    alpha: 0.2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Đăng ký',
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
                              color: outlineVariantColor.withValues(alpha: 0.2),
                              height: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'HOẶC ĐĂNG KÝ BẰNG',
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
                              color: outlineVariantColor.withValues(alpha: 0.2),
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Social Buttons
                      Row(
                        children: [
                          Expanded(
                            child: _buildSocialButton(
                              label: 'Google',
                              icon: Icons.g_mobiledata,
                              onPressed: () {},
                              outlineVariantColor: outlineVariantColor,
                              onSurfaceColor: onSurfaceColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSocialButton(
                              label: 'Facebook',
                              icon: Icons.facebook,
                              onPressed: () {},
                              outlineVariantColor: outlineVariantColor,
                              onSurfaceColor: onSurfaceColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                // Sign In Link
                RichText(
                  text: TextSpan(
                    text: 'Đã có tài khoản? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: onSurfaceVariantColor,
                    ),
                    children: [
                      TextSpan(
                        text: 'Đăng nhập',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                          decoration: TextDecoration.underline,
                          decorationThickness: 2,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pop(context);
                          },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Footer Text
                Text(
                  'Go & Chill © 2024 • Authentic Experiences',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w500,
                    color: onSurfaceVariantColor.withValues(alpha: 0.5),
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String placeholder,
    required TextEditingController controller,
    required IconData icon,
    required Color primaryColor,
    required Color onSurfaceVariantColor,
    required Color surfaceContainerLow,
    required Color outlineVariantColor,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: onSurfaceVariantColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: placeholder,
            prefixIcon: Icon(icon, color: onSurfaceVariantColor, size: 20),
            filled: true,
            fillColor: surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: primaryColor.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color outlineVariantColor,
    required Color onSurfaceColor,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: outlineVariantColor.withValues(alpha: 0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
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
                color: onSurfaceColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

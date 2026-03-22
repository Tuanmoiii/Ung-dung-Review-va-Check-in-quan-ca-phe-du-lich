// lib/screens/auth/register_screen.dart
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
  bool _agreeTerms = false;
  bool _isLoading = false;

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

    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng đồng ý với điều khoản')),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Tên người dùng'),
            TextField(controller: _usernameController),
            const SizedBox(height: 12),
            const Text('Email'),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            const Text('Mật khẩu'),
            TextField(controller: _passwordController, obscureText: true),
            const SizedBox(height: 12),
            const Text('Xác nhận mật khẩu'),
            TextField(controller: _confirmController, obscureText: true),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _agreeTerms,
                  onChanged: (v) => setState(() => _agreeTerms = v ?? false),
                ),
                const Expanded(
                  child: Text('Tôi đồng ý với điều khoản sử dụng'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _handleRegister,
                    child: const Text('Đăng ký'),
                  ),
          ],
        ),
      ),
    );
  }
}

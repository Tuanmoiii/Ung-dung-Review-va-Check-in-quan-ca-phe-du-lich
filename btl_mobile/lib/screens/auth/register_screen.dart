import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _agreeTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Email'),
            TextField(controller: _emailController, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 12),
            const Text('Mật khẩu'),
            TextField(controller: _passwordController, obscureText: true),
            const SizedBox(height: 12),
            const Text('Xác nhận mật khẩu'),
            TextField(controller: _confirmController, obscureText: true),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(value: _agreeTerms, onChanged: (v) => setState(() => _agreeTerms = v ?? false)),
                const Expanded(child: Text('Tôi đồng ý với điều khoản sử dụng')),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _agreeTerms && _passwordController.text == _confirmController.text
                    ? () => Navigator.pushReplacementNamed(context, '/home')
                    : null,
                child: const Text('Đăng ký')),
          ],
        ),
      ),
    );
  }
}

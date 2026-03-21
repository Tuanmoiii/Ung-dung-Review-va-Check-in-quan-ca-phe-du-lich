import 'package:flutter/material.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Email'),
              TextField(controller: _emailController, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              const Text('Mật khẩu'),
              TextField(controller: _passwordController, obscureText: true),
              const SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(value: _rememberMe, onChanged: (v) => setState(() => _rememberMe = v ?? false)),
                  const Text('Ghi nhớ đăng nhập'),
                ],
              ),
              TextButton(onPressed: () {}, child: const Text('Quên mật khẩu?')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: const Text('Đăng nhập'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Đăng nhập với Google'),
                onPressed: () {},
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Đăng nhập với Facebook'),
                onPressed: () {},
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Chưa có tài khoản?'),
                  TextButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: const Text('Đăng ký')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

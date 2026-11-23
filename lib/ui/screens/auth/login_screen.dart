import 'package:flutter/material.dart';

import '../home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: _buildFormPanel(),
        ),
      ),
    );
  }

  Widget _buildFormPanel() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 410),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Lorem Ipsum',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Sign In',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 52),
            TextFormField(
              controller: _emailController,
              textInputAction: TextInputAction.next,
              decoration: _inputDecoration('Username'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Please enter your username'
                  : null,
            ),
            const SizedBox(height: 28),
            TextFormField(
              controller: _passwordController,
              obscureText: _hidePassword,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _signIn(),
              decoration: _inputDecoration('Password').copyWith(
                suffixIcon: IconButton(
                  tooltip: _hidePassword ? 'Show password' : 'Hide password',
                  onPressed: () =>
                      setState(() => _hidePassword = !_hidePassword),
                  icon: Icon(
                    _hidePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                    color: const Color(0xFFBDBDBD),
                  ),
                ),
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Please enter your password'
                  : null,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: FilledButton(
                onPressed: _signIn,
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('Sign In'),
              ),
            ),
            const SizedBox(height: 58),
            Text.rich(
              TextSpan(
                style: const TextStyle(color: Color(0xFF929292), fontSize: 14),
                children: [
                  const TextSpan(text: 'Dont have an account? '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.baseline,
                    baseline: TextBaseline.alphabetic,
                    child: GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Sign up will be added next.'),
                        ),
                      ),
                      child: const Text(
                        'Sign up.',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 14, color: Color(0xFFC6C6C6)),
      contentPadding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFD8D8D8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFD8D8D8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFF888888), width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(7),
        borderSide: const BorderSide(color: Color(0xFFCC4D4D)),
      ),
    );
  }
}

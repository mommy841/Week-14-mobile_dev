import 'package:material_ui/material_ui.dart';

import '../models/demo_store.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/boring_brand.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.store});

  final DemoStore store;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _createAccount() {
    if (!_formKey.currentState!.validate()) return;
    final error = widget.store.createAccount(
        _nameController.text, _emailController.text, _passwordController.text);
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => HomePage(store: widget.store)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white, title: const Text('Create account')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 16, 28, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: BoringBrand()),
                    const SizedBox(height: 28),
                    const Text('Join Boring App',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: appInk)),
                    const SizedBox(height: 8),
                    const Text('Create a local demo account to get started.',
                        style: TextStyle(color: appMuted)),
                    const SizedBox(height: 22),
                    AuthTextField(
                        label: 'Name',
                        controller: _nameController,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                                ? 'Enter your name.'
                                : null),
                    const SizedBox(height: 16),
                    AuthTextField(
                        label: 'Email Address',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: _emailValidator),
                    const SizedBox(height: 16),
                    AuthTextField(
                        label: 'Password',
                        controller: _passwordController,
                        isPassword: true,
                        validator: (value) =>
                            (value == null || value.length < 6)
                                ? 'Use at least 6 characters.'
                                : null),
                    const SizedBox(height: 16),
                    AuthTextField(
                        label: 'Confirm Password',
                        controller: _confirmController,
                        isPassword: true,
                        validator: (value) => value != _passwordController.text
                            ? 'Passwords do not match.'
                            : null),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _createAccount,
                      style: FilledButton.styleFrom(
                          backgroundColor: appBlue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(44),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7))),
                      child: const Text('Create account'),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                        'This account is stored only for this app session.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: appMuted)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String? _emailValidator(String? value) {
  final email = value?.trim() ?? '';
  return email.contains('@') && email.contains('.')
      ? null
      : 'Enter a valid email address.';
}

import 'package:material_ui/material_ui.dart';

import '../models/demo_store.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key, required this.store});

  final DemoStore store;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  String? _message;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _resetPassword() {
    if (!_formKey.currentState!.validate()) return;
    final error = widget.store
        .resetPassword(_emailController.text, _passwordController.text);
    if (error != null) {
      setState(() => _message = error);
      return;
    }
    Navigator.of(context).pop(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: Colors.white, title: const Text('Forgot password?')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Reset your password',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: appInk)),
                    const SizedBox(height: 8),
                    const Text(
                        'Enter your account email and choose a new password.',
                        style: TextStyle(color: appMuted)),
                    const SizedBox(height: 24),
                    AuthTextField(
                        label: 'Email Address',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: _emailValidator),
                    const SizedBox(height: 16),
                    AuthTextField(
                        label: 'New Password',
                        controller: _passwordController,
                        isPassword: true,
                        validator: (value) =>
                            (value == null || value.length < 6)
                                ? 'Use at least 6 characters.'
                                : null),
                    const SizedBox(height: 16),
                    AuthTextField(
                        label: 'Confirm New Password',
                        controller: _confirmController,
                        isPassword: true,
                        validator: (value) => value != _passwordController.text
                            ? 'Passwords do not match.'
                            : null),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _resetPassword,
                      style: FilledButton.styleFrom(
                          backgroundColor: appBlue,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(44),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7))),
                      child: const Text('Reset password'),
                    ),
                    if (_message != null) ...[
                      const SizedBox(height: 16),
                      Text(_message!,
                          style: const TextStyle(color: Colors.redAccent)),
                    ],
                    const SizedBox(height: 16),
                    const Text('Local demo only. No reset email is sent.',
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

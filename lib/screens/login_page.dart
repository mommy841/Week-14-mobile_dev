import 'package:material_ui/material_ui.dart';

import '../models/demo_store.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/boring_brand.dart';
import 'forgot_password_page.dart';
import 'home_page.dart';
import 'sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.store});

  final DemoStore store;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'demo@boring.app');
  final _passwordController = TextEditingController(text: 'boring123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    if (!_formKey.currentState!.validate()) return;
    final success =
        widget.store.signIn(_emailController.text, _passwordController.text);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email or password is incorrect.')),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => HomePage(store: widget.store)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Center(child: BoringBrand()),
                          const SizedBox(height: 42),
                          AuthTextField(
                            key: const Key('login-email'),
                            label: 'Email Address',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                          ),
                          const SizedBox(height: 20),
                          AuthTextField(
                            key: const Key('login-password'),
                            label: 'Password',
                            controller: _passwordController,
                            isPassword: true,
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                    ? 'Enter your password.'
                                    : null,
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () async {
                                final navigator = Navigator.of(context);
                                final messenger = ScaffoldMessenger.of(context);
                                final resetEmail = await navigator
                                    .push<String>(MaterialPageRoute<String>(
                                  builder: (_) =>
                                      ForgotPasswordPage(store: widget.store),
                                ));
                                if (!mounted || resetEmail == null) return;
                                setState(() {
                                  _emailController.text = resetEmail;
                                  _passwordController.clear();
                                });
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Password updated. Sign in with your new password.'),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: appBlue,
                                padding:
                                    const EdgeInsets.only(top: 8, bottom: 10),
                                textStyle: const TextStyle(fontSize: 11),
                              ),
                              child: const Text('Forgot password?'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          FilledButton(
                            onPressed: _signIn,
                            style: FilledButton.styleFrom(
                              backgroundColor: appBlue,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(44),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7)),
                            ),
                            child: const Text('Log in',
                                style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 30),
                          const _OrDivider(),
                          const SizedBox(height: 22),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _SocialButton(label: 'Google'),
                              SizedBox(width: 22),
                              _SocialButton(label: 'Facebook'),
                            ],
                          ),
                          const SizedBox(height: 30),
                          const Center(
                            child: Text(
                              'Demo account: demo@boring.app / boring123',
                              style: TextStyle(fontSize: 11, color: appMuted),
                            ),
                          ),
                          const SizedBox(height: 26),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                    builder: (_) =>
                                        SignUpPage(store: widget.store)),
                              ),
                              child: const Text.rich(
                                TextSpan(
                                  style:
                                      TextStyle(color: appMuted, fontSize: 14),
                                  children: [
                                    TextSpan(text: "Don't have an account? "),
                                    TextSpan(
                                        text: 'Sign up',
                                        style: TextStyle(
                                            color: appBlue,
                                            fontWeight: FontWeight.w700)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String? _validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (!email.contains('@') || !email.contains('.')) {
    return 'Enter a valid email address.';
  }
  return null;
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(color: Color(0xFF8A8A8A))),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('OR',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
        Expanded(child: Divider(color: Color(0xFF8A8A8A))),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.8),
          borderRadius: BorderRadius.circular(6)),
      child: Text(label,
          style: const TextStyle(fontSize: 11, color: Colors.black)),
    );
  }
}

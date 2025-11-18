import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storyapp_dicoding/providers/auth_provider.dart';
import 'package:form_validator/form_validator.dart';
import 'package:storyapp_dicoding/widgets/language_switcher_widget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('register_title')),
        actions: const [LanguageSwitcherWidget()],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: tr('name_label'),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return tr('error_name_empty');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: tr('email_label'),
                    border: const OutlineInputBorder(),
                  ),
                  validator: ValidationBuilder()
                      .email(tr('error_email_invalid'))
                      .build(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: tr('password_label'),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: ValidationBuilder()
                      .minLength(8, tr('error_password_length'))
                      .build(),
                ),
                const SizedBox(height: 24),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return ElevatedButton(
                      onPressed: authProvider.isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                final result = await authProvider.register(
                                  _nameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                );

                                if (mounted) {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text(authProvider.message),
                                      ),
                                    );
                                  if (result) {
                                    context.go('/login');
                                  }
                                }
                              }
                            },
                      child: authProvider.isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(tr('register_button')),
                    );
                  },
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  child: Text(tr('has_account_prompt')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

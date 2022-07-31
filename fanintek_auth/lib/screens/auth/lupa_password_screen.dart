import 'package:fanintek_auth/providers/auth_provider.dart';
import 'package:fanintek_auth/screens/auth/auth_button.dart';
import 'package:fanintek_auth/utils/finite_state.dart';
import 'package:fanintek_auth/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LupaPasswordScreen extends StatefulWidget {
  const LupaPasswordScreen({super.key});

  @override
  State<LupaPasswordScreen> createState() => _LupaPasswordScreenState();
}

class _LupaPasswordScreenState extends State<LupaPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  bool isHiddenPassword = true;
  bool isHiddenConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: primaryColor500,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Lupa Password',
          style: titleTextStyle.copyWith(fontSize: 18.0),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          child: Column(
            children: [
              Text(
                'Link reset password akan dikirim via email',
                style: subtitleTextStyle.copyWith(fontSize: 14.0),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email Address',
                  hintStyle: subtitleTextStyle.copyWith(
                    color: colorWhite.withOpacity(0.5),
                  ),
                  errorStyle: subtitleTextStyle.copyWith(
                    color: Colors.red.shade800,
                    fontSize: 12.0,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      width: 1,
                      color: Colors.red.withOpacity(0.75),
                    ),
                  ),
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: colorWhite,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 20.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  fillColor: colorWhite.withOpacity(0.25),
                ),
                style: subtitleTextStyle,
                cursorColor: colorWhite,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  } else if (!RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$").hasMatch(value)) {
                    return 'Format email salah';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              authButton(
                context: context,
                textButton: 'SEND VERIFICATION',
                onTap: () async {
                  if (!_formKey.currentState!.validate()) return;

                  FocusScope.of(context).unfocus();

                  await provider.sendPasswordResetEmail(
                    email: _emailController.text.trim(),
                  );

                  if (provider.passwordResetState == MyState.failed) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: colorWhite,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Text(
                              provider.errorMessage,
                              style: subtitleTextStyle.copyWith(fontSize: 14.0),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (provider.passwordResetState == MyState.loaded) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 2),
                        content: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: colorWhite,
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Expanded(
                              child: Text(
                                'Link berhasil dikirim! Silahkan cek email',
                                style: subtitleTextStyle.copyWith(fontSize: 14.0),
                              ),
                            ),
                          ],
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:fanintek_auth/providers/auth_provider.dart';
import 'package:fanintek_auth/screens/auth/auth_button.dart';
import 'package:fanintek_auth/screens/auth/lupa_password_screen.dart';
import 'package:fanintek_auth/screens/auth/register_screen.dart';
import 'package:fanintek_auth/screens/home/home_screen.dart';
import 'package:fanintek_auth/utils/finite_state.dart';
import 'package:fanintek_auth/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])");

  bool isHiddenPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool validatePassword(String pass) {
    String password = pass.trim();
    if (passValid.hasMatch(password)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: primaryColor500,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTitleText('Sign In'),
              const SizedBox(
                height: 25.0,
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
                height: 8.0,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
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
                    Icons.lock_outline,
                    color: colorWhite,
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        isHiddenPassword = !isHiddenPassword;
                      });
                    },
                    child: isHiddenPassword
                        ? Icon(
                            Icons.visibility,
                            color: colorWhite.withOpacity(0.5),
                          )
                        : Icon(
                            Icons.visibility_off,
                            color: colorWhite.withOpacity(0.5),
                          ),
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
                obscureText: isHiddenPassword,
                cursorColor: colorWhite,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  } else if (value.length < 8) {
                    return 'Password minimal 8 karakter';
                  } else {
                    bool result = validatePassword(value);
                    if (result) {
                      return null;
                    } else {
                      return 'Harus mengandung huruf kapital dan angka';
                    }
                  }
                },
              ),
              _buildLupaPasswordTextButton(),
              const SizedBox(
                height: 8.0,
              ),
              authButton(
                context: context,
                textButton: 'LOGIN',
                onTap: () async {
                  if (!_formKey.currentState!.validate()) return;
                  FocusScope.of(context).unfocus();

                  await provider.signInWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );

                  if (provider.loginState == MyState.failed) {
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
                  } else if (provider.loginState == MyState.loaded) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: const EdgeInsets.all(20.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                size: 80,
                                color: Colors.green,
                              ),
                              const SizedBox(
                                height: 12.0,
                              ),
                              Text(
                                'Login Berhasil!',
                                style: subtitleTextStyle.copyWith(
                                  color: colorBlack,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );

                    Future.delayed(
                      const Duration(milliseconds: 3000),
                      () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (Route<dynamic> route) => false,
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(
                height: 16.0,
              ),
              _buildRegisterOption(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleText(String title) {
    return Center(
      child: Text(
        title,
        style: titleTextStyle,
      ),
    );
  }

  Widget _buildLupaPasswordTextButton() {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LupaPasswordScreen(),
            ),
          );
        },
        child: Text(
          'Lupa Password',
          style: subtitleTextStyle.copyWith(fontSize: 14.0),
        ),
      ),
    );
  }

  Widget _buildRegisterOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Belum punya akun?',
          style: subtitleTextStyle.copyWith(fontSize: 14.0),
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegisterScreen(),
              ),
            );
          },
          child: Text(
            'Sign Up',
            style: titleTextStyle.copyWith(
              fontSize: 14.0,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

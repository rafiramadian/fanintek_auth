import 'package:fanintek_auth/providers/auth_provider.dart';
import 'package:fanintek_auth/screens/auth/auth_button.dart';
import 'package:fanintek_auth/utils/finite_state.dart';
import 'package:fanintek_auth/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final RegExp passValid = RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])");

  bool isHiddenPassword = true;
  bool isHiddenConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Sign Up',
          style: titleTextStyle.copyWith(fontSize: 18.0),
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12.0,
            horizontal: 16.0,
          ),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Nama',
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
                    Icons.person_outline,
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
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Email',
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
                      return "Harus mengandung huruf kapital dan angka";
                    }
                  }
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  hintText: 'Konfirmasi Password',
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
                        isHiddenConfirmPassword = !isHiddenConfirmPassword;
                      });
                    },
                    child: isHiddenConfirmPassword
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
                obscureText: isHiddenConfirmPassword,
                cursorColor: colorWhite,
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi Password tidak boleh kosong';
                  } else if (value.length < 8) {
                    return 'Konfirmasi Password minimal 8 karakter';
                  } else if (_passwordController.text != value) {
                    return 'Password tidak sama';
                  } else {
                    bool result = validatePassword(value);
                    if (result) {
                      return null;
                    } else {
                      return "Harus mengandung huruf kapital dan angka";
                    }
                  }
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              authButton(
                context: context,
                textButton: 'REGISTER',
                onTap: () async {
                  if (!formKey.currentState!.validate()) return;
                  FocusScope.of(context).unfocus();

                  await provider.signUpWithEmailAndPassword(
                    nama: _nameController.text.trim(),
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                  );

                  if (provider.registerState == MyState.failed) {
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
                  } else if (provider.registerState == MyState.loaded) {
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
                                'Register berhasil! Silahkan cek email untuk verifikasi',
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

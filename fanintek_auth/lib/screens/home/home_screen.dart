import 'package:fanintek_auth/providers/auth_provider.dart';
import 'package:fanintek_auth/providers/user_provider.dart';
import 'package:fanintek_auth/screens/auth/login_screen.dart';
import 'package:fanintek_auth/screens/home/account_card.dart';
import 'package:fanintek_auth/utils/finite_state.dart';
import 'package:fanintek_auth/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);
    final isVerified = Provider.of<UserProvider>(context).isVerified;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(12.0),
          decoration: const BoxDecoration(
            color: primaryColor500,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30.0,
              ),
              Text(
                'Welcome',
                style: titleTextStyle,
              ),
              const SizedBox(
                height: 12.0,
              ),
              const Center(
                child: AccountCard(),
              ),
              const SizedBox(
                height: 12.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if (isVerified) {
                        return;
                      }
                      await provider.sendVerificationEmail();
                      if (provider.verificationEmailState == MyState.failed) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 3),
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: colorWhite,
                                ),
                                const SizedBox(
                                  width: 8.0,
                                ),
                                Expanded(
                                  child: Text(
                                    provider.errorMessage,
                                    style: subtitleTextStyle.copyWith(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else if (provider.verificationEmailState == MyState.loaded) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: const Duration(seconds: 3),
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
                                    'Sudah dikirim! Silahkan cek email',
                                    style: subtitleTextStyle.copyWith(fontSize: 14.0),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    child: Consumer<AuthProvider>(
                      builder: (context, provider, _) {
                        final isLoading = provider.verificationEmailState == MyState.loading;
                        return Container(
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isVerified ? Colors.grey : Colors.yellow,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    color: colorBlack,
                                  ),
                                )
                              : Row(
                                  children: [
                                    Text(
                                      'Verifikasi',
                                      style: subtitleTextStyle.copyWith(color: colorBlack, fontSize: 14.0),
                                    ),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    const Icon(
                                      Icons.mark_email_unread_outlined,
                                      size: 20,
                                    ),
                                  ],
                                ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            contentPadding: const EdgeInsets.all(20.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            content: provider.logoutState == MyState.loading
                                ? const Center(
                                    child: CircularProgressIndicator(color: primaryColor500),
                                  )
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.error,
                                        size: 70,
                                        color: primaryColor500,
                                      ),
                                      const SizedBox(
                                        height: 12.0,
                                      ),
                                      Text(
                                        'Yakin ingin keluar?',
                                        style: subtitleTextStyle.copyWith(
                                          color: colorBlack,
                                          fontSize: 20.0,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 12.0,
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8.0),
                                              alignment: Alignment.center,
                                              constraints: const BoxConstraints(
                                                minWidth: 100,
                                              ),
                                              decoration: BoxDecoration(
                                                color: colorBlack.withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(30.0),
                                              ),
                                              child: Text(
                                                'No',
                                                style: subtitleTextStyle.copyWith(color: colorBlack),
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await provider.signOut();

                                              if (provider.logoutState == MyState.failed) {
                                                // ignore: use_build_context_synchronously
                                                Navigator.pop(context);

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
                                                        Expanded(
                                                          child: Text(
                                                            provider.errorMessage,
                                                            style: subtitleTextStyle.copyWith(fontSize: 14.0),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              } else if (provider.logoutState == MyState.loaded) {
                                                // ignore: use_build_context_synchronously
                                                Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => const LoginScreen(),
                                                  ),
                                                  (Route<dynamic> route) => false,
                                                );

                                                // ignore: use_build_context_synchronously
                                                Provider.of<UserProvider>(context, listen: false)
                                                    .changeIsVerified(false);
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(8.0),
                                              alignment: Alignment.center,
                                              constraints: const BoxConstraints(
                                                minWidth: 100,
                                              ),
                                              decoration: BoxDecoration(
                                                color: primaryColor500,
                                                borderRadius: BorderRadius.circular(30.0),
                                              ),
                                              child: Text(
                                                'Yes',
                                                style: subtitleTextStyle,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                          );
                        },
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Logout',
                            style: subtitleTextStyle.copyWith(fontSize: 14.0),
                          ),
                          const SizedBox(
                            width: 8.0,
                          ),
                          const Icon(
                            Icons.logout,
                            size: 20,
                            color: colorWhite,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

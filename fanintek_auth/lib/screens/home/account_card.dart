import 'dart:async';

import 'package:fanintek_auth/providers/user_provider.dart';
import 'package:fanintek_auth/utils/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountCard extends StatefulWidget {
  const AccountCard({super.key});

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) async {
        final user = FirebaseAuth.instance.currentUser;
        await user?.reload();
        final isVerified = user?.emailVerified ?? false;
        if (isVerified) {
          timer.cancel();
          Future.delayed(Duration.zero, () {
            Provider.of<UserProvider>(context, listen: false).changeIsVerified(isVerified);
          });
        } else {
          Future.delayed(Duration.zero, () {
            Provider.of<UserProvider>(context, listen: false).changeIsVerified(isVerified);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProvider>(context, listen: false);
    return StreamBuilder<User?>(
      stream: provider.getIdTokenChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            padding: const EdgeInsets.all(12.0),
            constraints: const BoxConstraints(
              minHeight: 50,
              minWidth: 300,
            ),
            decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Center(
              child: Text(snapshot.error.toString()),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Container(
            padding: const EdgeInsets.all(12.0),
            constraints: const BoxConstraints(
              minHeight: 50,
              minWidth: 300,
            ),
            decoration: BoxDecoration(
              color: colorWhite,
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: const Center(
              child: Text('No Data'),
            ),
          );
        }

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              padding: const EdgeInsets.all(12.0),
              constraints: const BoxConstraints(
                minHeight: 50,
                minWidth: 300,
              ),
              decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: primaryColor500,
                ),
              ),
            );
          case ConnectionState.active:
            return Container(
              padding: const EdgeInsets.all(12.0),
              constraints: const BoxConstraints(
                minHeight: 50,
                minWidth: 300,
              ),
              decoration: BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: primaryColor500,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Text(
                      'Profile',
                      style: titleTextStyle.copyWith(fontSize: 20.0),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    'Nama',
                    style: titleTextStyle.copyWith(color: primaryColor500, fontSize: 20.0),
                  ),
                  Text(
                    snapshot.data!.displayName!,
                    style: subtitleTextStyle.copyWith(color: primaryColor500, fontSize: 14.0),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Text(
                    'Email',
                    style: titleTextStyle.copyWith(color: primaryColor500, fontSize: 20.0),
                  ),
                  Text(
                    snapshot.data!.email!,
                    style: subtitleTextStyle.copyWith(color: primaryColor500, fontSize: 14.0),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Text(
                    'Status Akun',
                    style: titleTextStyle.copyWith(color: primaryColor500, fontSize: 20.0),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Consumer<UserProvider>(
                    builder: (context, provider, _) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: provider.isVerified ? Colors.green : Colors.grey,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          provider.isVerified ? 'Terverikasi' : 'Belum terverifikasi',
                          style: subtitleTextStyle.copyWith(fontSize: 14.0),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}

import 'package:fanintek_auth/providers/auth_provider.dart';
import 'package:fanintek_auth/utils/finite_state.dart';
import 'package:fanintek_auth/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget authButton({
  required BuildContext context,
  required String textButton,
  required Function onTap,
}) {
  return Consumer<AuthProvider>(builder: (context, provider, _) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: Alignment.center,
        width: provider.loginState == MyState.loading ||
                provider.registerState == MyState.loading ||
                provider.passwordResetState == MyState.loading
            ? 80
            : MediaQuery.of(context).size.width * 0.5,
        height: 50,
        decoration: BoxDecoration(
          color: colorWhite.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Builder(
          builder: (context) {
            if (provider.loginState == MyState.loading ||
                provider.registerState == MyState.loading ||
                provider.passwordResetState == MyState.loading) {
              return const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: primaryColor500,
                ),
              );
            }

            return Text(
              textButton,
              style: titleTextStyle.copyWith(
                color: primaryColor500,
                fontSize: 16.0,
              ),
            );
          },
        ),
      ),
    );
  });
}

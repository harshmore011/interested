
import 'package:flutter/material.dart';
import '../../features/authentication/domain/entities/auth.dart';
import '../../features/authentication/presentation/pages/authentication_page.dart';

class AuthHelper {

  static void showAuthDialog(BuildContext context, {AuthSuccessNavigation? navigateTo}) {
    showDialog<void>(
        context: context,
        barrierColor: Colors.black54,
        builder: (context) {

      return Center(
        child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 375, maxHeight: 610),
            child: Flexible(child: AuthenticationPage(navigateTo: navigateTo))),
      );
    });

  }

}
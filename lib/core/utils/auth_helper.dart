
import 'package:flutter/material.dart';

import '../../features/authentication/presentation/pages/authentication_page.dart';

class AuthHelper {

  static void showAuthDialog(BuildContext context) {
    showDialog<void>(
        context: context,
        barrierColor: Colors.black54,
        builder: (context) {

      return Center(
        child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 375, maxHeight: 575),
            child: AuthenticationPage()),
      );
    });

  }

}
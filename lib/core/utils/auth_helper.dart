
import 'package:flutter/material.dart';
import 'package:interested/core/utils/shared_pref_helper.dart';
import '../../features/authentication/domain/entities/anonymous_entity.dart';
import '../../features/authentication/domain/entities/auth.dart';
import '../../features/authentication/domain/entities/user_entity.dart';
import '../../features/authentication/presentation/pages/authentication_page.dart';
import '../di/dependency_injector.dart' show sl;

class AuthHelper {

  static Future<bool> isUserUnAuthorized() async {
    if (!sl.isRegistered<User>(instanceName: "currentUser") ||
        !sl.isRegistered<Anonymous>(instanceName: "currentUser")) {

      await SharedPrefHelper.reloadCurrentUser();
    }

    if (!sl.isRegistered<User>(
        instanceName: "currentUser")) {

      return true;
    } else {
      return false;
    }
  }

  static void showAuthDialog(BuildContext context, {AuthSuccessNavigation? navigateTo}) {
    showDialog<void>(
        context: context,
        barrierColor: Colors.black54,
        builder: (context) {

      return Center(
        child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 375, maxHeight: 610),
            child: AuthenticationPage(navigateTo: navigateTo)),
      );
    });

  }

}
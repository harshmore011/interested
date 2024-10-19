import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:interested/core/utils/debug_logger.dart';

import '../../../../core/failures/exceptions.dart';
import '../../../../core/failures/failures.dart';
import '../../domain/entities/auth.dart';
import '../models/anonymous_model.dart';
import '../models/publisher_model.dart';
import '../models/user_model.dart';

abstract class AuthenticationDataSource {
  Future<AnonymousModel> anonymousSignIn();

  Future<UserModel> anonymousToUser(AuthParams params);

  Future<UserModel> userSignUp(AuthParams params);

  Future<UserModel> userSignIn(AuthParams params);

  Future<PublisherModel> publisherSignUp(AuthParams params);

  Future<PublisherModel> publisherSignIn(AuthParams params);

  Future<Unit> verifyEmail();

  Future<Unit> forgotPassword();

  Future<Unit> signOut();
}

class AuthenticationDataSourceImpl implements AuthenticationDataSource {
/*  @override
  Future<OnboardingModel> getOnboardingData() async {

    // supportingImage: Image.network("https://firebasestorage.googleapis.com/v0/b/interested-project-011.appspot.com/o/onboarding%2Fexplore.svg?alt=media&token=6ccddbd7-b8b9-4b5a-8efd-6aa3b15d6be0")

    try {

      var db = FirebaseFirestore.instance;

      var ref = db.collection("onboarding_data")
      .doc("getOnboardingData")
      .withConverter(fromFirestore: OnboardingModel.fromFirestore,
          toFirestore: (OnboardingModel onboardingModel, _) => onboardingModel.toFirestore());

      final docSnap = await ref.get();
      final onboardingModel = docSnap.data(); // Convert to object
      if (onboardingModel != null) {
        debugPrint("Onboarding model data: $onboardingModel");
        await _mapOnboardingImages(onboardingModel);

      } else {
        debugPrint("No onboarding document found on server.");
        throw OnboardingDataNotFoundException();
      }

      return onboardingModel;
        // return OnboardingModel.fromFirestore(onboardingData, null);

    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      // throw ServerException();
      // throw Exception("Failed to get onboarding data: $e");
      throw ServerException();
    }

  }
*/

  @override
  Future<AnonymousModel> anonymousSignIn() async {
    logger.log("AuthenticationDataSource:anonymousSignIn()",
        "AnonymousSignIn() called.");
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      logger.log("AuthenticationDataSource:anonymousSignIn()",
          "Signed in as anonymous.");

      logger.log("AuthenticationDataSource:anonymousSignIn()",
          "UserCredentialForAnonymous: $userCredential");

      AnonymousModel anonymous = AnonymousModel();

      return anonymous;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          logger.log("AuthenticationDataSource", e.toString());
          logger.log("AuthenticationDataSource",
              "Anonymous auth hasn't been enabled for this project.");
        default:
          logger.log("AuthenticationDataSource", "Unknown error. $e");
      }
      throw ServerException();
      // throw Exception("Failed to Authenticate: $e");
    }
  }

  @override
  Future<UserModel> anonymousToUser(AuthParams params) async {
    logger.log("AuthenticationDataSource:anonymousToUser()",
        "Params: $params");
    try {
      var user = FirebaseAuth.instance.currentUser;
      // Using credential to LINK anonymous user a/c to user a/c
      final AuthCredential credential;
      if (user != null) {
        if (params.authProvider == AuthenticationProvider.emailPassword) {
          credential = EmailAuthProvider.credential(
              email: params.credential!.email,
              password: params.credential!.password);
        } else if (params.authProvider == AuthenticationProvider.google) {
          String? idToken;
          user.reload();
          idToken = await user.getIdToken();
          credential = GoogleAuthProvider.credential(idToken: idToken);
        } else {
          logger.log("AuthenticationDataSource",
              "Unknown auth provider. $params.authProvider");
          throw ServerException();
        }

        final userCredential = await user.linkWithCredential(credential);
        logger.log("AuthenticationDataSource",
            "Anonymous user linked to user: $userCredential");

        return UserModel(
            name: userCredential.user!.displayName ?? "UnnamedUser",
            email: userCredential.user!.email ?? "NoEmail!",
            isEmailVerified: userCredential.user!.emailVerified);
        // return UserModel.fromFirebaseUser(userCredential.user!);
      } else {
        throw NoUserException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "provider-already-linked":
          logger.log("AuthenticationDataSource:anonymousToUser()",
              "The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          logger.log("AuthenticationDataSource:anonymousToUser()",
              "The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          logger.log(
              "AuthenticationDataSource:anonymousToUser()",
              "The account corresponding to the credential already exists, "
                  "or is already linked to a Firebase User.");
        case "email-already-in-use":
          throw EmailAlreadyInUseException();
        case "invalid-email":
          throw InvalidEmailException();
        case "operation-not-allowed":
          break;
        // See the API reference for the full list of error codes.
        default:
          logger.log(
              "AuthenticationDataSource:anonymousToUser()", "Unknown error.");
      }
      throw ServerException();
    }
  }

  @override
  Future<UserModel> userSignIn(AuthParams params) async {
    logger.log("AuthenticationDataSource:userSignIn()", "Params: $params");
    try {
      final UserCredential userCredential;
      if (params.authProvider == AuthenticationProvider.emailPassword) {
        userCredential = await _signInWithEmailPassword(params);
      } else if (params.authProvider == AuthenticationProvider.google) {
        userCredential = await _signInWithGoogle();
      } else {
        logger.log("AuthenticationDataSource",
            "Unknown auth provider. $params.authProvider");
        throw ServerException();
      }

      logger.log(
          "AuthenticationDataSource", "New user signed up: $userCredential");

      return UserModel(
          name: userCredential.user!.displayName ?? "UnnamedUser",
          email: userCredential.user!.email ?? "NoEmail!",
          isEmailVerified: userCredential.user!.emailVerified);
      // return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      logger.log("AuthenticationDataSource:userSignIn()", "$e");

      switch (e.code) {
        case "provider-already-linked":
          logger.log("AuthenticationDataSource:userSignIn()",
              "The provider has already been linked to the user.");
          break;
        case "wrong-password":
          throw WrongPasswordException();
        case "invalid-credential":
          logger.log("AuthenticationDataSource:userSignIn()",
              "The provider's credential is not valid.");
          throw InvalidCredentialException();
        case "user-not-found":
          throw NoUserException();
        case "credential-already-in-use":
          logger.log(
              "AuthenticationDataSource:userSignIn()",
              "The account corresponding to the credential already exists, "
                  "or is already linked to a Firebase User.");
          break;
        case "weak-password":
          // Thrown if the password is not strong enough.
          throw WeakPasswordException();
        case "too-many-requests":
          // Thrown if the user sent too many requests at the same time, for security
          // the api will not allow too many attemps at the same time, user will have to wait for some time
          throw TooManyRequestsException();
        // case "user-token-expired":
        // Thrown if the user is no longer authenticated since his refresh token has been expired
        // case "network-request-failed":
        // Thrown if there was a network request error, for example the user don't
        // have internet connection
        case "email-already-in-use":
          throw EmailAlreadyInUseException();
        case "invalid-email":
          throw InvalidEmailException();
        case "operation-not-allowed":
          break;
        // See the API reference for the full list of error codes.
        default:
          logger.log("AuthenticationDataSource:userSignIn()", "Unknown error.");
      }
      throw ServerException();
    }
  }

  @override
  Future<UserModel> userSignUp(AuthParams params) async {
    logger.log("AuthenticationDataSource:userSignUp()", "params: $params");
    try {
      final UserCredential userCredential;
      if (params.authProvider == AuthenticationProvider.emailPassword) {
        userCredential = await _signUpWithEmailPassword(params);
      } else if (params.authProvider == AuthenticationProvider.google) {
        userCredential = await _signInWithGoogle();
      } else {
        logger.log("AuthenticationDataSource",
            "Unknown auth provider. $params.authProvider");
        throw ServerException();
      }

      logger.log(
          "AuthenticationDataSource", "New user signed up: $userCredential");

      return UserModel(
          name: userCredential.user!.displayName ?? "UnnamedUser",
          email: userCredential.user!.email ?? "NoEmail!",
          isEmailVerified: userCredential.user!.emailVerified);
      // return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      logger.log("AuthenticationDataSource:userSignUp()", "$e");

      switch (e.code) {
        case "provider-already-linked":
          logger.log("AuthenticationDataSource:userSignUp()",
              "The provider has already been linked to the user.");
          break;
        case "invalid-credential":
          logger.log("AuthenticationDataSource:userSignUp()",
              "The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          logger.log(
              "AuthenticationDataSource:userSignUp()",
              "The account corresponding to the credential already exists, "
                  "or is already linked to a Firebase User.");
          break;
        case "weak-password":
          // Thrown if the password is not strong enough.
          throw WeakPasswordException();
        case "too-many-requests":
          // Thrown if the user sent too many requests at the same time, for security
          // the api will not allow too many attemps at the same time, user will have to wait for some time
          throw TooManyRequestsException();
        // case "user-token-expired":
        // Thrown if the user is no longer authenticated since his refresh token has been expired
        // case "network-request-failed":
        // Thrown if there was a network request error, for example the user don't
        // have internet connection
        case "email-already-in-use":
          throw EmailAlreadyInUseException();
        case "invalid-email":
          throw InvalidEmailException();
        case "operation-not-allowed":
          break;
        // See the API reference for the full list of error codes.
        default:
          logger.log("AuthenticationDataSource:userSignUp()", "Unknown error.");
      }
      throw ServerException();
    }
  }

  Future<UserCredential> _signInWithGoogle() async {
    logger.log("AuthenticationDataSource:_signInWithGoogle()","");
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.addScope('https://www.googleapis.com/auth/userinfo.email');
    // googleProvider.addScope('https://www.googleapis.com/auth/userinfo.profile');
    // googleProvider.addScope('https://www.googleapis.com/auth/cloud-platform');
    googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithPopup(googleProvider);

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  Future<UserCredential> _signUpWithEmailPassword(AuthParams params) async {
    logger.log("AuthenticationDataSource:_signUpWithEmailPassword()","");
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: params.credential!.email, password: params.credential!.password);
  }

  Future<UserCredential> _signInWithEmailPassword(AuthParams params) async {
    logger.log("AuthenticationDataSource:_signInWithEmailPassword()","");
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: params.credential!.email, password: params.credential!.password);
  }

  @override
  Future<PublisherModel> publisherSignIn(AuthParams params) async {
    logger.log("AuthenticationDataSource:publisherSignIn()", "Params: $params");
    try {
      final UserCredential userCredential;
      if (params.authProvider == AuthenticationProvider.emailPassword) {
        userCredential = await _signInWithEmailPassword(params);
      } else if (params.authProvider == AuthenticationProvider.google) {
        userCredential = await _signInWithGoogle();
      } else {
        logger.log("AuthenticationDataSource:publisherSignIn()",
            "Unknown auth provider. $params.authProvider");
        throw ServerException();
      }

      logger.log("AuthenticationDataSource",
          "New publisher signed up: $userCredential");

      return PublisherModel(
          name: userCredential.user!.displayName ?? "UnnamedUser",
          email: userCredential.user!.email ?? "NoEmail!",
          isEmailVerified: userCredential.user!.emailVerified,
          about: "",
          followersCount: 0);
      // return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      logger.log("AuthenticationDataSource:publisherSignIn()", "$e");

      switch (e.code) {
        case "invalid-credential":
          logger.log("AuthenticationDataSource:publisherSignIn()",
              "The provider's credential is not valid.");
          break;
        case "wrong-password":
          throw WrongPasswordException();
        case "invalid-credential":
          logger.log("AuthenticationDataSource:userSignIn()",
              "The provider's credential is not valid.");
          throw InvalidCredentialException();
        case "credential-already-in-use":
          logger.log(
              "AuthenticationDataSource:publisherSignIn()",
              "The account corresponding to the credential already exists, "
                  "or is already linked to a Firebase User.");
          break;
        case "weak-password":
          // Thrown if the password is not strong enough.
          throw WeakPasswordException();
        case "too-many-requests":
          // Thrown if the user sent too many requests at the same time, for security
          // the api will not allow too many attemps at the same time, user will have to wait for some time
          throw TooManyRequestsException();
        // case "user-token-expired":
        // Thrown if the user is no longer authenticated since his refresh token has been expired
        // case "network-request-failed":
        // Thrown if there was a network request error, for example the user don't
        // have internet connection
        case "email-already-in-use":
          throw EmailAlreadyInUseException();
        case "invalid-email":
          throw InvalidEmailException();
        case "operation-not-allowed":
          break;
        // See the API reference for the full list of error codes.
        default:
          logger.log(
              "AuthenticationDataSource:publisherSignIn()", "Unknown error.");
      }
      throw ServerException();
    }
  }

  @override
  Future<PublisherModel> publisherSignUp(AuthParams params) async {
    logger.log("AuthenticationDataSource:publisherSignUp()", "params: $params");
    try {
      final UserCredential userCredential;
      if (params.authProvider == AuthenticationProvider.emailPassword) {
        userCredential = await _signUpWithEmailPassword(params);
      } else if (params.authProvider == AuthenticationProvider.google) {
        userCredential = await _signInWithGoogle();
      } else {
        logger.log("AuthenticationDataSource:publisherSignUp()",
            "Unknown auth provider. $params.authProvider");
        throw ServerException();
      }

      logger.log("AuthenticationDataSource",
          "New publisher signed up: $userCredential");

      return PublisherModel(
          name: userCredential.user!.displayName ?? "UnnamedUser",
          email: userCredential.user!.email ?? "NoEmail!",
          isEmailVerified: userCredential.user!.emailVerified,
          about: "",
          followersCount: 0);
      // return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      logger.log("AuthenticationDataSource:publisherSignUp()", "$e");

      switch (e.code) {
        case "invalid-credential":
          logger.log("AuthenticationDataSource:publisherSignUp()",
              "The provider's credential is not valid.");
          break;
        case "credential-already-in-use":
          logger.log(
              "AuthenticationDataSource:publisherSignUp()",
              "The account corresponding to the credential already exists, "
                  "or is already linked to a Firebase User.");
          break;
        case "weak-password":
          // Thrown if the password is not strong enough.
          throw WeakPasswordException();
        case "too-many-requests":
          // Thrown if the user sent too many requests at the same time, for security
          // the api will not allow too many attemps at the same time, user will have to wait for some time
          throw TooManyRequestsException();
        // case "user-token-expired":
        // Thrown if the user is no longer authenticated since his refresh token has been expired
        // case "network-request-failed":
        // Thrown if there was a network request error, for example the user don't
        // have internet connection
        case "email-already-in-use":
          throw EmailAlreadyInUseException();
        case "invalid-email":
          throw InvalidEmailException();
        case "operation-not-allowed":
          break;
        // See the API reference for the full list of error codes.
        default:
          logger.log(
              "AuthenticationDataSource:publisherSignUp()", "Unknown error.");
      }
      throw ServerException();
    }
  }

  @override
  Future<Unit> verifyEmail() async {
    logger.log("AuthenticationDataSource:verifyEmail()", "started");
    try {
      var user = FirebaseAuth.instance.currentUser;

      if (user != null) {
          user.reload();
          user.sendEmailVerification();

          return Future.value(unit);
      } else {
        throw NoUserException();
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "too-many-requests":
        // Thrown if the user sent too many requests at the same time, for security
        // the api will not allow too many attemps at the same time, user will have to wait for some time
          throw TooManyRequestsException();
        default:
          logger.log(
              "AuthenticationDataSource:verifyEmail()", "Unknown error.");
      }
      throw ServerException();
    }
  }

  @override
  Future<Unit> forgotPassword() {
    throw UnimplementedError();
  }

  @override
  Future<Unit> signOut() async {
    logger.log("AuthenticationDataSource:signOut()", "started");
    try {
      await FirebaseAuth.instance.signOut();
        return Future.value(unit);

    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        default:
          logger.log(
              "AuthenticationDataSource:signOut()", "Unknown error.");
      }
      throw ServerException();
    }
  }
}

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/di/dependency_injector.dart';
import '../../../../core/failures/exceptions.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../../../core/utils/shared_pref_helper.dart';
import '../../domain/entities/anonymous_entity.dart';
import '../../domain/entities/auth.dart';
import '../models/anonymous_model.dart';
import '../models/publisher_model.dart';
import '../models/user_model.dart';

abstract class AuthenticationDataSource {
  Future<AnonymousModel> anonymousSignIn();

  Future<UserModel> anonymousToUser(AuthParams params);

  Future<UserModel> userSignUp(AuthParams params);

  Future<UserModel> userSignIn(AuthParams params);

  Future<void> switchToUser();

  Future<void> switchToPublisher();

  Future<PublisherModel> publisherSignUp(AuthParams params);

  Future<PublisherModel> publisherSignIn(AuthParams params);

  Future<Unit> verifyEmail();

  Future<Unit> forgotPassword();

  Future<Unit> signOut();
}

class AuthenticationDataSourceImpl implements AuthenticationDataSource {

  _storePersonToFirestore(
      {AnonymousModel? anonymous,
      UserModel? user,
      PublisherModel? publisher}) async {
    final db = FirebaseFirestore.instance;


    if (anonymous != null && user == null) {
      await db
          .collection("anonymous")
          .doc(anonymous.uid)
          .set(anonymous.toJson());
    }
    if (user != null) {
      // check and add new user if does not already exists
      final userDocRef = db.collection("users").doc(user.email);
      final userDoc = await userDocRef.get();
      if (!userDoc.exists) {
        await userDocRef.set(user.toJson());
        if (anonymous != null) {
          await linkAnonymousModelDataToUser(anonymous, userDocRef);
        }

      }
      _checkAndAddNewPersonRole(db, user.email, PersonRole.user);
    }
    if (publisher != null) {
      // check and add new publisher if does not already exists
      final publisherDocRef = db.collection("publishers").doc(publisher.email);
      final publisherDoc = await publisherDocRef.get();
      if (!publisherDoc.exists) {
        await publisherDocRef.set(publisher.toJson());
      }
      _checkAndAddNewPersonRole(db, publisher.email, PersonRole.publisher);
    }
  }

  Future<void> _checkAndAddNewPersonRole(FirebaseFirestore? dbInstance,
      String email, PersonRole personCurrRole) async {
    logger.log(
        "AuthenticationDataSource:_checkAndAddNewPersonRole()", "started");
    FirebaseFirestore db = dbInstance ?? FirebaseFirestore.instance;

    // if same user already exists as publisher, check and add new publisher role in publisherModel
    if (personCurrRole == PersonRole.user) {
      final publisherDocRef = db.collection("publishers").doc(email);
      final pubDoc = await publisherDocRef.get();
      if (pubDoc.exists) {
        PublisherModel publisher = PublisherModel.fromJson(pubDoc.data()!);
        if (!publisher.personRoles.contains(PersonRole.user)) {
          publisher.personRoles.add(PersonRole.user);
          await publisherDocRef.update(publisher.toJson());
        }
      }
    }

    // if same publisher already exists as user, check and add new user role in userModel
    if (personCurrRole == PersonRole.publisher) {
      final userDocRef = db.collection("users").doc(email);
      final userDoc = await userDocRef.get();
      if (userDoc.exists) {
        UserModel user = UserModel.fromJson(userDoc.data()!);
        if (!user.personRoles.contains(PersonRole.publisher)) {
          user.personRoles.add(PersonRole.publisher);
          await userDocRef.update(user.toJson());
        }
      }
    }
  }

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

      // UserCredentialForAnonymous:
      /* UserCredential(additionalUserInfo: AdditionalUserInfo(isNewUser: true, profile: {},
          providerId: null, username: null, authorizationCode: null), credential: null,
          user: User(displayName: null, email: null, isEmailVerified: false,
              isAnonymous: true, metadata: UserMetadata(creationTime: 2024-10-20 07:37:03.000Z,
                  lastSignInTime: 2024-10-20 07:37:03.000Z), phoneNumber: null,
              photoURL: null, providerData, [], refreshToken:
              eyJfQXV0aEVtdWxhdG9yUmVmcmVzaFRva2VuIjoiRE8gTk9UIE1PRElGWSIsImxvY2FsSW
              QiOiJWMnVOSTFKWERtVHRYdUtROTJ6WVlib3hDOGt0IiwicHJvdmlkZXIiOiJhbm9ueW1vdXMiLC
              JleHRyYUNsYWltcyI6e30sInByb2plY3RJZCI6ImludGVyZXN0ZWQtcHJvamVjdC0wMTEifQ==,
              tenantId: null, uid: V2uNI1JXDmTtXuKQ92zYYboxC8kt))*/

      User anonymousUser = userCredential.user!;

      AnonymousModel anonymous = AnonymousModel(
        creationTime: anonymousUser.metadata.creationTime!,
        lastSignInTime: anonymousUser.metadata.lastSignInTime!,
        refreshToken: anonymousUser.refreshToken!,
        uid: anonymousUser.uid,
      );

      await SharedPrefHelper.storePersonLocallyByKey(
          "anonymousModel", jsonEncode(anonymous.toJson()));
      await _storePersonToFirestore(anonymous: anonymous);

      return anonymous;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          logger.log("AuthenticationDataSource", e.toString());
        default:
          logger.log("AuthenticationDataSource", "Unknown error. $e");
      }
      throw ServerException();
      // throw Exception("Failed to Authenticate: $e");
    }
  }

  @override
  Future<UserModel> anonymousToUser(AuthParams params) async {
    logger.log("AuthenticationDataSource:anonymousToUser()", "Params: $params");
    try {
      var user = FirebaseAuth.instance.currentUser;

      logger.log("AuthenticationDataSource:anonymousToUser()",
          "anonymous user before linking: $user");

      // Using credential to LINK anonymous user a/c to user a/c
      final UserCredential userCredential;
      if (user != null) {
        if (params.authProvider == AuthenticationProvider.emailPassword) {
          final AuthCredential credential = EmailAuthProvider.credential(
              email: params.credential!.email,
              password: params.credential!.password);

          userCredential = await user.linkWithCredential(credential);

        } else if (params.authProvider == AuthenticationProvider.google) {

          userCredential = await _signInWithGoogle();

         /* String? idToken;
          user.reload();
          idToken = await user.getIdToken();
          credential = GoogleAuthProvider.credential(idToken: idToken);*/
        } else {
          logger.log("AuthenticationDataSource",
              "Unknown auth provider. $params.authProvider");
          throw ServerException();
        }

        logger.log("AuthenticationDataSource",
            "Anonymous user linked to user: $userCredential");

        user = userCredential.user!;
        final String name = user.displayName ?? user.email!.split("@")[0];

        UserModel userModel = UserModel(
            name: name,
            email: user.email!,
            isEmailVerified: user.emailVerified,
            creationTime: user.metadata.creationTime!,
            lastSignInTime: user.metadata.lastSignInTime!,
            authProvider: params.authProvider,
            refreshToken: user.refreshToken!,
            uid: user.uid);

        userModel.setPersonRoles([PersonRole.user]);

        // sl.registerLazySingleton<User>(() => userModel);

        AnonymousModel? anonymousModel;
        if(sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
          logger.log("AuthenticationDataSource:anonymousToUser()", "Unregistering anonymous user");
          Anonymous anonymous = sl<Anonymous>(instanceName: "currentUser");
          anonymousModel = AnonymousModel(
            creationTime: anonymous.creationTime,
            lastSignInTime: anonymous.lastSignInTime,
            refreshToken: anonymous.refreshToken,
            uid: anonymous.uid
          );
          sl.unregister<Anonymous>(instanceName: "currentUser");
        }
        await SharedPrefHelper.removePersonLocallyByKey("anonymousModel");

        await SharedPrefHelper.storePersonLocallyByKey(
            "userModel", jsonEncode(userModel.toJson()));

        await _storePersonToFirestore(anonymous: anonymousModel, user: userModel);

        return userModel;
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

  linkAnonymousModelDataToUser(AnonymousModel anonymous, DocumentReference
  <Map<String, dynamic>> userDocRef) async {
    logger.log("AuthenticationDataSource:linkAnonymousModelDataToUser()", "Started");

    var anonymousModel =
      await FirebaseFirestore.instance
          .collection("anonymous")
          .doc(anonymous.uid)
          .get()
          .then((value) => value.data()!);

    userDocRef.update({"viewedArticles": anonymousModel["viewedArticles"]});

  }


  @override
  Future<UserModel> userSignIn(AuthParams params) async {
    logger.log("AuthenticationDataSource:userSignIn()", "Params: $params");
    try {
      final UserCredential userCredential;
      if (params.authProvider == AuthenticationProvider.emailPassword) {
        userCredential = await _signInWithEmailPassword(params);
        /*New user signed up: UserCredential(additionalUserInfo: AdditionalUserInfo(
        isNewUser: true, profile: {}, providerId: password, username: null, authorizationCode:
         null), credential: null, user: User(displayName: null, email: harshmore011@gmail.com,
          isEmailVerified: false, isAnonymous: false, metadata: UserMetadata(creationTime:
           2024-10-20 08:28:29.000Z, lastSignInTime: 2024-10-20 08:28:29.000Z), phoneNumber:
            null, photoURL: null, providerData, [UserInfo(displayName: null, email:
             harshmore011@gmail.com, phoneNumber: null, photoURL: null, providerId:
             password, uid: harshmore011@gmail.com)], refreshToken: eyJfQXV0aEVtdWxhdG9yUmVmcm
             VzaFRva2VuIjoiRE8gTk9UIE1PRElGWSIsImxvY2FsSWQiOiJlN1VXR3Q4N29zcVR0dEViY0xsdHliY
             2RoVWlSIiwicHJvdmlkZXIiOiJwYXNzd29yZCIsImV4dHJhQ2xhaW1zIjp7fSwicHJvamVjdElkIjoiaW50
             ZXJlc3RlZC1wcm9qZWN0LTAxMSJ9, tenantId: null, uid: e7UWGt87osqTttEbcLltybcdhUiR))*/
      } else if (params.authProvider == AuthenticationProvider.google) {
        userCredential = await _signInWithGoogle();

        // New user signed up:
        // UserCredential(additionalUserInfo: AdditionalUserInfo(isNewUser: true, profile:
        // {granted_scopes: openid https://www.googleapis.com/auth/userinfo.profile
        // https://www.googleapis.com/auth/userinfo.email, id:
        // 7307007536320925425031238435275611536907, name: Panda Chicken, verified_email: true,
        // locale: en, email: panda.chicken.80@example.com}, providerId: google.com, username:
        // null, authorizationCode: null), credential: AuthCredential(providerId: google.com,
        // signInMethod: google.com, token: null, accessToken:
        // FirebaseAuthEmulatorFakeAccessToken_google.com), user: User(displayName: Panda Chicken,
        // email: panda.chicken.80@example.com, isEmailVerified: true, isAnonymous: false,
        // metadata: UserMetadata(creationTime: 2024-10-20 08:11:54.000Z, lastSignInTime:
        // 2024-10-20 08:11:54.000Z), phoneNumber: null, photoURL: null, providerData,
        // [UserInfo(displayName: Panda Chicken, email: panda.chicken.80@example.com,
        // phoneNumber: null, photoURL: null, providerId: google.com, uid:
        // 7307007536320925425031238435275611536907)], refreshToken:
        // eyJfQXV0aEVtdWxhdG9yUmVmcmVzaFRva2VuIjoiRE8gTk9UIE1PRElGWSIsImxvY2FsSWQiOiJ6Rm1lcmdoYkY5eU
        // E4UTZ2cnNINzRlNEJtcUw4IiwicHJvdmlkZXIiOiJnb29nbGUuY29tIiwiZXh0cmFDbGFpbXMiOnt9LC
        // Jwcm9qZWN0SWQiOiJpbnRlcmVzdGVkLXByb2plY3QtMDExIn0=, tenantId: null, uid: zFmerghbF9yA8Q6vrsH74e4BmqL8))
      } else {
        logger.log("AuthenticationDataSource",
            "Unknown auth provider. $params.authProvider");
        throw ServerException();
      }

      logger.log(
          "AuthenticationDataSource", "New user signed up: $userCredential");

      User user = userCredential.user!;
      final String name = user.displayName ?? user.email!.split("@")[0];

      UserModel userModel = UserModel(
          name: name,
          email: user.email!,
          isEmailVerified: user.emailVerified,
          creationTime: user.metadata.creationTime!,
          lastSignInTime: user.metadata.lastSignInTime!,
          authProvider: params.authProvider,
          refreshToken: user.refreshToken!,
          uid: user.uid);
      userModel.personRoles.add(PersonRole.user);

      // sl.registerLazySingleton<User>(() => userModel);
      // Anonymous to user flow: If anonymous user exists, unregister it
      if(sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
        logger.log("AuthenticationDataSource:anonymousToUser()", "Unregistering anonymous user");
        sl.unregister<Anonymous>(instanceName: "currentUser");
      }
      await SharedPrefHelper.removePersonLocallyByKey("anonymousModel");

      await SharedPrefHelper.storePersonLocallyByKey(
          "userModel", jsonEncode(userModel.toJson()));
      await _storePersonToFirestore(user: userModel);

      return userModel;
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

      User user = userCredential.user!;
      final String name = user.displayName ?? user.email!.split("@")[0];

      UserModel userModel = UserModel(
          name: name,
          email: user.email!,
          isEmailVerified: user.emailVerified,
          creationTime: user.metadata.creationTime!,
          lastSignInTime: user.metadata.lastSignInTime!,
          authProvider: params.authProvider,
          refreshToken: user.refreshToken!,
          uid: user.uid);

      userModel.setPersonRoles([PersonRole.user]);

      // sl.registerLazySingleton<User>(() => userModel);

      await SharedPrefHelper.storePersonLocallyByKey(
          "userModel", jsonEncode(userModel.toJson()));
      await _storePersonToFirestore(user: userModel);

      return userModel;
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
    logger.log("AuthenticationDataSource:_signInWithGoogle()", "");
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

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
    logger.log("AuthenticationDataSource:_signUpWithEmailPassword()", "");
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: params.credential!.email, password: params.credential!.password);
  }

  Future<UserCredential> _signInWithEmailPassword(AuthParams params) async {
    logger.log("AuthenticationDataSource:_signInWithEmailPassword()", "");
    return await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: params.credential!.email, password: params.credential!.password);
  }

  // NO NEED TO BE IMPLEMENTED! Can be used to make existing user a publisher
  @override
  Future<void> switchToPublisher() async {
    logger.log("AuthenticationDataSource:switchToPublisher()", "");

/*    if(!sl.isRegistered(instanceName: "currentUser")){
      await SharedPrefHelper.reloadCurrentUser();
    }*/

    // User user = sl.get(instanceName: "currentUser");

    try {
      final doc = await FirebaseFirestore.instance
          .collection("publishers")
          .doc("")
          .get();

      if (doc.exists) {
        logger.log("AuthenticationDataSource:switchToPublisher()",
            "Publisher already exists");

        // PublisherModel publisherModel = PublisherModel.fromJson(doc.data()!);

        return;
      } else {
        // New Publisher, so he needs to sign up as one first
        logger.log("AuthenticationDataSource:switchToPublisher()",
            "Switching to publisher");
        /* if(user.authProvider == AuthenticationProvider.emailPassword) {
          // TODO: Show Authentication screen and then sign out as user
          throw NoUserException();
        } else if (userModel.authProvider == AuthenticationProvider.google) {
          publisherSignUp(AuthParams(authProvider: AuthenticationProvider.google));
        }*/
      }
    } catch (e) {
      logger.log("AuthenticationDataSource:switchToPublisher()", "$e");
      throw ServerException();
    }
  }

  @override
  Future<void> switchToUser() {
    // TODO: implement switchToUser
    throw UnimplementedError();
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

      User user = userCredential.user!;
      final String name = user.displayName ?? user.email!.split("@")[0];

      PublisherModel publisherModel = PublisherModel(
          name: name,
          email: user.email!,
          about: "",
          followersCount: 0,
          isEmailVerified: user.emailVerified,
          creationTime: user.metadata.creationTime!,
          lastSignInTime: user.metadata.lastSignInTime!,
          authProvider: params.authProvider,
          refreshToken: user.refreshToken!,
          uid: user.uid);
      publisherModel.personRoles.add(PersonRole.publisher);

      // sl.registerLazySingleton<Publisher>(() => publisherModel);

      await SharedPrefHelper.storePersonLocallyByKey(
          "publisherModel", jsonEncode(publisherModel.toJson()));
      await _storePersonToFirestore(publisher: publisherModel);

      return publisherModel;
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
          // the api will not allow too many attempts at the same time, user will have to wait for some time
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

      User user = userCredential.user!;
      final String name = user.displayName ?? user.email!.split("@")[0];

      PublisherModel publisherModel = PublisherModel(
          name: name,
          email: user.email!,
          about: "",
          followersCount: 0,
          isEmailVerified: user.emailVerified,
          creationTime: user.metadata.creationTime!,
          lastSignInTime: user.metadata.lastSignInTime!,
          authProvider: params.authProvider,
          refreshToken: user.refreshToken!,
          uid: user.uid);
      publisherModel.personRoles.add(PersonRole.publisher);

      // sl.registerLazySingleton<Publisher>(() => publisherModel);

      await SharedPrefHelper.storePersonLocallyByKey(
          "publisherModel", jsonEncode(publisherModel.toJson()));
      await _storePersonToFirestore(publisher: publisherModel);

      return publisherModel;
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
          logger.log("AuthenticationDataSource:signOut()", "Unknown error.");
      }
      throw ServerException();
    }
  }

}

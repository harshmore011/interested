
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/authentication/data/models/anonymous_model.dart';
import '../../features/authentication/data/models/publisher_model.dart';
import '../../features/authentication/data/models/user_model.dart';
import '../../features/authentication/domain/entities/anonymous_entity.dart';
import '../../features/authentication/domain/entities/publisher_entity.dart';
import '../../features/authentication/domain/entities/user_entity.dart';
import '../di/dependency_injector.dart';
import 'debug_logger.dart';

class SharedPrefHelper {

  static storePersonLocallyByKey(String key, String personModel) async {
    logger.log("SharedPrefHelper", "storePersonLocallyByKey()");
    SharedPreferencesWithCache pref = await SharedPreferencesWithCache.create(cacheOptions:
    SharedPreferencesWithCacheOptions(
      allowList: <String>{"anonymousModel","userModel","publisherModel"},
    ));
    pref.setString(key, personModel);
  }
  static removePersonLocallyByKey(String key) async {
    logger.log("SharedPrefHelper", "removePersonLocallyByKey()");
    SharedPreferencesWithCache pref = await SharedPreferencesWithCache.create(cacheOptions:
    SharedPreferencesWithCacheOptions(
      allowList: <String>{"anonymousModel","userModel","publisherModel"},
    ));
    pref.remove(key);
  }


  static clearPersonLocally() async {
    logger.log("SharedPrefHelper", "decideInitialRoute()");
    SharedPreferencesWithCache pref = await SharedPreferencesWithCache.create(cacheOptions:
    SharedPreferencesWithCacheOptions(
      allowList: <String>{"anonymousModel","userModel","publisherModel"},
    ));

    pref.clear();
  }

  static reloadCurrentUser() async {
    logger.log("SharedPrefHelper", "reloadCurrentUser()");
    SharedPreferencesWithCache pref = await SharedPreferencesWithCache.create(cacheOptions:
    SharedPreferencesWithCacheOptions(
      allowList: <String>{"anonymousModel","userModel","publisherModel"},
    ));

    String? json;
    if(pref.containsKey("anonymousModel")) {
      json = pref.getString("anonymousModel");
      logger.log("SharedPrefHelper", "reloadCurrentUser(): Current anonymous user: $json");
      if(!sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
        sl.registerLazySingleton<Anonymous>(() => AnonymousModel.fromJson(jsonDecode(json!))
      , instanceName: "currentUser");
      }
      // sl.registerSingleton<PersonRole>(PersonRole.anonymous, instanceName: "currentUser");

    } else if(pref.containsKey("userModel")) {
      json = pref.getString("userModel");
      logger.log("SharedPrefHelper", "reloadCurrentUser(): Current user user: $json");
      if(!sl.isRegistered<User>(instanceName: "currentUser")) {
        sl.registerLazySingleton<User>(() => UserModel.fromJson(jsonDecode(json!)),
      instanceName: "currentUser");
      }
      // sl.registerSingleton<PersonRole>(PersonRole.user, instanceName: "currentUser");

    } else if(pref.containsKey("publisherModel")) {
      json = pref.getString("publisherModel");
      logger.log("SharedPrefHelper", "reloadCurrentUser(): Current publisher user: $json");
      if(!sl.isRegistered<Publisher>(instanceName: "currentUser")) {
        sl.registerLazySingleton<Publisher>(() => PublisherModel.fromJson(jsonDecode(json!)),
      instanceName: "currentUser");
      }
      // sl.registerSingleton<PersonRole>(PersonRole.publisher, instanceName: "currentUser");
    }

    logger.log("SharedPrefHelper", "reloadCurrentUser(): Current user: $json");

  }

/*  static getCurrentUser() async {
    logger.log("SharedPrefHelper", "reloadCurrentUser()");
    SharedPreferencesWithCache pref = await SharedPreferencesWithCache.create(cacheOptions:
    SharedPreferencesWithCacheOptions(
      allowList: <String>{"anonymousModel","userModel","publisherModel"},
    ));

    String? json;
    if(pref.containsKey("anonymousModel")) {
      json = pref.getString("anonymousModel");
      logger.log("SharedPrefHelper", "reloadCurrentUser(): Current anonymous user: $json");
      sl.registerLazySingleton<Anonymous>(() => AnonymousModel.fromJson(jsonDecode(json!)));

    } else if(pref.containsKey("userModel")) {
      json = pref.getString("userModel");
      logger.log("SharedPrefHelper", "reloadCurrentUser(): Current user user: $json");
      sl.registerLazySingleton<User>(() => UserModel.fromJson(jsonDecode(json!)));

    } else if(pref.containsKey("publisherModel")) {
      json = pref.getString("publisherModel");
      logger.log("SharedPrefHelper", "reloadCurrentUser(): Current publisher user: $json");
      sl.registerLazySingleton<Publisher>(() => PublisherModel.fromJson(jsonDecode(json!)));
    }

    logger.log("SharedPrefHelper", "reloadCurrentUser(): Current user: $json");

  }*/

  static decideInitialRoute() async {
    logger.log("SharedPrefHelper", "decideInitialRoute()");
    SharedPreferencesWithCache pref = await SharedPreferencesWithCache.create(cacheOptions:
    SharedPreferencesWithCacheOptions(
      allowList: <String>{"anonymousModel","userModel","publisherModel"},
    ));

    if(pref.containsKey("anonymousModel") || pref.containsKey("userModel")) {
      return "/homePage";
    } else if(pref.containsKey("publisherModel")) {
      return "/publisherHomePage";
    } else {
      return "/onboardingPage";
    }
  }


}
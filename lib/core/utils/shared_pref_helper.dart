
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

  static initUserIfExists() async {
    logger.log("SharedPrefHelper", "initUserIfExists()");
    SharedPreferencesWithCache pref = await SharedPreferencesWithCache.create(cacheOptions:
    SharedPreferencesWithCacheOptions(
      allowList: <String>{"anonymousModel","userModel","publisherModel"},
    ));

    String? json;
    if(pref.containsKey("anonymousModel")) {
      json = pref.getString("anonymousModel");
      logger.log("SharedPrefHelper", "initUserIfExists(): Current anonymous user: $json");
      sl.registerLazySingleton<Anonymous>(() => AnonymousModel.fromJson(jsonDecode(json!)));

    } else if(pref.containsKey("userModel")) {
      json = pref.getString("userModel");
      logger.log("SharedPrefHelper", "initUserIfExists(): Current user user: $json");
      sl.registerLazySingleton<User>(() => UserModel.fromJson(jsonDecode(json!)));

    } else if(pref.containsKey("publisherModel")) {
      json = pref.getString("publisherModel");
      logger.log("SharedPrefHelper", "initUserIfExists(): Current publisher user: $json");
      sl.registerLazySingleton<Publisher>(() => PublisherModel.fromJson(jsonDecode(json!)));
    }

    logger.log("SharedPrefHelper", "initUserIfExists(): Current user: $json");

  }

/*  static getCurrentUser() async {
    logger.log("SharedPrefHelper", "initUserIfExists()");
    SharedPreferencesWithCache pref = await SharedPreferencesWithCache.create(cacheOptions:
    SharedPreferencesWithCacheOptions(
      allowList: <String>{"anonymousModel","userModel","publisherModel"},
    ));

    String? json;
    if(pref.containsKey("anonymousModel")) {
      json = pref.getString("anonymousModel");
      logger.log("SharedPrefHelper", "initUserIfExists(): Current anonymous user: $json");
      sl.registerLazySingleton<Anonymous>(() => AnonymousModel.fromJson(jsonDecode(json!)));

    } else if(pref.containsKey("userModel")) {
      json = pref.getString("userModel");
      logger.log("SharedPrefHelper", "initUserIfExists(): Current user user: $json");
      sl.registerLazySingleton<User>(() => UserModel.fromJson(jsonDecode(json!)));

    } else if(pref.containsKey("publisherModel")) {
      json = pref.getString("publisherModel");
      logger.log("SharedPrefHelper", "initUserIfExists(): Current publisher user: $json");
      sl.registerLazySingleton<Publisher>(() => PublisherModel.fromJson(jsonDecode(json!)));
    }

    logger.log("SharedPrefHelper", "initUserIfExists(): Current user: $json");

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
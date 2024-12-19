
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
    if(pref.containsKey(key)) {
      pref.remove(key);
    }
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
      if(!sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
        json = pref.getString("anonymousModel");
        logger.log("SharedPrefHelper", "reloadCurrentUser(): Current anonymous user: $json");
        sl.registerSingleton<Anonymous>(AnonymousModel.fromJson(jsonDecode(json!))
      , instanceName: "currentUser");
        // registerLazySingleton<Anonymous>(() => AnonymousModel.fromJson(jsonDecode(json!))
      // , instanceName: "currentUser");
      }
      // sl.registerSingleton<PersonRole>(PersonRole.anonymous, instanceName: "currentUser");

    } else if(pref.containsKey("userModel")) {
      if(!sl.isRegistered<User>(instanceName: "currentUser")) {
        json = pref.getString("userModel");
        logger.log("SharedPrefHelper", "reloadCurrentUser(): Current user user: $json");
        sl.registerSingleton<User>(UserModel.fromJson(jsonDecode(json!)),
      instanceName: "currentUser");
        // sl.registerLazySingleton<User>(() => UserModel.fromJson(jsonDecode(json!)),
      // instanceName: "currentUser");
      }
      // sl.registerSingleton<PersonRole>(PersonRole.user, instanceName: "currentUser");

    } else if(pref.containsKey("publisherModel")) {
      if(!sl.isRegistered<Publisher>(instanceName: "currentUser")) {
        json = pref.getString("publisherModel");
        logger.log("SharedPrefHelper", "reloadCurrentUser(): Current publisher user: $json");
        sl.registerSingleton<Publisher>(PublisherModel.fromJson(jsonDecode(json!)),
      instanceName: "currentUser");
        // sl.registerLazySingleton<Publisher>(() => PublisherModel.fromJson(jsonDecode(json!)),
      // instanceName: "currentUser");
      }
      // sl.registerSingleton<PersonRole>(PersonRole.publisher, instanceName: "currentUser");
    }


    logger.log("SharedPrefHelper", "reloadCurrentUser(): Current user: ${json ?? "Already exists!"}");

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

  static Future<DateTime> getLastPeriodicPublishedDate() async {
    logger.log("SharedPrefHelper", "getLastPeriodicPublishedDate()");
    SharedPreferencesWithCache pref = await SharedPreferencesWithCache.create(cacheOptions:
    SharedPreferencesWithCacheOptions(
      allowList: <String>{"lastPeriodicPublishedDate"},
    ));
    if(pref.containsKey("lastPeriodicPublishedDate")) {
      return DateTime.parse(pref.getString("lastPeriodicPublishedDate")!);
    } else {
      pref.setString("lastPeriodicPublishedDate", DateTime.now().toString());
      return DateTime.now();
    }
  }

  static void setLastPeriodicPublishedDate(String date) async {
    logger.log("SharedPrefHelper", "getLastPeriodicPublishedDate()");
    SharedPreferencesWithCache pref = await SharedPreferencesWithCache.create(cacheOptions:
    SharedPreferencesWithCacheOptions(
      allowList: <String>{"lastPeriodicPublishedDate"},
    ));

      pref.setString("lastPeriodicPublishedDate", date);

  }


}
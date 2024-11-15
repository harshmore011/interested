import '../../domain/entities/auth.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends User {

  // @override
  // final List<PersonRole> personRoles = [];

  UserModel({
    required super.name,
    required super.email,
    required super.isEmailVerified,
    required super.creationTime,
    required super.lastSignInTime,
    required super.authProvider,
    required super.refreshToken,
    required super.uid,
    // this.personRole,
  });

  UserModel fromEntity(User user) {
    UserModel userModel = UserModel(
      name: user.name,
      email: user.email,
      isEmailVerified: user.isEmailVerified,
      creationTime: user.creationTime,
      lastSignInTime: user.lastSignInTime,
      authProvider: user.authProvider,
      refreshToken: user.refreshToken,
      uid: user.uid,
      // personRole: personRole
    );
    userModel.setPersonRoles(user.getPersonRoles());
    return userModel;
  }

/*  UserModel copyWith({
    String? name,
    String? email,
    bool? isEmailVerified,
    DateTime? creationTime,
    DateTime? lastSignInTime,
    AuthenticationProvider? authProvider,
    String? refreshToken,
    String? uid,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      creationTime: creationTime ?? this.creationTime,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
      authProvider: authProvider ?? this.authProvider,
      refreshToken: refreshToken ?? this.refreshToken,
      uid: uid ?? this.uid,
    );
  }*/

  factory UserModel.fromJson(Map<String, dynamic> json) {
    UserModel userModel = UserModel(
      name: json['name'],
      email: json['email'],
      isEmailVerified: json['isEmailVerified'],
      creationTime: DateTime.parse(json['creationTime'].toDate().toString()),
      lastSignInTime:
          DateTime.parse(json['lastSignInTime'].toDate().toString()),
      authProvider: AuthenticationProvider.values.byName(json['authProvider']),
      refreshToken: json['refreshToken'],
      uid: json['uid'],
    );

    if (json['personRoles'] != null) {
      userModel.personRoles.addAll(json['personRoles']
        .map<PersonRole>((role) => PersonRole.values.byName(role))
        .toList() as List<PersonRole>);
    }

    return userModel;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "isEmailVerified": isEmailVerified,
      "creationTime": creationTime,
      "lastSignInTime": lastSignInTime,
      "authProvider": authProvider.name,
      "refreshToken": refreshToken,
      "uid": uid,
      "personRoles": personRoles.map<String>((role) => role.name).toList(),
    };
  }

  toEntity() {
    User user = User(
      name: name,
      email: email,
      isEmailVerified: isEmailVerified,
      creationTime: creationTime,
      lastSignInTime: lastSignInTime,
      authProvider: authProvider,
      refreshToken: refreshToken,
      uid: uid,
    );
    user.setPersonRoles(personRoles);
    return user;
  }
}

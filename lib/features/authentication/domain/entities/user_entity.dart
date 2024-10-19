import 'package:equatable/equatable.dart';

class User extends Equatable {

  final String name;
  final String email;
  final bool isEmailVerified;
  // final List<String> followedPublishers;
  // final List<String> favoritePublishers;
  // final String businessName;

  const User({required this.name, required this.email, required this.isEmailVerified});


  @override
  List<Object?> get props => [name,email,isEmailVerified];

}


import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Publisher extends Equatable {

  final String name;
  final String email;
  final bool isEmailVerified;
  final String about;
  final int followersCount;
  // final List<String> followers;

  const Publisher( {required this.name, required this.email,
    required this.isEmailVerified, required this.about,required this.followersCount});


  @override
  List<Object?> get props => [name,email,isEmailVerified,about,followersCount];

}
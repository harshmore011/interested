import 'package:equatable/equatable.dart';

class Anonymous extends Equatable {

  final String uid;
  final DateTime creationTime;
  final DateTime lastSignInTime;
  final String refreshToken;

  const Anonymous({
    required this.uid,
    required this.creationTime,
    required this.lastSignInTime,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [
        uid,
        creationTime,
        lastSignInTime,
        refreshToken,
      ];
}

part of 'home_bloc.dart';



abstract class HomeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUserData extends HomeEvent {
  final String firebaseId;

  FetchUserData(this.firebaseId);

  @override
  List<Object?> get props => [firebaseId];
}

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_data_entity.dart';
import '../../domain/usecase/get_user_data_usecase.dart';
import '../../domain/usecase/increase_user_coins_usecase.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetUserDataUseCase getUserDataUseCase;
  final IncreaseUserCoinsUseCase increaseUserCoinsUseCase;

  HomeBloc({
    required this.getUserDataUseCase,
    required this.increaseUserCoinsUseCase,
  }) : super(HomeInitial()) {
    on<FetchUserData>((event, emit) async {
      print('FetchUserData event called...');
      emit(HomeLoading());
      final result = await getUserDataUseCase(event.firebaseId);
      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (userData) => emit(HomeLoaded(userData)),
      );
    });

    on<IncreaseUserCoins>((event, emit) async {
      final currentState = state;
      emit(HomeLoading());
      final result = await increaseUserCoinsUseCase(event.userId, event.coins);
      result.fold(
        (failure) {
          debugPrint("Coins increased failed");
          emit(HomeError(failure.message));
        },
        (_) {
          debugPrint("Coins increased successfully");
          if (currentState is HomeLoaded) {
            final updatedUserData = currentState.userData.copyWith(
              coinWon: currentState.userData.coinWon + event.coins,
            );
            emit(HomeLoaded(updatedUserData));
          } else {
            // Fallback if state wasn't Loaded for some reason
            emit(HomeInitial());
          }
        },
      );
    });
  }
}

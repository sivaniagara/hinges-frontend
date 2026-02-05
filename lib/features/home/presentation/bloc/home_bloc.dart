import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/user_data_entity.dart';
import '../../domain/usecase/get_user_data_usecase.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetUserDataUseCase getUserDataUseCase;

  HomeBloc({required this.getUserDataUseCase}) : super(HomeInitial()) {
    on<FetchUserData>((event, emit) async {
      print('FetchUserData event called...');
      emit(HomeLoading());
      final result = await getUserDataUseCase(event.firebaseId);
      result.fold(
        (failure) => emit(HomeError(failure.message)),
        (userData) => emit(HomeLoaded(userData)),
      );
    });
  }
}

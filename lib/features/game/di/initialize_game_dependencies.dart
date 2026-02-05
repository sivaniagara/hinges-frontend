import 'package:hinges_frontend/features/game/data/data_source/game_remote_data_source.dart';
import 'package:hinges_frontend/features/game/data/repository/game_repository_impl.dart';
import 'package:hinges_frontend/features/game/domain/repository/game_repository.dart';
import 'package:hinges_frontend/features/game/domain/usecase/get_game_data_usecase.dart';
import 'package:hinges_frontend/features/game/presentation/bloc/game_bloc.dart';

import '../../../core/di/dependency_injection.dart';

void initializeGameDependencies() {
  // BLoC
  sl.registerFactory(() => GameBloc(
      getGameDataUseCase: sl(),
      webSocketService: sl()
  ));

  // UseCases
  sl.registerLazySingleton(() => GetGameDataUseCase(repository: sl()));

  // Repositories
  sl.registerLazySingleton<GameRepository>(() => GameRepositoryImpl(remoteDataSource: sl()));

  // DataSources
  sl.registerLazySingleton<GameRemoteDataSource>(() => GameRemoteDataSourceImpl(httpService: sl()));
}

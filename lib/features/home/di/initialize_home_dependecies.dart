import 'package:hinges_frontend/features/home/data/data_source/home_remote_data_source.dart';
import 'package:hinges_frontend/features/home/data/repository/home_repository_impl.dart';
import 'package:hinges_frontend/features/home/domain/repository/home_repository.dart';
import 'package:hinges_frontend/features/home/domain/usecase/get_user_data_usecase.dart';
import 'package:hinges_frontend/features/home/presentation/bloc/home_bloc.dart';

import '../../../core/di/dependency_injection.dart';

void initializeHomeDependencies(){
  // BLoC - Changed to Singleton to ensure consistency across the app
  sl.registerLazySingleton(() => HomeBloc(getUserDataUseCase: sl()));

  // UseCases
  sl.registerLazySingleton(() => GetUserDataUseCase(repository: sl()));

  // Repositories
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(remoteDataSource: sl()));

  // DataSources
  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(httpService: sl()));
}

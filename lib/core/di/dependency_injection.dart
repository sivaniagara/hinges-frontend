

import 'package:get_it/get_it.dart';

import '../../features/login/data/data_source/fire_store_auth_data_source.dart';
import '../../features/login/data/data_source/firebase_auth_data_source.dart';
import '../../features/login/data/repository/auth_repository_imp.dart';
import '../../features/login/domain/repository/auth_repository.dart';
import '../../features/login/domain/usecase/sign_up_usecase.dart';
import '../../features/login/presentation/bloc/user_auth_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => UserAuthBloc(signUpUseCase: sl()));
  sl.registerLazySingleton(() => SignUpUseCase(authRepository: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImp(firebaseAuthDataSource: sl(), fireStoreAuthDataSource: sl()));
  sl.registerLazySingleton(() => FirebaseAuthDataSource());
  sl.registerLazySingleton(() => FireStoreAuthDataSource());
}

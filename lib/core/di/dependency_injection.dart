import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';
import '../../features/game/di/initialize_game_dependencies.dart';
import '../../features/home/di/initialize_home_dependecies.dart';
import '../../features/login/data/data_source/firebase_auth_data_source.dart';
import '../../features/login/data/data_source/remote_auth_data_source.dart';
import '../../features/login/data/repository/auth_repository_imp.dart';
import '../../features/login/domain/repository/auth_repository.dart';
import '../../features/login/domain/usecase/sign_up_usecase.dart';
import '../../features/login/presentation/bloc/user_auth_bloc.dart';
import '../network/http_service.dart';
import '../network/http_service_impl.dart';
import '../network/websocket_service.dart';
import '../network/websocket_service_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {

  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton<HttpService>(
        () => HttpServiceImpl(client: sl()),
  );
  sl.registerLazySingleton<WebSocketService>(
        () => WebSocketServiceImpl(),
  );


  sl.registerFactory(() => UserAuthBloc(signUpUseCase: sl()));
  sl.registerLazySingleton(() => SignUpUseCase(authRepository: sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImp(
      firebaseAuthDataSource: sl(),
      remoteAuthDataSource: sl()
  ));
  sl.registerLazySingleton(() => FirebaseAuthDataSource());
  sl.registerLazySingleton<RemoteAuthDataSource>(() => RemoteAuthDataSourceImpl(httpService: sl()));

  initializeHomeDependencies();

  initializeGameDependencies();
}
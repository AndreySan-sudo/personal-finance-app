import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// auth imports...
import '../../features/auth/data/datasources/auth_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login.dart';
import '../../features/auth/domain/usecases/register.dart';
import '../../features/auth/domain/usecases/logout.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

// transactions imports
import '../../features/transactions/data/datasources/transaction_datasource.dart';
import '../../features/transactions/data/repositories/transaction_repository_impl.dart';
import '../../features/transactions/domain/repositories/transaction_repository.dart';
import '../../features/transactions/domain/usecases/get_transactions.dart';
import '../../features/transactions/domain/usecases/add_transaction.dart';
import '../../features/transactions/domain/usecases/delete_transaction.dart';
import '../../features/transactions/domain/usecases/update_transaction.dart';
import '../../features/transactions/presentation/bloc/transaction_bloc.dart';
// import '../../features/transactions/presentation/bloc/statistics/statistics_bloc.dart';

// stats imports
import '../../features/stats/data/repositories/stats_repository_impl.dart';
import '../../features/stats/domain/repositories/stats_repository.dart';
import '../../features/stats/domain/usecases/get_stats.dart';
import '../../features/stats/presentation/bloc/stats_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Firebase
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);

  // Auth
  sl.registerLazySingleton(() => AuthDatasource(sl<FirebaseAuth>()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Auth use cases
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));

  // Auth Bloc
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl<LoginUseCase>(),
        registerUseCase: sl<RegisterUseCase>(),
        logoutUseCase: sl<LogoutUseCase>(),
      ));

  // Transactions datasource & repo
  sl.registerLazySingleton(
      () => TransactionDatasource(sl<FirebaseFirestore>()));
  sl.registerLazySingleton<TransactionRepository>(
      () => TransactionRepositoryImpl(sl<TransactionDatasource>()));

  // Usecases
  sl.registerLazySingleton(() => GetTransactions(sl<TransactionRepository>()));
  sl.registerLazySingleton(() => AddTransaction(sl<TransactionRepository>()));
  sl.registerLazySingleton(
      () => DeleteTransaction(sl<TransactionRepository>()));
  sl.registerLazySingleton(
      () => UpdateTransaction(sl<TransactionRepository>()));

  // Bloc (factory to avoid "Cannot add new events after calling close" error)
  sl.registerFactory(() => TransactionBloc(
        getTransactions: sl<GetTransactions>(),
        addTransaction: sl<AddTransaction>(),
        deleteTransaction: sl<DeleteTransaction>(),
        updateTransaction: sl<UpdateTransaction>(),
      ));

  // Stats
  sl.registerLazySingleton<StatsRepository>(() => StatsRepositoryImpl());
  sl.registerLazySingleton(() => GetStats(sl<StatsRepository>()));
  sl.registerFactory(() => StatsBloc(
        getStats: sl<GetStats>(),
        getTransactions: sl<GetTransactions>(),
      ));
}

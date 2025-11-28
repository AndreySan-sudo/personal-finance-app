import 'package:finances_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/transactions/presentation/pages/home_page.dart';
import '../../features/transactions/presentation/pages/add_transaction_page.dart';
import '../../features/transactions/presentation/pages/statistics_page.dart';
import '../../features/stats/presentation/pages/stats_page.dart';

class AppRouter {
  GoRouter get router => GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (_, __) => const LoginPage()),
          GoRoute(path: '/home', builder: (_, __) => const HomePage()),
          GoRoute(
            path: '/add',
            builder: (context, state) {
              final transaction = state.extra as TransactionEntity?;
              return AddTransactionPage(
                userId: FirebaseAuth.instance.currentUser!.uid,
                transaction: transaction,
              );
            },
          ),
          GoRoute(
            path: '/statistics',
            builder: (_, __) => const StatisticsPage(),
          ),
          GoRoute(
            path: '/stats',
            builder: (_, __) => const StatsPage(),
          ),
        ],
      );
}

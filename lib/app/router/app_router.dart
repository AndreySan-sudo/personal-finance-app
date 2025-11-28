import 'package:flutter/material.dart';
import 'package:finances_app/features/transactions/domain/entities/transaction_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/transactions/presentation/pages/home_page.dart';
import '../../features/transactions/presentation/pages/add_transaction_page.dart';
// import '../../features/transactions/presentation/pages/statistics_page.dart';
import '../../features/stats/presentation/pages/stats_page.dart';
import '../../features/transactions/presentation/pages/delete_transaction_dialog.dart';

class AppRouter {
  GoRouter get router => GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (_, __) => const LoginPage()),
          GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
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
          // GoRoute(
          //   path: '/statistics',
          //   builder: (_, __) => const StatisticsPage(),
          // ),
          GoRoute(
            path: '/stats',
            builder: (_, __) => const StatsPage(),
          ),
          GoRoute(
            path: '/delete_transaction',
            pageBuilder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              final transaction = extra['transaction'] as TransactionEntity;
              final userId = extra['userId'] as String;

              return CustomTransitionPage(
                key: state.pageKey,
                child: DeleteTransactionDialog(
                  transaction: transaction,
                  userId: userId,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                opaque: false,
                barrierDismissible: true,
                barrierColor: Colors.black54,
              );
            },
          ),
        ],
      );
}

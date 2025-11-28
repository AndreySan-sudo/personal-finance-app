import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../domain/repositories/auth_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final repo = GetIt.instance<AuthRepository>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                controller: passCtrl,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  final user = await repo.login(
                      emailCtrl.text.trim(), passCtrl.text.trim());
                  if (user != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Login ok')));
                    context.go('/home');
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final user = await repo.register(
                      emailCtrl.text.trim(), passCtrl.text.trim());
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Registered')));
                  context.go('/home');
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Error: $e')));
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}

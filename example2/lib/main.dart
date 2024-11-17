import 'package:bloc_provider_package/bloc_provider_package.dart';
import 'package:example2/login_bloc.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(),
        child: LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Email input
              TextField(
                onChanged: context.read<LoginBloc>().onChangeEmail,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 20),
              // Password input
              TextField(
                obscureText: true,
                onChanged: context.read<LoginBloc>().onChangePassword,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              const SizedBox(height: 20),
              // Login button

              const SizedBox(height: 20),
              // Listen to the login state stream
              StreamBuilder<bool>(
                stream: context.read<LoginBloc>().loginStateStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!) {
                      return const CircularProgressIndicator();
                    }
                  }
                  return ElevatedButton(
                    onPressed: () async {
                      final loginBloc = context.read<LoginBloc>();
                      String result = await loginBloc.login();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(result),
                      ));
                    },
                    child: const Text('Login'),
                  ); // Default empty state
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

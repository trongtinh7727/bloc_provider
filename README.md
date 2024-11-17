<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->
# BlocProviderPackage

 package for managing state in Flutter using BlocProvider and MultiBlocProvider. It provides an easy-to-use solution for managing business logic using the BLoC pattern while leveraging InheritedWidget and nested providers to efficiently manage and distribute state across widgets.

## Features

- State Management: Manage and share state using BlocProvider and MultiBlocProvider.

- Stream-based Updates: Utilize streams to trigger UI updates when the data changes.

- Flexible BLoC Architecture: Supports custom BaseBloC classes with init and dispose methods for managing resources and lifecycle.

- Efficient UI Updates: Automatically rerenders the UI layer when data changes via stream listening.

- Nested Bloc Providers: Use MultiBlocProvider for nesting multiple BLoC providers in a widget tree.

## Getting started

- Installation: Add the bloc_provider_package to your pubspec.yaml file:

```yaml
dependencies:
  bloc_provider_package: ^latest_version
```

- Import the package into your Dart files:
```dart
import 'package:bloc_provider_package/bloc_provider_package.dart';
```

## Usage
1. Define your BLoC class that extends `BaseBloC`. Example for a `LoginBloc`

```dart
class LoginBloc extends BaseBloC {
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  final _loginStreamController = StreamController<bool>.broadcast();

  Stream<bool> get loginStateStream => _loginStreamController.stream;

  String get email => _email;
  String get password => _password;

  void onChangeEmail(String value) {
    _email = value;
  }

  void onChangePassword(String value) {
    _password = value;
  }

  Future<String> login() async {
    if (_email.isEmpty || _password.isEmpty) {
      return 'Please fill in both fields';
    }
    _isLoading = true;
    _notifyLoginState();
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    _notifyLoginState();

    return _email == 'test@example.com' && _password == 'password'
        ? 'Login successful'
        : 'Invalid email or password';
  }

  void _notifyLoginState() {
    _loginStreamController.add(_isLoading);
  }

  @override
  void dispose() {
    _loginStreamController.close();
  }

  @override
  void init() {}
}
```

2. Wrap your widget with `BlocProvider` to provide the `LoginBloc` to your app:

```dart
void main() {
  runApp(
    MaterialApp(
      home: BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(),
        child: LoginScreen(),
      ),
    ),
  );
}
```


3. Access the BLoC in the UI using `context.read<LoginBloc>()`.

```dart
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginBloc = context.read<LoginBloc>();

    return Scaffold(
      body: Column(
        children: [
          TextField(
            onChanged: (email) => loginBloc.onChangeEmail(email),
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            onChanged: (password) => loginBloc.onChangePassword(password),
            decoration: InputDecoration(labelText: 'Password'),
          ),
          ElevatedButton(
            onPressed: () async {
              final result = await loginBloc.login();
              print(result);
            },
            child: Text('Login'),
          ),
          StreamBuilder<bool>(
            stream: loginBloc.loginStateStream,
            builder: (context, snapshot) {
              if (snapshot.data == true) {
                return CircularProgressIndicator();
              } else {
                return SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
```
4. `MultiBlocProvider`: If you need to provide multiple BLoCs, use `MultiBlocProvider`:

```dart
void main() {
  runApp(
    MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(),
          ),
          // Add more providers as needed
        ],
        child: LoginScreen(),
      ),
    ),
  );
}
```

## Additional information

- Documentation: For more details on how to use the package, refer to the documentation.
- Contributions: Feel free to open issues or submit pull requests to improve the package.
- Support: For any questions or help, please contact us via GitHub discussions or issues.

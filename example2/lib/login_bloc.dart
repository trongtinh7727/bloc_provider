import 'dart:async';

import 'package:bloc_provider_package/bloc_provider_package.dart';


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
    // Check if email and password match
    if (_email.isEmpty || _password.isEmpty) {
      return 'Please fill in both fields';
    }

    _isLoading = true;
    _notifyLoginState();
    await Future.delayed(
        const Duration(seconds: 2)); // Simulate delay (between 2-5 seconds)

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
  void dispose() {}

  @override
  void init() {}
}

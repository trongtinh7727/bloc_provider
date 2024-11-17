import 'package:bloc_provider_package/bloc_provider_package.dart';
import 'package:rxdart/rxdart.dart';

class CounterBloc extends BaseBloC {
  int _counter = 0;
  final _counterSubject = BehaviorSubject<int>.seeded(0);

  // Public getter to access the counter value as a stream
  Stream<int> get counterStream => _counterSubject.stream;

  // Public getter to access the current counter value directly
  int get currentCounter => _counterSubject.value;

  // Public method to increment the counter and update the stream
  void incrementCounter() {
    _counter++;
    _counterSubject.add(_counter); // Emit the new counter value to the stream
  }

  @override
  void dispose() {
    _counterSubject.close();
  }

  @override
  void init() {
    
  }
}

import 'package:nested/nested.dart';

class MultiBlocProvider extends Nested {
  MultiBlocProvider({
    super.key,
    required List<SingleChildStatefulWidget> providers,
    super.child,
  }) : super(children: providers);
}

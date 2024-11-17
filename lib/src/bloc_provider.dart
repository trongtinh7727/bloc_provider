import 'package:flutter/widgets.dart';
import 'package:nested/nested.dart';
import 'base_bloc.dart';

typedef Create<T> = T Function(BuildContext context);

class BlocProvider<T extends BaseBloC> extends SingleChildStatefulWidget {
  final T? _value;
  final Create<T>? create;
  final Widget? child;

  const BlocProvider({
    super.key,
    this.child,
    T? value,
    required this.create,
  }) : _value = value;

  static T of<T extends BaseBloC>(BuildContext context) {
    final _BlocProviderInherited<T>? provider =
        context.dependOnInheritedWidgetOfExactType<_BlocProviderInherited<T>>();
    if (provider == null) {
      throw FlutterError(
          'BlocProvider.of() called with a context that does not contain a $T.');
    }
    return provider.bloc;
  }

  @override
  State<BlocProvider> createState() => _BlocProviderState<T>();
}

class _BlocProviderState<T extends BaseBloC>
    extends SingleChildState<BlocProvider<T>> {
  late final T bloc;

  @override
  void initState() {
    super.initState();

    if (widget._value != null) {
      bloc = widget._value!;
    } else if (widget.create != null) {
      bloc = widget.create!(context);
    } else {
      throw FlutterError(
          'BlocProvider must provide either a bloc or a create function');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _BlocProviderInherited<T>(
      bloc: bloc,
      child: widget.child ?? Container(),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    return _BlocProviderInherited<T>(
      bloc: bloc,
      child: child!,
    );
  }
}

class _BlocProviderInherited<T extends BaseBloC> extends InheritedWidget {
  final T bloc;

  const _BlocProviderInherited({
    super.key,
    required super.child,
    required this.bloc,
  });

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}

extension BlocContextRead on BuildContext {
  T read<T extends BaseBloC>() {
    final _BlocProviderInherited<T>? provider =
        dependOnInheritedWidgetOfExactType<_BlocProviderInherited<T>>();
    if (provider == null) {
      throw FlutterError(
          'BlocProvider.read() called with a context that does not contain a $T.');
    }
    return provider.bloc;
  }
}

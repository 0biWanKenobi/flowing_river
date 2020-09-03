import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:state_notifier/state_notifier.dart';

class ExampleStateNotifer extends StateNotifier<ExampleState> {
  ExampleStateNotifer(ExampleState state) : super(state);

  ExampleState backup;
  String get foo => state.foo;

  void setFoo() {
    backup = state;
    state = state.copyWith(foo: state.fie);
  }

  void setFie() {
    backup = state;
    state = state.copyWith(fie: state.foo);
  }

  void reset() {
    state = backup;
    backup = null;
  }
}

class ExampleState {
  final String foo, fie;

  ExampleState({this.foo = 'foo', this.fie = 'fie'});

  ExampleState copyWith({
    String foo,
    String fie,
  }) =>
      ExampleState(
        foo: foo ?? this.foo,
        fie: fie ?? this.fie,
      );
}

final exampleStateNotifier = StateNotifierProvider<ExampleStateNotifer>(
    (_) => ExampleStateNotifer(ExampleState()));

final exampleProvider =
    Provider<ExampleState>((ref) => ref.watch(exampleStateNotifier.state));

class StateNotifierWidget extends HookWidget {
  static const routeName = '/stateNotifier';

  @override
  Widget build(BuildContext context) {
    final text = useProvider(exampleProvider.select((value) => value.foo));

    return Scaffold(
      appBar: AppBar(
        title: Text('StateNotifier'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text),
              SizedBox(height: 20),
              RaisedButton(
                child: Text('Set Foo'),
                onPressed: () => context.read(exampleStateNotifier).setFoo(),
              ),
              SizedBox(height: 20),
              RaisedButton(
                child: Text('Set Fie'),
                onPressed: () => context.read(exampleStateNotifier).setFie(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

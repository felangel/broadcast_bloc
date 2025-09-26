# Broadcast Bloc

[![build][build_badge]][build_link]
[![coverage][coverage_badge]][build_link]
[![pub package][pub_badge]][pub_link]
[![style: bloc lint][bloc_lint_badge]][bloc_lint_link]
[![License: MIT][license_badge]][license_link]

An extension to the bloc state management library which adds support for broadcasting state changes to stream channels.

## Quick Start 🚀

```dart
// Extend `BroadcastCubit` instead of `Cubit`.
// The package also exports:
// * `BroadcastBloc`
// * `BroadcastMixin`
class CounterCubit extends BroadcastCubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
}

void main() {
  final controller = StreamController<String>(sync: true);
  final subscription = controller.stream.listen(print);
  final channel = StreamChannel(controller.stream, controller.sink);

  // Create an instance of the cubit.
  final cubit = CounterCubit()
    // Subscribe the channel.
    ..subscribe(channel)
    // Trigger a state change which will be broadcast to subscribed channels.
    ..increment()
    // Unsubscribe channel.
    ..unsubscribe(channel);

  subscription.cancel();
  cubit.close();
}
```

[bloc_lint_badge]: https://img.shields.io/badge/style-bloc_lint-FFBD59.svg
[bloc_lint_link]: https://pub.dev/packages/bloc_lint
[build_badge]: https://github.com/felangel/broadcast_bloc/actions/workflows/main.yaml/badge.svg
[build_link]: https://github.com/felangel/broadcast_bloc/actions/workflows/main.yaml
[coverage_badge]: https://raw.githubusercontent.com/felangel/broadcast_bloc/main/coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[pub_badge]: https://img.shields.io/pub/v/broadcast_bloc.svg
[pub_link]: https://pub.dartlang.org/packages/broadcast_bloc

# Broadcast Bloc

[![build][build_badge]][build_link]
[![coverage][coverage_badge]][build_link]
[![pub package][pub_badge]][pub_link]
[![style: bloc lint][bloc_lint_badge]][bloc_lint_link]
[![License: MIT][license_badge]][license_link]

An extension to the bloc state management library which adds support for broadcasting state changes to stream channels.

**Learn more at [bloclibrary.dev](https://bloclibrary.dev)!**

---

## Sponsors

Our top sponsors are shown below! [[Become a Sponsor](https://github.com/sponsors/felangel)]

<table style="background-color: white; border: 1px solid black">
    <tbody>
        <tr>
            <td align="center" style="border: 1px solid black">
                <a href="https://shorebird.dev"><img src="https://raw.githubusercontent.com/felangel/bloc/master/assets/sponsors/shorebird.png" width="225"/></a>
            </td>            
            <td align="center" style="border: 1px solid black">
                <a href="https://getstream.io/chat/flutter/tutorial/?utm_source=Github&utm_medium=Github_Repo_Content_Ad&utm_content=Developer&utm_campaign=Github_Jan2022_FlutterChat&utm_term=bloc"><img src="https://raw.githubusercontent.com/felangel/bloc/master/assets/sponsors/stream.png" width="225"/></a>
            </td>
            <td align="center" style="border: 1px solid black">
                <a href="https://rettelgame.com/"><img src="https://raw.githubusercontent.com/felangel/bloc/master/assets/sponsors/rettel.png" width="225"/></a>
            </td>
        </tr>
    </tbody>
</table>

---

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

[bloc_lint_badge]: https://img.shields.io/badge/style-bloc_lint-20FFE4.svg
[bloc_lint_link]: https://pub.dev/packages/bloc_lint
[build_badge]: https://github.com/felangel/broadcast_bloc/actions/workflows/main.yaml/badge.svg
[build_link]: https://github.com/felangel/broadcast_bloc/actions/workflows/main.yaml
[coverage_badge]: https://raw.githubusercontent.com/felangel/broadcast_bloc/main/coverage_badge.svg
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[pub_badge]: https://img.shields.io/pub/v/broadcast_bloc.svg
[pub_link]: https://pub.dartlang.org/packages/broadcast_bloc

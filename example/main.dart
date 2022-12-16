// ignore_for_file: avoid_print
import 'dart:async';

import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:stream_channel/stream_channel.dart';

class CounterCubit extends BroadcastCubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);

  /// Optionally override `toMessage` to customize the format
  /// of the state before it is broadcast to all subscribers.
  @override
  Object toMessage(int state) => 'count: $state';
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

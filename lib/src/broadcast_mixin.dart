import 'package:bloc/bloc.dart';
import 'package:stream_channel/stream_channel.dart';

/// A mixin on [BlocBase] which exposes APIs to [subscribe]/[unsubscribe]
/// stream channels and broadcast all state changes to subscribed channels.
mixin BroadcastMixin<State> on BlocBase<State> {
  final _channels = <StreamChannel<dynamic>>[];

  /// Convert the [state] to an object which will be broadcast to all
  /// subscribers. The object returned must either be a `String` or `List<int>`.
  Object toMessage(State state) => state is Object ? state : state.toString();

  @override
  void onChange(Change<State> change) {
    super.onChange(change);
    _broadcast(toMessage(change.nextState));
  }

  void _broadcast(dynamic message) {
    for (final channel in _channels) {
      if (message is! String && message is! List<int>) {
        channel.sink.add(message.toString());
      } else {
        channel.sink.add(message);
      }
    }
  }

  /// The provided [channel] will be notified of all state changes.
  void subscribe(StreamChannel<dynamic> channel) => _channels.add(channel);

  /// The provided [channel] will no longer be notified of state changes.
  void unsubscribe(StreamChannel<dynamic> channel) => _channels.remove(channel);
}

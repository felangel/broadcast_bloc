import 'dart:async';

import 'package:broadcast_bloc/broadcast_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';

class _TestBroadcastBloc<State> extends BroadcastBloc<void, State> {
  _TestBroadcastBloc(
    super.initialState, {
    Object Function(State state)? toMessage,
  }) : _toMessage = toMessage;

  final Object Function(State state)? _toMessage;

  @override
  Object toMessage(State state) {
    return _toMessage?.call(state) ?? super.toMessage(state);
  }
}

class _MockStreamChannel<T> extends Mock implements StreamChannel<T> {}

class _MockStreamSink<T> extends Mock implements StreamSink<T> {}

void main() {
  group('BroadcastBloc', () {
    test('broadcasts state changes to subscribers', () {
      final sink = _MockStreamSink<dynamic>();
      final channel = _MockStreamChannel<dynamic>();
      when(() => channel.sink).thenReturn(sink);

      _TestBroadcastBloc(0)
        ..subscribe(channel)
        ..emit(1)
        ..emit(2)
        ..emit(3);

      verifyInOrder([
        () => sink.add('1'),
        () => sink.add('2'),
        () => sink.add('3'),
      ]);
    });

    test('state changes are not broadcast once a subscriber unsubscribes', () {
      final sink = _MockStreamSink<dynamic>();
      final channel = _MockStreamChannel<dynamic>();
      when(() => channel.sink).thenReturn(sink);

      _TestBroadcastBloc(0)
        ..subscribe(channel)
        ..emit(1)
        ..unsubscribe(channel)
        ..emit(2)
        ..emit(3);

      verify(() => sink.add('1')).called(1);
      verifyNever(() => sink.add('2'));
      verifyNever(() => sink.add('3'));
    });

    test('state changes are broadcast to multiple subscribes', () {
      final sinkA = _MockStreamSink<dynamic>();
      final sinkB = _MockStreamSink<dynamic>();
      final channelA = _MockStreamChannel<dynamic>();
      final channelB = _MockStreamChannel<dynamic>();
      when(() => channelA.sink).thenReturn(sinkA);
      when(() => channelB.sink).thenReturn(sinkB);

      _TestBroadcastBloc(0)
        ..subscribe(channelA)
        ..emit(1)
        ..subscribe(channelB)
        ..emit(2)
        ..unsubscribe(channelA)
        ..emit(3)
        ..unsubscribe(channelB)
        ..emit(4);

      verifyInOrder([
        () => sinkA.add('1'),
        () => sinkA.add('2'),
      ]);

      verifyInOrder([
        () => sinkB.add('2'),
        () => sinkB.add('3'),
      ]);

      verifyNever(() => sinkA.add('3'));
      verifyNever(() => sinkA.add('4'));

      verifyNever(() => sinkB.add('1'));
      verifyNever(() => sinkB.add('4'));
    });

    test('applies toMessage transformation when provideed', () {
      final sink = _MockStreamSink<dynamic>();
      final channel = _MockStreamChannel<dynamic>();
      when(() => channel.sink).thenReturn(sink);

      _TestBroadcastBloc(0, toMessage: (state) => '${state + 1}')
        ..subscribe(channel)
        ..emit(1)
        ..emit(2)
        ..emit(3);

      verifyInOrder([
        () => sink.add('2'),
        () => sink.add('3'),
        () => sink.add('4'),
      ]);
    });
  });
}

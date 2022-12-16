import 'package:broadcast_bloc/broadcast_bloc.dart';

/// {@template broadcast_bloc}
/// A specialized [Bloc] which supports broadcasting state changes
/// to all subscribed stream channels.
/// {@endtemplate}
class BroadcastBloc<Event, State> extends Bloc<Event, State>
    with BroadcastMixin {
  /// {@macro broadcast_bloc}
  BroadcastBloc(super.initialState);
}

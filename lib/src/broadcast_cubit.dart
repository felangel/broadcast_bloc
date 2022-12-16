import 'package:broadcast_bloc/broadcast_bloc.dart';

/// {@template broadcast_cubit}
/// A specialized [Cubit] which supports broadcasting state changes
/// to all subscribed stream channels.
/// {@endtemplate}
class BroadcastCubit<State> extends Cubit<State> with BroadcastMixin {
  /// {@macro broadcast_cubit}
  BroadcastCubit(super.initialState);
}

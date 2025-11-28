import 'package:equatable/equatable.dart';
import '../../domain/entities/stats_entity.dart';

abstract class StatsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StatsInitial extends StatsState {}

class StatsLoading extends StatsState {}

class StatsLoaded extends StatsState {
  final StatsEntity stats;

  StatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class StatsError extends StatsState {
  final String message;

  StatsError(this.message);

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';

abstract class StatsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadStatsEvent extends StatsEvent {
  final String userId;
  LoadStatsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ChangeDateFilterEvent extends StatsEvent {
  final String filter;
  ChangeDateFilterEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class ChangeTypeFilterEvent extends StatsEvent {
  final String filter;
  ChangeTypeFilterEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

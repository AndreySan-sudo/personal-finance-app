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
  final DateTime? customDate;
  ChangeDateFilterEvent(this.filter, {this.customDate});

  @override
  List<Object?> get props => [filter, customDate];
}

class ChangeTypeFilterEvent extends StatsEvent {
  final String filter;
  ChangeTypeFilterEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

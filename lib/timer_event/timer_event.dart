// timer_event.dart
import 'package:equatable/equatable.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class StartTimer extends TimerEvent {}

class PauseTimer extends TimerEvent {}

class ResetTimer extends TimerEvent {}

class Tick extends TimerEvent {}

class IncrementActiveDuration extends TimerEvent {}

class DecrementActiveDuration extends TimerEvent {}

class IncrementBreakDuration extends TimerEvent {}

class DecrementBreakDuration extends TimerEvent {}

class IncrementRounds extends TimerEvent {}

class DecrementRounds extends TimerEvent {}

class ToggleSound extends TimerEvent {
  final bool enableSound;

  const ToggleSound(this.enableSound);

  @override
  List<Object> get props => [enableSound];
}

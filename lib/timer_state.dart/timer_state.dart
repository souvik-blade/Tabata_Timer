// timer_state.dart
import 'package:equatable/equatable.dart';

class TimerState extends Equatable {
  final int activeSeconds;
  final int breakSeconds;
  final int initialActiveSeconds;
  final int initialBreakSeconds;
  final int rounds;
  final int currentRound;
  final bool isRunning;
  final bool isBreak;
  final bool enableSound;

  const TimerState({
    required this.activeSeconds,
    required this.breakSeconds,
    required this.initialActiveSeconds,
    required this.initialBreakSeconds,
    required this.rounds,
    required this.currentRound,
    required this.isRunning,
    required this.isBreak,
    required this.enableSound,
  });

  TimerState copyWith({
    int? activeSeconds,
    int? breakSeconds,
    int? initialActiveSeconds,
    int? initialBreakSeconds,
    int? rounds,
    int? currentRound,
    bool? isRunning,
    bool? isBreak,
    bool? enableSound,
  }) {
    return TimerState(
      activeSeconds: activeSeconds ?? this.activeSeconds,
      breakSeconds: breakSeconds ?? this.breakSeconds,
      initialActiveSeconds: initialActiveSeconds ?? this.initialActiveSeconds,
      initialBreakSeconds: initialBreakSeconds ?? this.initialBreakSeconds,
      rounds: rounds ?? this.rounds,
      currentRound: currentRound ?? this.currentRound,
      isRunning: isRunning ?? this.isRunning,
      isBreak: isBreak ?? this.isBreak,
      enableSound: enableSound ?? this.enableSound,
    );
  }

  @override
  List<Object> get props => [
        activeSeconds,
        breakSeconds,
        initialActiveSeconds,
        initialBreakSeconds,
        rounds,
        currentRound,
        isRunning,
        isBreak,
        enableSound,
      ];
}

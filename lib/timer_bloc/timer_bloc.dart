// timer_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:tabata/timer_event/timer_event.dart';
import 'package:tabata/timer_state.dart/timer_state.dart';
import 'package:just_audio/just_audio.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  late Timer? _timer;
  late AudioPlayer _audioPlayer;

  TimerBloc()
      : super(const TimerState(
          activeSeconds: 20,
          breakSeconds: 10,
          initialActiveSeconds: 20,
          initialBreakSeconds: 10,
          rounds: 8,
          currentRound: 1,
          isRunning: false,
          isBreak: true,
          enableSound: true,
        )) {
    _audioPlayer = AudioPlayer();
    on<StartTimer>(_onStartTimer);
    on<PauseTimer>(_onPauseTimer);
    on<ResetTimer>(_onResetTimer);
    on<Tick>(_onTick);
    on<IncrementActiveDuration>(_onIncrementActiveDuration);
    on<DecrementActiveDuration>(_onDecrementActiveDuration);
    on<IncrementBreakDuration>(_onIncrementBreakDuration);
    on<DecrementBreakDuration>(_onDecrementBreakDuration);
    on<IncrementRounds>(_onIncrementRounds);
    on<DecrementRounds>(_onDecrementRounds);
    on<ToggleSound>(_onToggleSound);
  }

  void _onStartTimer(StartTimer event, Emitter<TimerState> emit) {
    emit(state.copyWith(isRunning: true));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      add(Tick());
    });
  }

  void _onPauseTimer(PauseTimer event, Emitter<TimerState> emit) {
    _timer?.cancel();
    emit(state.copyWith(isRunning: false));
  }

  void _onResetTimer(ResetTimer event, Emitter<TimerState> emit) {
    _timer?.cancel();
    emit(state.copyWith(
      activeSeconds: state.initialActiveSeconds,
      breakSeconds: state.initialBreakSeconds,
      currentRound: 1,
      isBreak: true,
      isRunning: false,
    ));
  }

  void _onTick(Tick event, Emitter<TimerState> emit) {
    if (state.isBreak) {
      if (state.breakSeconds > 1) {
        _playBeepSound(state.breakSeconds);
        emit(state.copyWith(breakSeconds: state.breakSeconds - 1));
      } else {
        emit(state.copyWith(
          isBreak: false,
          activeSeconds: state.initialActiveSeconds,
        ));
      }
    } else {
      if (state.activeSeconds > 1) {
        _playBeepSound(state.activeSeconds);
        emit(state.copyWith(activeSeconds: state.activeSeconds - 1));
      } else {
        emit(state.copyWith(
          isBreak: true,
          breakSeconds: state.initialBreakSeconds,
          currentRound: state.currentRound + 1,
        ));
        if (state.currentRound > state.rounds) {
          add(PauseTimer());
          add(ResetTimer());
        }
      }
    }
  }

  Future<void> _playBeepSound(int seconds) async {
    if (state.enableSound && seconds <= 4 && seconds >= 1) {
      await _audioPlayer.setAsset('assets/beep.mp3');
      await _audioPlayer.play();
    }
  }

  void _onIncrementActiveDuration(
      IncrementActiveDuration event, Emitter<TimerState> emit) {
    if (!state.isRunning) {
      emit(state.copyWith(
        initialActiveSeconds: state.initialActiveSeconds + 1,
        activeSeconds: state.isBreak
            ? state.activeSeconds
            : state.initialActiveSeconds + 1,
      ));
    }
  }

  void _onDecrementActiveDuration(
      DecrementActiveDuration event, Emitter<TimerState> emit) {
    if (!state.isRunning && state.initialActiveSeconds > 1) {
      emit(state.copyWith(
        initialActiveSeconds: state.initialActiveSeconds - 1,
        activeSeconds: state.isBreak
            ? state.activeSeconds
            : state.initialActiveSeconds - 1,
      ));
    }
  }

  void _onIncrementBreakDuration(
      IncrementBreakDuration event, Emitter<TimerState> emit) {
    if (!state.isRunning) {
      emit(state.copyWith(
        initialBreakSeconds: state.initialBreakSeconds + 1,
        breakSeconds:
            state.isBreak ? state.initialBreakSeconds + 1 : state.breakSeconds,
      ));
    }
  }

  void _onDecrementBreakDuration(
      DecrementBreakDuration event, Emitter<TimerState> emit) {
    if (!state.isRunning && state.initialBreakSeconds > 1) {
      emit(state.copyWith(
        initialBreakSeconds: state.initialBreakSeconds - 1,
        breakSeconds:
            state.isBreak ? state.initialBreakSeconds - 1 : state.breakSeconds,
      ));
    }
  }

  void _onIncrementRounds(IncrementRounds event, Emitter<TimerState> emit) {
    if (!state.isRunning) {
      emit(state.copyWith(rounds: state.rounds + 1));
    }
  }

  void _onDecrementRounds(DecrementRounds event, Emitter<TimerState> emit) {
    if (!state.isRunning && state.rounds > 1) {
      emit(state.copyWith(rounds: state.rounds - 1));
    }
  }

  void _onToggleSound(ToggleSound event, Emitter<TimerState> emit) {
    emit(state.copyWith(enableSound: event.enableSound));
  }
}

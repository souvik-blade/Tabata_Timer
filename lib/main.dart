import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabata/timer_event/timer_event.dart';
import 'package:tabata/timer_bloc/timer_bloc.dart';
import 'package:tabata/timer_state.dart/timer_state.dart';

// main.dart

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (_) => TimerBloc(),
        child: MyHomePage(title: 'Workout Timer'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) {
              return Container(
                color: state.isBreak ? Colors.greenAccent : Colors.redAccent,
              );
            },
          ),
          BlocBuilder<TimerBloc, TimerState>(
            builder: (context, state) {
              return Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height *
                    (state.isBreak
                        ? state.breakSeconds / state.initialBreakSeconds
                        : state.activeSeconds / state.initialActiveSeconds),
                child: Container(
                  color: state.isBreak ? Colors.green : Colors.red,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, state) {
                      return Text(
                        state.isBreak ? 'Break' : 'Active',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, state) {
                      return Text(
                        _formatTime(state.isBreak
                            ? state.breakSeconds
                            : state.activeSeconds),
                        style: const TextStyle(
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, state) {
                      return Text(
                        'Round ${state.currentRound}/${state.rounds}',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Active Duration',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          context
                              .read<TimerBloc>()
                              .add(DecrementActiveDuration());
                        },
                        icon: const Icon(Icons.remove, color: Colors.white),
                      ),
                      BlocBuilder<TimerBloc, TimerState>(
                        builder: (context, state) {
                          return Text(
                            _formatTime(state.initialActiveSeconds),
                            style: const TextStyle(
                                fontSize: 24, color: Colors.white),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          context
                              .read<TimerBloc>()
                              .add(IncrementActiveDuration());
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Break Duration',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          context
                              .read<TimerBloc>()
                              .add(DecrementBreakDuration());
                        },
                        icon: const Icon(Icons.remove, color: Colors.white),
                      ),
                      BlocBuilder<TimerBloc, TimerState>(
                        builder: (context, state) {
                          return Text(
                            _formatTime(state.initialBreakSeconds),
                            style: const TextStyle(
                                fontSize: 24, color: Colors.white),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          context
                              .read<TimerBloc>()
                              .add(IncrementBreakDuration());
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Rounds',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<TimerBloc>().add(DecrementRounds());
                        },
                        icon: const Icon(Icons.remove, color: Colors.white),
                      ),
                      BlocBuilder<TimerBloc, TimerState>(
                        builder: (context, state) {
                          return Text(
                            '${state.rounds}',
                            style: const TextStyle(
                                fontSize: 24, color: Colors.white),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<TimerBloc>().add(IncrementRounds());
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<TimerBloc, TimerState>(
                    builder: (context, state) {
                      return SwitchListTile(
                        value: state.enableSound,
                        onChanged: (value) {
                          context.read<TimerBloc>().add(ToggleSound(value));
                        },
                        title: const Text('Enable Sound',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context.read<TimerBloc>().add(
                                context.read<TimerBloc>().state.isRunning
                                    ? PauseTimer()
                                    : StartTimer());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white)),
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: BlocBuilder<TimerBloc, TimerState>(
                              builder: (context, state) {
                                return Text(
                                  state.isRunning ? 'Pause' : 'Start',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 28, color: Colors.white),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            context.read<TimerBloc>().add(ResetTimer());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white)),
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: const Text(
                              'Restart',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 28, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

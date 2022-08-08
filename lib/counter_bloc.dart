import 'dart:async';

enum CounterAction {
  Increment,
  Decrement,
  Reset,
}

class CounterBloc {
  int? counter;

  // Only for stateStream perform states
  final stateStreamController = StreamController<int>();
  StreamSink<int> get counterSink => stateStreamController.sink;
  Stream<int> get counterStream => stateStreamController.stream;

  // Only for eventStream perform event
  final eventStreamController = StreamController<CounterAction>();
  StreamSink<CounterAction> get eventSink => eventStreamController.sink;
  Stream<CounterAction> get eventStream => eventStreamController.stream;

  // Only for logic
  CounterBloc() {
    counter = 0;
    eventStream.listen((event) {
      if (event == CounterAction.Increment) {
        counter = counter! + 1;
      } else if (event == CounterAction.Decrement) {
        counter = counter! - 1;
      } else if (event == CounterAction.Reset) {
        counter = 0;
      }
      counterSink.add(counter!);
    });
  }

  void dispose() {
    stateStreamController.close();
    eventStreamController.close();
  }
}

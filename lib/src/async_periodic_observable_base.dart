import 'dart:async';

import 'package:rxdart/rxdart.dart';

/// RxDart Observable.periodic(duration, computation()) does not accept an async computation.
/// This class solves the problem.
class AsyncPeriodicObservable<T> extends Observable<T> {
  AsyncPeriodicObservable(Stream<T> stream) : super(stream);

  // Builds a new PeriodicObservable from an Observable.periodic that awaits a
  // Future from an async computation every 'duration' seconds.
  factory AsyncPeriodicObservable.fromAsyncComputation(
    Future<T> computation(), {
    Duration duration = const Duration(seconds: 1),
  }) {
    return AsyncPeriodicObservable(
      Observable<Future<T>>.periodic(duration, (i) => computation())
          .startWith(computation())
          .asyncMap((Future<T> value) async => await value),
    );
  }
}

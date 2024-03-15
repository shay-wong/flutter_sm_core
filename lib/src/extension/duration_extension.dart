import '../utils/data_format/data_format.dart';
extension DurationIntExt on int {
  Duration get seconds => Duration(seconds: this);

  Duration get days => Duration(days: this);

  Duration get hours => Duration(hours: this);

  Duration get minutes => Duration(minutes: this);

  Duration get milliseconds => Duration(milliseconds: this);

  Duration get microseconds => Duration(microseconds: this);

  Duration get ms => milliseconds;
}

extension DurationNumExt on num {
  Duration get seconds => toDouble().seconds;

  Duration get days => toDouble().days;

  Duration get hours => toDouble().hours;

  Duration get minutes => toDouble().minutes;

  Duration get milliseconds => toDouble().milliseconds;

  Duration get microseconds => toDouble().microseconds;

  Duration get ms => milliseconds;
}

extension DurationDoubleExt on double {
  Duration get seconds => converToDuration(seconds: this);

  Duration get days => converToDuration(days: this);

  Duration get hours => converToDuration(hours: this);

  Duration get minutes => converToDuration(minutes: this);

  Duration get milliseconds => converToDuration(milliseconds: this);

  Duration get microseconds => converToDuration(microseconds: this);

  Duration get ms => milliseconds;

  Duration converToDuration({
    double days = 0,
    double hours = 0,
    double minutes = 0,
    double seconds = 0,
    double milliseconds = 0,
    double microseconds = 0,
  }) {
    return Duration(
      microseconds: (days * Duration.microsecondsPerDay +
              hours * Duration.microsecondsPerHour +
              minutes * Duration.microsecondsPerMinute +
              seconds * Duration.microsecondsPerSecond +
              milliseconds * Duration.microsecondsPerMillisecond +
              microseconds)
          .round(),
    );
  }
}

extension DurationFormatExt on Duration {
  String format([String? newPattern]) {
    return MDateFormat(newPattern).formatWith(this);
  }
}

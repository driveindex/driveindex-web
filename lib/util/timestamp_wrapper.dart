class TimestampWrapper {
  TimestampWrapper._();

  static String of(int timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(timestamp)
        .toLocal().toString().substring(0, 16);
  }
}

class SizeWrapper {
  SizeWrapper._();

  static final List<String> sizeName = ["B", "KB", "MB", "GB", "TB", "PB"];
  static String of(int size) {
    int index = 0; double wrappedSize = size.toDouble();
    while (wrappedSize > 1024 && index < 6) {
      wrappedSize /= 1024; index += 1;
    }
    return "${wrappedSize.toStringAsFixed(2)} ${sizeName[index]}";
  }
}
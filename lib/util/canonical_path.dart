/// 一个用于解析标准路径的工具类：
/// [Java 实现](https://github.com/driveindex/driveindex-cloud/blob/master/commons/src/main/java/io/github/driveindex/common/util/CanonicalPath.java)
class CanonicalPath {
  late final List<String> _pathStack;
  late final String _path;

  static const String ROOT_PATH = "/";

  CanonicalPath._a(String path) {
    _pathStack = [];
    List<String> files = path.split("/");
    for (String file in files) {
      if (file == "" || file == ".") continue;
      if (file == "..") {
        if (!_pathStack.isNotEmpty) continue;
        _pathStack.removeLast();
      }
      _pathStack.add(file);
    }
    _path = _generatePath();
  }

  CanonicalPath._b(List<String> pathStack) {
    _pathStack = pathStack;
    _path = _generatePath();
  }

  String _generatePath() {
    return "/${_pathStack.join("/")}";
  }

  static CanonicalPath of(String path) {
    path = path.replaceAll("\\", "/")
        .replaceAll(":", "");
    return CanonicalPath._a(path);
  }

  static CanonicalPath ROOT = of(ROOT_PATH);

  CanonicalPath getParentPath() {
    List<String> path = getPathStack();
    if (_pathStack.isNotEmpty) path.removeLast();
    return CanonicalPath._b(path);
  }

  CanonicalPath operator +(String newFile) {
    List<String> path = getPathStack();
    path.add(newFile);
    return CanonicalPath._b(path);
  }

  String getPath() {
    return _path;
  }

  String getUrlEncodedPath() {
    return Uri.encodeComponent(_path);
  }

  List<String> getPathStack() {
    return List.from(_pathStack);
  }

  @override
  String toString() {
    return getPath();
  }

  @override
  int get hashCode => getPath().hashCode;

  @override
  bool operator ==(Object other) {
    if ((other is CanonicalPath) == false) return false;
    return other.hashCode == hashCode;
  }
}
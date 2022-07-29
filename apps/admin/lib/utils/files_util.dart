import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class FilesUtil {
  FilesUtil._();

  static Future<String> getPathToFileInCache(String fileName) async {
    final tempDir = await getTemporaryDirectory();
    return path.join(tempDir.path, fileName);
  }
}

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saver_gallery/saver_gallery.dart';

class GalleryUtils {
  static Future<bool> saveMediaToGallery({required String url}) async {
    final tempDir = await getTemporaryDirectory();
    final localFilePath = "${tempDir.path}/${url.split('/').last}";

    final response = await Dio().download(url, localFilePath);

    if (response.statusCode != 200) {
      return false;
    }

    final result = await SaverGallery.saveFile(
      filePath: localFilePath,
      fileName: url.split('/').last,
      skipIfExists: false,
    );
    return result.isSuccess;
  }
}

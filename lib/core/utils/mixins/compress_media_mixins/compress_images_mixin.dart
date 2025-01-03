import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

mixin CompressImagesMixin<T> on Cubit<T> {
  Future<XFile?> compressImage(
    File file,
  ) async {
    // Get the temporary directory
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;

    // Get the original file name and extension
    final fileName = file.uri.pathSegments.last;
    final fileExtension = fileName.split('.').last;
    final fileNameWithoutExtension =
        fileName.replaceFirst(RegExp(r'\.[^.]+$'), '');

    // random text in file name (so the original path and compressed path are different)
    final random = DateTime.now().millisecondsSinceEpoch.toString();

    // Create a unique file name for the compressed image
    final compressedFileName = '$fileNameWithoutExtension.jpg';
    // final compressedFileName = '$fileNameWithoutExtension.$fileExtension';
    final compressedFilePath = '$tempPath/$random$compressedFileName';

    print('fileName: $fileName');
    print('fileExtension: $fileExtension');
    print('compressedFileName: $compressedFileName');
    print('compressedFilePath: $compressedFilePath');

    // Compress the image 
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      compressedFilePath,
      quality: 70,
    );

    return compressedFile;
  }
}

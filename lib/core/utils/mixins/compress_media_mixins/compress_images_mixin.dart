import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

mixin CompressImagesMixin<T> on Cubit<T> {
  Future<XFile?> compressImage(
    File file,
  //     {
  //   required T loadingState,
  //   required T successState,
  //   required T Function(String error) errorState,
  // }
  ) async {
    // Get the temporary directory
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;

    // Get the original file name and extension
    final fileName = file.uri.pathSegments.last;
    final fileExtension = fileName.split('.').last;
    final fileNameWithoutExtension = fileName.replaceFirst(RegExp(r'\.[^.]+$'), '');

    // Create a unique file name for the compressed image
    final compressedFileName =
        '$fileNameWithoutExtension.$fileExtension';
    final compressedFilePath = '$tempPath/$compressedFileName';

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

    // Return the compressed file
    return compressedFile;

    // XFile? result = await FlutterImageCompress.compressAndGetFile(
    //   file.absolute.path,
    //   targetPath,
    //   quality: 88,
    //   rotate: 180,
    // );
    //
    // print(file.lengthSync());
    // print(result!.length());
    //
    // return result;
  }
}

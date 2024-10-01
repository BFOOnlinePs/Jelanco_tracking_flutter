import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_compress/video_compress.dart';

mixin CompressVideoMixin<T> on Cubit<T> {
  MediaInfo? mediaInfo;

  Future<MediaInfo?> compressVideo(
    String filePath, {
    required T loadingState,
    required T successState,
    required T Function(String error) errorState,
  }) async {
    // emit(loadingState);
    print('original file path: $filePath');
    try {
      mediaInfo = await VideoCompress.compressVideo(
        filePath,
        quality: VideoQuality.MediumQuality,
        deleteOrigin: false,
      );
      print('final path after compress: ${mediaInfo?.path}');
      // emit(successState);
    } catch (error) {
      // emit(errorState(error.toString()));
      print('in compress mixin ${error.toString()}');
      mediaInfo = null;
    }
    return mediaInfo;

    // await VideoCompress.compressVideo(
    //   filePath,
    //   quality: VideoQuality.MediumQuality,
    //   deleteOrigin: true,
    // ).then((value) {
    //   mediaInfo = value;
    //   print('final path after compress: ${mediaInfo?.path}');
    //   emit(successState);
    // }).catchError((error) {
    //   emit(errorState(error.toString()));
    // });
  }

  @override
  Future<void> close() {
    VideoCompress.dispose();
    return super.close();
  }
}

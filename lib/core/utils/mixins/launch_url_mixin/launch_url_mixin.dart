// import 'package:bloc/bloc.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// mixin LaunchUrlMixin<T> on Cubit<T>{
//
//   void launchMyUrl({required storagePath, required String uriString}) async {
//     final Uri uri = Uri.parse(storagePath + uriString);
//     print('uri: ${uri}');
//     if (!await launchUrl(uri)) {
//       print('can\'t open the file');
//     }
//   }
// }
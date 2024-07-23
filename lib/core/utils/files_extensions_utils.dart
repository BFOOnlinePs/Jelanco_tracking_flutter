class FilesExtensionsUtils {
  static  bool isAcceptedFileType(String extension) {
    List<String> acceptedExtensions = ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx'];
    return acceptedExtensions.contains(extension.toLowerCase());
  }

}
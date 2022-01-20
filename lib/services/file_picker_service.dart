import 'package:file_picker/file_picker.dart';

class FilePickerService {
  static Future<PlatformFile?> pickFile() async {
    PlatformFile? file;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      file = result.files.single;
    } else {
      // User canceled the picker
    }

    return file;
  }
}

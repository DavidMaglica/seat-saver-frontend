import 'dart:typed_data';

class FileData {
  final Uint8List imageBytes;
  final String filename;

  FileData({required this.imageBytes, required this.filename});
}

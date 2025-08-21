// This file is ONLY compiled on the web platform
import 'dart:async';
import 'dart:html';
import 'dart:typed_data';

import 'package:table_reserver/utils/file_data.dart';

Future<FileData?> imagePicker() async {
  final completer = Completer<FileData?>();
  final uploadInput = FileUploadInputElement()
    ..multiple = false
    ..accept = 'image/*';

  uploadInput.click();

  uploadInput.onChange.listen((event) async {
    final files = uploadInput.files;
    if (files == null || files.isEmpty) {
      completer.complete(null);
      return;
    }

    final file = files.first;

    const maxSizeInBytes = 3 * 1024 * 1024;
    if (file.size > maxSizeInBytes) {
      completer.completeError(
        'File "${file.name}" exceeds the max size of 3 MB.',
      );
      return;
    }

    final reader = FileReader();
    reader.readAsArrayBuffer(file);
    reader.onLoad.listen((_) {
      final bytes = reader.result as Uint8List;
      if (!completer.isCompleted) {
        completer.complete(FileData(imageBytes: bytes, filename: file.name));
      }
    });
    reader.onError.listen((error) {
      if (!completer.isCompleted) completer.completeError(error);
    });
  });

  document.body?.append(uploadInput);
  final result = await completer.future;
  uploadInput.remove();
  return result;
}

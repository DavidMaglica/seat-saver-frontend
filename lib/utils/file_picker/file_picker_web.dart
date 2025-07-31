// This file is ONLY compiled on the web platform
import 'dart:async';
import 'dart:html';

Future<List<String>> imagePicker(bool isHeaderImage) async {
  final completer = Completer<List<String>>();
  FileUploadInputElement uploadInput = FileUploadInputElement()
    ..multiple = !isHeaderImage
    ..accept = 'image/*';
  uploadInput.click();
  uploadInput.addEventListener('change', (e) async {
    final files = uploadInput.files;
    if (files == null || files.isEmpty) {
      completer.completeError('No files selected');
      return;
    }
    Iterable<Future<String>> resultsFutures = files.map((file) {
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onError.listen((error) => completer.completeError(error));
      return reader.onLoad.first.then((_) => reader.result as String);
    });

    final results = await Future.wait(resultsFutures);
    if (!completer.isCompleted) {
      completer.complete(results);
    }
  });

  document.body?.append(uploadInput);
  final List<String> images = await completer.future;
  uploadInput.remove();
  return images;
}

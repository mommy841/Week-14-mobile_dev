import 'dart:io';

import 'package:flutter/services.dart';

const _photoChannel = MethodChannel('boring_app/photo_picker');

Future<Uint8List?> pickPhoto() async {
  final path = await _photoChannel.invokeMethod<String>('pickPhoto');
  if (path == null) return null;
  return File(path).readAsBytes();
}

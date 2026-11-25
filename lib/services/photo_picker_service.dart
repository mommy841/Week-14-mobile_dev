import 'dart:typed_data';

import 'photo_picker_stub.dart' if (dart.library.io) 'photo_picker_io.dart'
    as platform;

class PhotoPickerService {
  Future<Uint8List?> pickPhoto() => platform.pickPhoto();
}

import 'package:image_picker/image_picker.dart';

pickImage() async {
  final ImagePicker imagePicker = ImagePicker();
  // XFile? cam = await imagePicker.pickImage(source: ImageSource.camera,preferredCameraDevice: CameraDevice.rear);
  XFile? file = await imagePicker.pickImage(source: ImageSource.gallery , preferredCameraDevice: CameraDevice.rear);

  if (file != null) {
    return await file.readAsBytes();
  }

  // if (cam != null) {
  //   return await cam.readAsBytes();
  // }
  
}

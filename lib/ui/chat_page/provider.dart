import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Provider {
  File? imageFile;
  bool isLoading = false;

  Future<File?> getImage(bool fromGallery) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? pickedFile;
    pickedFile = await imagePicker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      return imageFile;
    }
    return null;
  }

// void uploadImageFile() async {
//   String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//   UploadTask uploadTask = chatProvider.uploadImageFile(imageFile!, fileName);
//   try {
//     TaskSnapshot snapshot = await uploadTask;
//     imageUrl = await snapshot.ref.getDownloadURL();
//     setState(() {
//       isLoading = false;
//       onSendMessage(imageUrl, MessageType.image);
//     });
//   } on FirebaseException catch (e) {
//     setState(() {
//       isLoading = false;
//     });
//     Fluttertoast.showToast(msg: e.message ?? e.toString());
//   }
// }
}

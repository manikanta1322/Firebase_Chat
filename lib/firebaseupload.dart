import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class navigation {
  uploadImageToFirebase() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return null; // No image selected
    }

    File imageFile = File(pickedFile.path);

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef =
        FirebaseStorage.instance.ref().child('images/$fileName.jpg');
    UploadTask uploadTask = storageRef.putFile(imageFile);

    try {
      await uploadTask;
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image: $e');
      return null; // Upload failed
    }
  }
}

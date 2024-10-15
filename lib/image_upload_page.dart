import 'dart:io';
import 'dart:typed_data'; // Import for Uint8List
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as img; // Import the image package

class ImageUploadPage extends StatefulWidget {
  const ImageUploadPage({super.key});

  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  XFile? _image;
  String? _output;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  // Load the TFLite model
  Future<void> loadModel() async {
    String? res = await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
    print("Model Loaded: $res");
  }

  // Pick an image from the gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        _output = null; // Reset output when a new image is picked
      });
    }
  }

  // Run inference on the selected image
  Future<void> runModel(String imagePath) async {
    try {
      // Load the image from the file
      File file = File(imagePath);
      print("Loading image from: $imagePath");

      img.Image? originalImage = img.decodeImage(file.readAsBytesSync());

      if (originalImage == null) {
        setState(() {
          _output = 'Error decoding image';
        });
        return;
      }

      // Resize the image to 128x128 pixels
      img.Image resizedImage = img.copyResize(originalImage, width: 128, height: 128);
      print("Image resized to 128x128");

      // Convert resized image to byte format (JPEG)
      Uint8List resizedImageBytes = Uint8List.fromList(img.encodeJpg(resizedImage));
      print("Image encoded to JPEG format");

      // Run the model on the resized image binary
      var output = await Tflite.runModelOnBinary(
        binary: resizedImageBytes,
        numResults: 2, // Adjust based on your model's output
        threshold: 0.5, // Adjust as needed
      );

      print("Model Output: $output");

      setState(() {
        _output = output != null ? output.toString() : 'No result';
      });
    } catch (e, stacktrace) {
      print("Error: $e");
      print("Stacktrace: $stacktrace"); // Print stacktrace for debugging
      setState(() {
        _output = 'An error occurred: $e';
      });
    }
  }

  // Button to check prediction
  void _checkPrediction() {
    if (_image != null) {
      runModel(_image!.path);
    } else {
      setState(() {
        _output = 'No image selected';
      });
    }
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Forehead Picture')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? kIsWeb
                    ? Image.network(_image!.path) // For web display
                    : Image.file(File(_image!.path)) // For mobile display
                : const Text('No image selected'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: const Text('Capture Image'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: const Text('Select from Gallery'),
            ),
            const SizedBox(height: 20),
            if (_image != null) // Only show this button if an image is selected
              ElevatedButton(
                onPressed: _checkPrediction,
                child: const Text('Check Prediction'),
              ),
            const SizedBox(height: 20),
            _output == null
                ? const Text('Waiting for result...')
                : Text('Prediction: $_output'),
          ],
        ),
      ),
    );
  }
}

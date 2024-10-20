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
      appBar: AppBar(
        title: const Text('Upload Forehead Picture'),
        backgroundColor: Colors.teal, // Set AppBar color to teal
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.tealAccent], // Background gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image != null
                ? kIsWeb
                    ? Image.network(_image!.path, height: 200) // For web display
                    : Image.file(File(_image!.path), height: 200) // For mobile display
                : const Text('No image selected', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),

            // Capture Image button
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label: const Text('Capture Image', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Select from Gallery button
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo, color: Colors.white),
              label: const Text('Select from Gallery', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Check Prediction button (only visible when an image is selected)
            if (_image != null)
              ElevatedButton.icon(
                onPressed: _checkPrediction,
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text('Check Prediction', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Output or waiting text
            _output == null
                ? const Text('Waiting for result...', style: TextStyle(fontSize: 16))
                : Text('Prediction: $_output', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

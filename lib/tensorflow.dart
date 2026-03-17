import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class Tensorflow {
  static Interpreter? _interpreter;
  static List<String>? _labels;

  // Memuat model dari assets
  static Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset("assets/batik_model.tflite");
      final labelData = await rootBundle.loadString("assets/labels.txt");
      _labels = labelData.split('\n').where((s) => s.isNotEmpty).toList();
    } catch (e) {
      print("Error loading model: \$e");
    }
  }

  // Melakukan klasifikasi gambar
  static Future<List<Map<String, dynamic>>?> classifyImage(File imageFile) async {
    if (_interpreter == null || _labels == null) return null;

    var imageBytes = await imageFile.readAsBytes();
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) return null;

    var inputShape = _interpreter!.getInputTensor(0).shape;
    int height = inputShape[1];
    int width = inputShape[2];

    img.Image resizedImage = img.copyResize(image, width: width, height: height);

    var inputType = _interpreter!.getInputTensor(0).type;
    var input = List.generate(1, (i) => List.generate(height, (y) => List.generate(width, (x) {
      final pixel = resizedImage.getPixel(x, y);
      if (inputType == TensorType.float32) {
        return [
          (pixel.r - 0.0) / 255.0,
          (pixel.g - 0.0) / 255.0,
          (pixel.b - 0.0) / 255.0
        ];
      } else {
        return [pixel.r, pixel.g, pixel.b];
      }
    })));

    var outputShape = _interpreter!.getOutputTensor(0).shape;
    int numClasses = outputShape[1];
    var output = List.generate(1, (i) => List.filled(numClasses, 0.0));

    _interpreter!.run(input, output);
    var probabilities = output[0];

    double maxProb = 0;
    int maxIndex = -1;
    for (int i = 0; i < probabilities.length; i++) {
      if (probabilities[i] > maxProb) {
        maxProb = probabilities[i];
        maxIndex = i;
      }
    }

    if (maxIndex != -1 && maxProb >= 0.2) {
      String label = _labels![maxIndex];
      // Jika label punya angka di depan (misal: "0 Parang"), dipotong
      if (label.contains(' ')) {
         label = label.substring(label.indexOf(' ') + 1);
      }
      return [{"label": label, "confidence": maxProb}];
    } else {
      return [{"label": "Tidak dikenali", "confidence": maxProb}];
    }
  }

  // Menutup interpreter untuk menghemat memori
  static void dispose() {
    _interpreter?.close();
  }
}

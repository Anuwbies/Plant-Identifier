import 'dart:io';
import 'package:flutter/material.dart';
import '../../api/efficientnetb3_api.dart';
import '../information/information_page.dart';
import '../unknown/unknown_page.dart';

class ScanPageModel {
  late AnimationController _controller;
  bool isScanning = true;
  late BuildContext _context;
  late ImageProvider _image;
  late TickerProvider _vsync;

  void init(ImageProvider image, BuildContext context, TickerProvider vsync) {
    _image = image;
    _context = context;
    _vsync = vsync;

    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(seconds: 2),
    )..repeat();

    analyzeImage();
  }

  Future<void> analyzeImage() async {
    try {
      File? imageFile;
      if (_image is FileImage) {
        imageFile = (_image as FileImage).file;
      } else {
        throw Exception('ScanPage only supports FileImage for now');
      }

      // Call Django EfficientNetB3 API
      final result = await EfficientNetB3Api.predictPlant(imageFile);

      if (result.containsKey("error")) {
        _navigateToUnknown();
        return;
      }

      // Extract data
      final sampleImageUrl = result["sample_image"] ?? "";
      final predictedIndex = result["predicted_index"] ?? -1;
      final speciesId = result["species_id"] ?? 0;
      final commonName = result["common_name"] ?? "Unknown";
      final scientificName = result["scientific_name"] ?? "Unknown";
      final confidence = (result["confidence"] ?? 0.0) * 100;

      if (confidence < 60.0) {
        _navigateToUnknown();
      } else {
        _navigateToInformation(
          sampleImageUrl: sampleImageUrl,
          predictedIndex: predictedIndex,
          speciesId: speciesId,
          commonName: commonName,
          scientificName: scientificName,
          confidence: confidence,
          imageFile: imageFile!,
        );
      }
    } catch (e) {
      _navigateToUnknown();
    } finally {
      _controller.stop();
      isScanning = false;
    }
  }

  void _navigateToUnknown() {
    Navigator.of(_context).pushReplacement(
      MaterialPageRoute(builder: (_) => const UnknownPage()),
    );
  }

  void _navigateToInformation({
    required String sampleImageUrl,
    required int predictedIndex,
    required int speciesId,
    required String commonName,
    required String scientificName,
    required double confidence,
    required File imageFile,
  }) {
    Navigator.of(_context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => InformationPage(
          imageUrl: sampleImageUrl.isNotEmpty
              ? "http://10.0.2.2:8000$sampleImageUrl"
              : imageFile.path,
          predictedIndex: predictedIndex,
          speciesId: speciesId,
          commonName: commonName,
          scientificName: scientificName,
          confidence: confidence,
        ),
      ),
          (Route<dynamic> route) => route.isFirst,
    );
  }

  void dispose() {
    _controller.dispose();
  }
}

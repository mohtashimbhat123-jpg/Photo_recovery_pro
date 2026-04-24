import 'dart:typed_data';
import 'package:flutter/material.dart';

class SuperFile {
  final String name;
  final Uint8List data;
  final double confidence;
  final String type;
  final double recoveryScore;
  final DateTime recoveredAt;

  SuperFile({
    required this.name,
    required this.data,
    required this.confidence,
    required this.type,
    required this.recoveryScore,
    DateTime? recoveredAt,
  }) : recoveredAt = recoveredAt ?? DateTime.now();

  String get sizeFormatted {
    final bytes = data.length;
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Widget previewImage({int width = 100, int height = 100}) {
    return Container(
      width: width.toDouble(),
      height: height.toDouble(),
      color: Colors.grey.shade300,
      child: type == 'jpg' || type == 'png'
          ? Image.memory(data, fit: BoxFit.cover)
          : Center(
              child: Icon(
                type == 'mp4' ? Icons.video_library : Icons.image,
                size: 40,
                color: Colors.grey.shade600,
              ),
            ),
    );
  }

  void preview() {}

  Future<void> recover() async {}
}

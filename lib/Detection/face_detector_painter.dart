import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

double eyesProb = 1;
int blink = 0;
int blinkCounter = 0;
bool isSleep = false;
double yawnProb = 0;
int mouthOpen = 0;
int yawnCounter = 0;

double translateX(
    double x, InputImageRotation rotation, Size size, Size absoluteImageSize) {
  switch (rotation) {
    case InputImageRotation.Rotation_90deg:
      return x *
          size.width /
          (Platform.isIOS ? absoluteImageSize.width : absoluteImageSize.height);
    case InputImageRotation.Rotation_270deg:
      return size.width -
          x *
              size.width /
              (Platform.isIOS
                  ? absoluteImageSize.width
                  : absoluteImageSize.height);
    default:
      return x * size.width / absoluteImageSize.width;
  }
}

double translateY(
    double y, InputImageRotation rotation, Size size, Size absoluteImageSize) {
  switch (rotation) {
    case InputImageRotation.Rotation_90deg:
    case InputImageRotation.Rotation_270deg:
      return y *
          size.height /
          (Platform.isIOS ? absoluteImageSize.height : absoluteImageSize.width);
    default:
      return y * size.height / absoluteImageSize.height;
  }
}

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.faces, this.absoluteImageSize, this.rotation);

  final List<Face> faces;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.green;

    for (final Face face in faces) {
      canvas.drawRect(
        Rect.fromLTRB(
          translateX(face.boundingBox.left, rotation, size, absoluteImageSize),
          translateY(face.boundingBox.top, rotation, size, absoluteImageSize),
          translateX(face.boundingBox.right, rotation, size, absoluteImageSize),
          translateY(
              face.boundingBox.bottom, rotation, size, absoluteImageSize),
        ),
        paint,
      );

      void paintContour(FaceContourType type) {
        final faceContour = face.getContour(type);
        if (faceContour?.positionsList != null) {
          for (Offset point in faceContour!.positionsList) {
            canvas.drawCircle(
                Offset(
                  translateX(point.dx, rotation, size, absoluteImageSize),
                  translateY(point.dy, rotation, size, absoluteImageSize),
                ),
                1,
                paint);
          }
        }
      }

      paintContour(FaceContourType.face);
      paintContour(FaceContourType.leftEye);
      paintContour(FaceContourType.rightEye);
      paintContour(FaceContourType.upperLipTop);
      paintContour(FaceContourType.upperLipBottom);
      paintContour(FaceContourType.lowerLipTop);
      paintContour(FaceContourType.lowerLipBottom);
      // eyesOpenClose =
      //     (face.leftEyeOpenProbability! + face.rightEyeOpenProbability!) / 2;
      // if (eyesOpenClose < 0.1) {
      //   blink++;
      // }

      // yawnProb = face.smilingProbability!;
      // if (yawnProb < 0.005) {
      //   mouthOpen++;
      //   if (mouthOpen == 1) {
      //     yawnCounter++;
      //   }
      // }
    }

    //eyes closure detection
    drowsyClassification();
  }

  void drowsyClassification() {
    //eyes closure detection
    eyesProb =
        (faces[0].leftEyeOpenProbability! + faces[0].rightEyeOpenProbability!) /
            2;

    if (eyesProb < 0.1) {
      blinkCounter++;
      if (blinkCounter > 6) {
        isSleep = true;
      }
      if (blinkCounter == 1) {
        blink++;
      }
    } else {
      blinkCounter = 0;
      isSleep = false;
    }

    //yawn Detection
    yawnProb = faces[0].smilingProbability!;
    if (yawnProb < 0.009) {
      mouthOpen++;
      if (mouthOpen == 10) {
        yawnCounter++;
      }
    } else {
      mouthOpen = 0;
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}

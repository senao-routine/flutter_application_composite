import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class PhotosView extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey();
  final List<String> samplePhotos = [
    'assets/images/sample1.jpg',
    'assets/images/sample2.jpg',
    'assets/images/sample3.jpg',
    'assets/images/sample4.jpg',
    'assets/images/sample5.jpg',
    'assets/images/sample6.jpg',
  ];

  Future<void> _captureAndSavePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final blob = html.Blob([pngBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);

      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "photos_${DateTime.now().toString()}.png")
        ..click();

      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 3 / 4,
          child: Stack(
            children: [
              RepaintBoundary(
                key: _globalKey,
                child: Container(
                  color: Colors.white,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Photos',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 4.0),
                              height: 2.0,
                              width: 100,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                double width = constraints.maxWidth;
                                double height = constraints.maxHeight;
                                return Column(
                                  children: [
                                    _buildTopRow(width, height * 0.6),
                                    _buildBottomRow(width, height * 0.4),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: ElevatedButton(
                  child: Icon(Icons.download, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.5),
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(12),
                  ),
                  onPressed: _captureAndSavePng,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow(double width, double height) {
    return Row(
      children: [
        _buildImage(samplePhotos[0], width * 0.6, height),
        Column(
          children: [
            _buildImage(samplePhotos[1], width * 0.4, height * 0.5),
            _buildImage(samplePhotos[2], width * 0.4, height * 0.5),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomRow(double width, double height) {
    return Row(
      children: [
        Column(
          children: [
            _buildImage(samplePhotos[3], width * 0.35, height * 0.6),
            _buildImage(samplePhotos[4], width * 0.35, height * 0.4),
          ],
        ),
        _buildImage(samplePhotos[5], width * 0.65, height),
      ],
    );
  }

  Widget _buildImage(String imagePath, double width, double height) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:html' as html;

class PhotoPage extends StatefulWidget {
  final List<dynamic> photos;

  PhotoPage({required this.photos});

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final GlobalKey _globalKey = GlobalKey();

  Future<void> _captureAndSavePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Webで画像をダウンロードするための処理
      final blob = html.Blob([pngBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "captured_image.png")
        ..click();
      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('画像を保存しました')));
    } catch (e) {
      print("キャプチャエラー: $e");
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
                  child: Column(
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double width = constraints.maxWidth;
                            double height = constraints.maxHeight;
                            return Column(
                              children: [
                                _buildTopRow(width, height * 0.5),
                                _buildBottomRow(width, height * 0.5),
                              ],
                            );
                          },
                        ),
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
        _buildImage(widget.photos.length > 0 ? widget.photos[0] : null,
            width * 0.5, height),
        Column(
          children: [
            _buildImage(widget.photos.length > 1 ? widget.photos[1] : null,
                width * 0.5, height * 0.5),
            _buildImage(widget.photos.length > 2 ? widget.photos[2] : null,
                width * 0.5, height * 0.5),
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
            _buildImage(widget.photos.length > 3 ? widget.photos[3] : null,
                width * 0.5, height * 0.5),
            _buildImage(widget.photos.length > 4 ? widget.photos[4] : null,
                width * 0.5, height * 0.5),
          ],
        ),
        _buildImage(widget.photos.length > 5 ? widget.photos[5] : null,
            width * 0.5, height),
      ],
    );
  }

  Widget _buildImage(dynamic photo, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent, width: 0), // 余白をなくす
      ),
      child: photo == null
          ? Container()
          : (photo is String
              ? Image.network(photo, fit: BoxFit.cover)
              : Image.file(photo, fit: BoxFit.cover)),
    );
  }
}

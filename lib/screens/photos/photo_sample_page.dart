import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:html' as html;

class PhotoPage extends StatefulWidget {
  final List<dynamic> photos;

  const PhotoPage({super.key, required this.photos});

  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final GlobalKey _globalKey = GlobalKey();
  dynamic _uploadedIcon; // アイコンの画像を格納する変数

  // Method to capture and save the screen as an image
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
        ..setAttribute("download", "captured_image.png")
        ..click();
      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('画像を保存しました')));
    } catch (e) {
      print("キャプチャエラー: $e");
    }
  }

  // アイコンをアップロードするメソッド (Web対応)
  Future<void> _pickIcon() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement()
      ..accept = 'image/*';
    input.click();

    await input.onChange.first;
    if (input.files!.isNotEmpty) {
      final reader = html.FileReader();
      reader.readAsDataUrl(input.files![0]);

      await reader.onLoad.first;
      setState(() {
        _uploadedIcon = reader.result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Center(
          child: Text('Photoページ', style: TextStyle(color: Colors.white)),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'アイコン追加') {
                setState(() {
                  _uploadedIcon = AssetImage('assets/images/mk_room_logo.png');
                });
              } else if (value == 'アイコンをアップロード') {
                _pickIcon();
              }
            },
            itemBuilder: (BuildContext context) {
              return {'アイコン追加', 'アイコンをアップロード'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
          IconButton(
            icon: Icon(Icons.download, color: Colors.white),
            onPressed: _captureAndSavePng,
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[300], // 背景色を灰色に変更
        child: Center(
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Stack(
              children: [
                RepaintBoundary(
                  key: _globalKey,
                  child: Container(
                    color: Colors.white,
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  double width = constraints.maxWidth;
                                  double height = constraints.maxHeight;
                                  return Column(
                                    children: [
                                      _buildTopRow(width,
                                          height * 0.7), // Top half height
                                      _buildBottomRow(width,
                                          height * 0.3), // Bottom half height
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        // アップロードされたアイコンを左上に表示 (Web対応)
                        if (_uploadedIcon != null)
                          Positioned(
                            top: 16,
                            left: 16,
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: _uploadedIcon is AssetImage
                                  ? Image(image: _uploadedIcon)
                                  : Image.network(_uploadedIcon,
                                      fit: BoxFit.cover),
                            ),
                          ),
                        // Move the "Photo" text inside the RepaintBoundary
                        Positioned(
                          top: 2,
                          right: 30,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.asset(
                                'assets/images/photo_logo.png',
                                width: 100, // サイズを小さく調整
                                height: 100,
                                fit: BoxFit.contain, // 画像全体を表示
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Builds the top row layout with increased height
  Widget _buildTopRow(double width, double height) {
    return Row(
      children: [
        _buildAspectRatioImage(
            widget.photos.isNotEmpty ? widget.photos[0] : null,
            width * 0.6,
            height), // The wider left image occupies 60% of width
        Column(
          children: [
            _buildAspectRatioImage(
                widget.photos.length > 1 ? widget.photos[1] : null,
                width * 0.4,
                height *
                    0.5), // Right-top image with 50% of the remaining height
            _buildAspectRatioImage(
                widget.photos.length > 2 ? widget.photos[2] : null,
                width * 0.4,
                height *
                    0.5), // Right-bottom image with 50% of the remaining height
          ],
        ),
      ],
    );
  }

  // Builds the bottom row layout with reduced height
  Widget _buildBottomRow(double width, double height) {
    return Row(
      children: [
        _buildAspectRatioImage(
            widget.photos.length > 3 ? widget.photos[3] : null,
            width / 3,
            height), // Image 1 in bottom row, 1/3 of total width
        _buildAspectRatioImage(
            widget.photos.length > 4 ? widget.photos[4] : null,
            width / 3,
            height), // Image 2 in bottom row, 1/3 of total width
        _buildAspectRatioImage(
            widget.photos.length > 5 ? widget.photos[5] : null,
            width / 3,
            height), // Image 3 in bottom row, 1/3 of total width
      ],
    );
  }

  // Creates a container for each image, maintaining the 3:4 aspect ratio
  Widget _buildAspectRatioImage(dynamic photo, double width, double height) {
    return SizedBox(
      width: width,
      height: height,
      child: AspectRatio(
        aspectRatio: 3 / 4, // Ensures all images maintain a 3:4 aspect ratio
        child: photo == null
            ? Container()
            : (photo is String
                ? Image.network(photo, fit: BoxFit.cover)
                : Image.file(photo, fit: BoxFit.cover)),
      ),
    );
  }
}

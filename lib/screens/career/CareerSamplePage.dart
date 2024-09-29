import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/rendering.dart';

class CareerView extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey(); // Global key for RepaintBoundary
  final List<Map<String, List<String>>> careerList; // キャリア情報
  final dynamic backgroundImage; // キャリアの背景画像

  CareerView({
    Key? key,
    required this.careerList,
    required this.backgroundImage,
  }) : super(key: key);

  // Method to capture the screen and download as an image
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
        ..setAttribute("download", "career_image.png")
        ..click();
      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(_globalKey.currentContext!)
          .showSnackBar(SnackBar(content: Text('画像を保存しました')));
    } catch (e) {
      print("キャプチャエラー: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Careerページ'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 3 / 4, // 常に3:4のアスペクト比に設定
          child: Stack(
            children: [
              // 背景画像があるかどうかにかかわらず常に表示
              RepaintBoundary(
                key: _globalKey,
                child: Stack(
                  children: [
                    // 背景画像があるかどうかをチェック
                    if (backgroundImage != null) ...[
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: backgroundImage is File
                                  ? FileImage(backgroundImage)
                                  : NetworkImage(backgroundImage),
                              fit: BoxFit.cover, // 背景画像を常に表示
                            ),
                          ),
                        ),
                      ),
                      // 白いテキストボックスとテキストを表示
                      Positioned(
                        top: 80,
                        left: 30,
                        right: 30,
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8), // 半透明の白
                            borderRadius: BorderRadius.circular(1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCareerDetails(context),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      // 背景画像がない場合のメッセージ
                      Center(
                        child: Text(
                          'アップロードされた写真がありません',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // "Career" テキストを右上に表示
              Positioned(
                top: 28,
                right: 50, // ダウンロードボタンの位置に合わせて適切な距離を設定
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Career',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min, // テキストの幅に合わせる
                      children: [
                        Container(
                          height: 3.0,
                          width: 100, // アンダーラインの幅を設定
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ダウンロードボタン
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

  Widget _buildCareerDetails(BuildContext context) {
    List<Widget> careerDetails = [];

    for (var entry in careerList) {
      careerDetails.add(
        Text(
          '【${entry.keys.first}】',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
      for (var item in entry.values.first) {
        careerDetails.add(
          Text(
            '・$item', // 項目の先頭に「・」を追加
            style: TextStyle(fontSize: 15, color: Colors.black),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: careerDetails,
    );
  }
}

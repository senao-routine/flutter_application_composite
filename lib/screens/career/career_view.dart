import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class CareerView extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey();

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
        ..setAttribute("download", "career_${DateTime.now().toString()}.png")
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  RepaintBoundary(
                    key: _globalKey,
                    child: Container(
                      color: Colors.white,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Image.asset(
                              'assets/images/career_background.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.all(constraints.maxWidth * 0.04),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Career',
                                  style: TextStyle(
                                    fontSize: constraints.maxWidth * 0.08,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontFamily: 'CustomFont',
                                  ),
                                ),
                                Container(
                                  height: constraints.maxHeight * 0.005,
                                  width: constraints.maxWidth * 0.25,
                                  color: Colors.black,
                                ),
                                SizedBox(height: constraints.maxHeight * 0.01),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: SingleChildScrollView(
                                      padding: EdgeInsets.all(
                                          constraints.maxWidth * 0.02),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildSection(
                                              'CM',
                                              [
                                                'ホットペッパービューティー学割〜同じ髪型なのに〜篇',
                                                'クラウド郵便サービス「atena」',
                                                // ... 他の項目
                                              ],
                                              constraints),
                                          _buildSection(
                                              'スチール',
                                              [
                                                '箱根フリーパス"もたないなんてもったいない"',
                                                'syossブルーセント（ヌードグレージュ・オーシャンブルー）',
                                                // ... 他の項目
                                              ],
                                              constraints),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: constraints.maxHeight * 0.02,
                    right: constraints.maxWidth * 0.02,
                    child: ElevatedButton(
                      child: Icon(Icons.download,
                          color: Colors.white,
                          size: constraints.maxWidth * 0.06),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black.withOpacity(0.5),
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(constraints.maxWidth * 0.03),
                      ),
                      onPressed: _captureAndSavePng,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
      String title, List<String> items, BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•$title',
          style: TextStyle(
            fontSize: constraints.maxWidth * 0.035,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: constraints.maxHeight * 0.005),
        ...items.map((item) => Padding(
              padding: EdgeInsets.only(
                  left: constraints.maxWidth * 0.02,
                  bottom: constraints.maxHeight * 0.0025),
              child: Text(
                '・$item',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: constraints.maxWidth * 0.025),
              ),
            )),
        SizedBox(height: constraints.maxHeight * 0.01),
      ],
    );
  }
}

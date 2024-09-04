import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

class ProfileView extends StatelessWidget {
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
        ..setAttribute("download", "profile_${DateTime.now().toString()}.png")
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
        child: Stack(
          children: [
            RepaintBoundary(
              key: _globalKey,
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Container(
                  color: Colors.white,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Image.asset(
                              'assets/images/profile_background.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            left: constraints.maxWidth * 0.03,
                            bottom: constraints.maxHeight * 0.05,
                            child: Container(
                              width: constraints.maxWidth * 0.5,
                              padding:
                                  EdgeInsets.all(constraints.maxWidth * 0.02),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: _buildProfileInfo(constraints),
                            ),
                          ),
                          Positioned(
                            right: constraints.maxWidth * 0.05,
                            bottom: constraints.maxHeight * 0.05,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildFollowerCount(constraints),
                                SizedBox(height: constraints.maxHeight * 0.02),
                                _buildSNSInfo(constraints),
                                SizedBox(height: constraints.maxHeight * 0.02),
                                _buildContactInfo(constraints),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: ElevatedButton(
                child: Icon(Icons.download),
                onPressed: _captureAndSavePng,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Oki Lemoni',
          style: TextStyle(
              fontSize: constraints.maxWidth * 0.03,
              fontWeight: FontWeight.bold),
        ),
        Center(
          child: Text(
            '沖 玲萌 (20)',
            style: TextStyle(fontSize: constraints.maxWidth * 0.046),
            textAlign: TextAlign.center,
          ),
        ),
        CustomPaint(
          size: Size(double.infinity, constraints.maxHeight * 0.01),
          painter: CrayonLinePainter(),
        ),
        SizedBox(height: constraints.maxHeight * 0.01),
        Center(
          child: Column(
            children: [
              Text('2003.04.29',
                  style: TextStyle(
                      fontSize: constraints.maxWidth * 0.026,
                      fontWeight: FontWeight.bold)),
              Text('神奈川県出身',
                  style: TextStyle(
                      fontSize: constraints.maxWidth * 0.026,
                      fontWeight: FontWeight.bold)),
              Text('151cm/39kg',
                  style: TextStyle(
                      fontSize: constraints.maxWidth * 0.026,
                      fontWeight: FontWeight.bold)),
              Text('B:78 W:55 H:81 S:24',
                  style: TextStyle(
                      fontSize: constraints.maxWidth * 0.026,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        SizedBox(height: constraints.maxHeight * 0.01),
        Text('趣味: アニメ・歌',
            style: TextStyle(
                fontSize: constraints.maxWidth * 0.026,
                fontWeight: FontWeight.bold)),
        Text('特技: 体幹バランス',
            style: TextStyle(
                fontSize: constraints.maxWidth * 0.026,
                fontWeight: FontWeight.bold)),
        Text('資格: 英検準1級',
            style: TextStyle(
                fontSize: constraints.maxWidth * 0.026,
                fontWeight: FontWeight.bold)),
        Text('学歴: 立教大学',
            style: TextStyle(
                fontSize: constraints.maxWidth * 0.026,
                fontWeight: FontWeight.bold)),
        SizedBox(height: constraints.maxHeight * 0.01),
        Center(
          child: Text(
            '圧倒的愛嬌の良さ\n高学歴癒しキャラ',
            style: TextStyle(
                color: Color.fromARGB(255, 242, 129, 250),
                fontWeight: FontWeight.bold,
                fontSize: constraints.maxWidth * 0.026),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildFollowerCount(BoxConstraints constraints) {
    return CustomPaint(
      painter: ChalkLinesPainter(
        color: Color.fromARGB(255, 250, 129, 191),
        size: Size(constraints.maxWidth * 0.3, constraints.maxHeight * 0.05),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: constraints.maxWidth * 0.02,
          vertical: constraints.maxHeight * 0.01,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          '★総フォロワー 2.5万人越え',
          style: TextStyle(
            color: Color.fromARGB(255, 250, 129, 191),
            fontWeight: FontWeight.bold,
            fontSize: constraints.maxWidth * 0.024,
          ),
        ),
      ),
    );
  }

  Widget _buildSNSInfo(BoxConstraints constraints) {
    return Container(
      padding: EdgeInsets.all(constraints.maxWidth * 0.02),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSNSItem(
              'assets/images/twitter_icon.png', '@remoni_oki', constraints),
          _buildSNSItem(
              'assets/images/tiktok_icon.png', '@remoremo_0429', constraints),
          _buildSNSItem(
              'assets/images/instagram_icon.png', '@remoni_oki', constraints),
        ],
      ),
    );
  }

  Widget _buildSNSItem(
      String iconPath, String accountName, BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(bottom: constraints.maxHeight * 0.01),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(iconPath,
              width: constraints.maxWidth * 0.08,
              height: constraints.maxWidth * 0.08),
          SizedBox(width: constraints.maxWidth * 0.01),
          Text(accountName,
              style: TextStyle(
                  color: Colors.black, fontSize: constraints.maxWidth * 0.024)),
        ],
      ),
    );
  }

  Widget _buildContactInfo(BoxConstraints constraints) {
    return Container(
      padding: EdgeInsets.all(constraints.maxWidth * 0.016),
      decoration: BoxDecoration(
        color: Color(0xFFADD1F9),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('担当: 福田遼',
              style: TextStyle(
                  color: Colors.black, fontSize: constraints.maxWidth * 0.024)),
          Text('Email: info.mkroom1@gmail.com',
              style: TextStyle(
                  color: Colors.black, fontSize: constraints.maxWidth * 0.024)),
          Text('TEL: 080-4199-8123',
              style: TextStyle(
                  color: Colors.black, fontSize: constraints.maxWidth * 0.024)),
          Text('Casting with APS',
              style: TextStyle(
                  color: Colors.black, fontSize: constraints.maxWidth * 0.024)),
        ],
      ),
    );
  }
}

class CrayonLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5);

    final random = math.Random();

    for (var i = 0; i < size.width; i += 2) {
      final startY = 2 + random.nextDouble() * 2;
      final endY = 2 + random.nextDouble() * 2;
      final opacity = 0.3 + random.nextDouble() * 0.7;

      paint.color = Colors.black.withOpacity(opacity);

      canvas.drawLine(
        Offset(i.toDouble(), startY),
        Offset((i + random.nextDouble() * 3).toDouble(), endY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ChalkLinesPainter extends CustomPainter {
  final Color color;
  final Size size;

  ChalkLinesPainter({required this.color, required this.size});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.5);

    final random = math.Random();

    void drawChalkLine(Offset start, Offset end) {
      final path = Path();
      path.moveTo(start.dx, start.dy);

      final steps = 20;
      for (var i = 0; i < steps; i++) {
        final t = (i + 1) / steps;
        final x = start.dx + (end.dx - start.dx) * t;
        final y = start.dy + (end.dy - start.dy) * t;
        final offset = Offset(
          x + (random.nextDouble() - 0.5) * 2,
          y + (random.nextDouble() - 0.5) * 2,
        );
        path.lineTo(offset.dx, offset.dy);
      }

      canvas.drawPath(path,
          paint..color = color.withOpacity(0.5 + random.nextDouble() * 0.5));
    }

    drawChalkLine(Offset(0, -2), Offset(this.size.width, -2));
    drawChalkLine(Offset(this.size.width + 2, -2),
        Offset(this.size.width + 2, this.size.height + 2));
    drawChalkLine(Offset(this.size.width, this.size.height + 2),
        Offset(0, this.size.height + 2));
    drawChalkLine(Offset(-2, this.size.height + 2), Offset(-2, -2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

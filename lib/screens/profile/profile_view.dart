import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/rendering.dart';

class ProfileView extends StatelessWidget {
  final GlobalKey _globalKey = GlobalKey(); // Global key for RepaintBoundary

  final String name;
  final String nameJapanese;
  final String birthDate;
  final String birthPlace;
  final String height;
  final String weight;
  final String bust;
  final String waist;
  final String hip;
  final String shoeSize;
  final String hobby;
  final String skill;
  final String qualification;
  final String education;
  final String twitterAccount;
  final String tiktokAccount;
  final String instagramAccount;
  final String managerName;
  final String managerEmail;
  final String managerPhone;
  final String agency;
  final dynamic backgroundImage; // 背景画像

  ProfileView({
    Key? key,
    required this.name,
    required this.nameJapanese,
    required this.birthDate,
    required this.birthPlace,
    required this.height,
    required this.weight,
    required this.bust,
    required this.waist,
    required this.hip,
    required this.shoeSize,
    required this.hobby,
    required this.skill,
    required this.qualification,
    required this.education,
    required this.twitterAccount,
    required this.tiktokAccount,
    required this.instagramAccount,
    required this.managerName,
    required this.managerEmail,
    required this.managerPhone,
    required this.agency,
    required this.backgroundImage,
  }) : super(key: key);

  // Method to capture the profile page as an image and download it
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
        ..setAttribute("download", "profile_image.png")
        ..click();
      html.Url.revokeObjectUrl(url);

      ScaffoldMessenger.of(_globalKey.currentContext!)
          .showSnackBar(SnackBar(content: Text('画像を保存しました')));
    } catch (e) {
      print("キャプチャエラー: $e");
    }
  }

  // 年齢を計算するメソッド
  int calculateAge(String birthDate) {
    try {
      List<String> parts;
      if (birthDate.contains('.')) {
        parts = birthDate.split('.');
      } else if (birthDate.contains('/')) {
        parts = birthDate.split('/');
      } else {
        throw FormatException('Unknown date format');
      }

      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int day = int.parse(parts[2]);

      DateTime birth = DateTime(year, month, day);
      DateTime today = DateTime.now();

      int age = today.year - birth.year;
      if (today.month < birth.month ||
          (today.month == birth.month && today.day < birth.day)) {
        age--;
      }
      return age;
    } catch (e) {
      print("Date parsing error: $e");
      return 0; // エラーハンドリングとして年齢を0に設定
    }
  }

  @override
  Widget build(BuildContext context) {
    int age = calculateAge(birthDate);

    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 3 / 4, // 3:4のアスペクト比に設定
          child: Stack(
            children: [
              RepaintBoundary(
                key: _globalKey, // Assign the key to the RepaintBoundary
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
                              fit: BoxFit.cover, // 背景画像をフルスクリーンに調整
                            ),
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

                    // 右上に "Profile" テキストを表示
                    Positioned(
                      top: 28,
                      right: 50, // ダウンロードボタンの位置に合わせて適切な距離を設定
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Profile',
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

                    // 名前〜趣味・特技を白いボックスに入れて左下に配置
                    Positioned(
                      left: 20,
                      bottom: 20,
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        width: 300, // ボックスの幅を固定
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 名前ローマ字と日本語を中央揃え、年齢を日本語の名前の横に表示
                            Center(
                              child: Column(
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        nameJapanese,
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Text(
                                          '($age)',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('$birthDate', style: _detailTextStyle()),
                                  SizedBox(width: 10),
                                  Text('$birthPlace出身',
                                      style: _detailTextStyle()),
                                ],
                              ),
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('$height cm', style: _detailTextStyle()),
                                  SizedBox(width: 10),
                                  Text('/ $weight kg',
                                      style: _detailTextStyle()),
                                ],
                              ),
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('B: $bust', style: _detailTextStyle()),
                                  SizedBox(width: 10),
                                  Text('W: $waist', style: _detailTextStyle()),
                                  SizedBox(width: 10),
                                  Text('H: $hip', style: _detailTextStyle()),
                                  SizedBox(width: 10),
                                  Text('S: $shoeSize',
                                      style: _detailTextStyle()),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '趣味: $hobby',
                              style: _detailTextStyle().copyWith(fontSize: 14),
                            ),
                            Text(
                              '特技: $skill',
                              style: _detailTextStyle().copyWith(fontSize: 14),
                            ),
                            Text(
                              '資格: $qualification',
                              style: _detailTextStyle().copyWith(fontSize: 14),
                            ),
                            Text(
                              '学歴: $education',
                              style: _detailTextStyle().copyWith(fontSize: 14),
                            ),
                            SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
                    // SNSの情報を白いボックスに表示
                    Positioned(
                      right: 20,
                      bottom: 120,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSNSInfo(
                              'Twitter',
                              '@$twitterAccount',
                              'assets/images/twitter_icon.png',
                            ),
                            _buildSNSInfo(
                              'TikTok',
                              '@$tiktokAccount',
                              'assets/images/tiktok_icon.png',
                            ),
                            _buildSNSInfo(
                              'Instagram',
                              '@$instagramAccount',
                              'assets/images/instagram_icon.png',
                            ),
                          ],
                        ),
                      ),
                    ),
                    // マネージャー情報
                    Positioned(
                      right: 20,
                      bottom: 20,
                      child: Container(
                        padding: EdgeInsets.all(12.0),
                        width: 280,
                        decoration: BoxDecoration(
                          color: Color(0xFFADD1F9),
                          borderRadius: BorderRadius.circular(1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '担当: $managerName',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                            Text(
                              'Email: $managerEmail',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                            Text(
                              'TEL: $managerPhone',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                            Text(
                              'Casting with: $agency',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Download button positioned at the top right
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

  TextStyle _detailTextStyle() {
    return TextStyle(
      fontSize: 16,
      color: Colors.black,
    );
  }

  Widget _buildSNSInfo(String platform, String account, String iconPath) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          width: 50,
          height: 50,
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            account,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

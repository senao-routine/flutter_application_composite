import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:html' as html;
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
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
    super.key,
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
  });

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  dynamic selectedIcon; // アイコン画像を保持

  // Method to capture the profile page as an image and download it
  Future<void> _captureAndSavePng() async {
    try {
      RenderRepaintBoundary boundary = widget._globalKey.currentContext!
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

      ScaffoldMessenger.of(widget._globalKey.currentContext!)
          .showSnackBar(const SnackBar(content: Text('画像を保存しました')));
    } catch (e) {
      print("キャプチャエラー: $e");
    }
  }

  // アイコンをアップロードするメソッド
  Future<void> _pickIcon() async {
    if (kIsWeb) {
      final html.FileUploadInputElement input = html.FileUploadInputElement()
        ..accept = 'image/*';
      input.click();
      await input.onChange.first;
      if (input.files!.isNotEmpty) {
        final file = input.files![0];
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        await reader.onLoad.first;
        setState(() {
          selectedIcon = reader.result;
        });
      }
    } else {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          selectedIcon = File(image.path);
        });
      }
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
        throw const FormatException('Unknown date format');
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
    int age = calculateAge(widget.birthDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // AppBarの背景を緑に設定
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('プロフィールページ', style: TextStyle(color: Colors.white)),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: _pickIcon,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'アイコンをアップロード',
                style: TextStyle(fontSize: 16, color: Colors.teal),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[300], // 背景色を灰色に変更
        child: Center(
          child: AspectRatio(
            aspectRatio: 3 / 4, // 3:4のアスペクト比に設定
            child: Stack(
              children: [
                RepaintBoundary(
                  key: widget
                      ._globalKey, // Assign the key to the RepaintBoundary
                  child: Stack(
                    children: [
                      // 背景画像があるかどうかをチェック
                      if (widget.backgroundImage != null) ...[
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: widget.backgroundImage is File
                                    ? FileImage(widget.backgroundImage)
                                    : NetworkImage(widget.backgroundImage),
                                fit: BoxFit.cover, // 背景画像をフルスクリーンに調整
                              ),
                            ),
                          ),
                        ),
                      ] else ...[
                        // 背景画像がない場合のメッセージ
                        const Center(
                          child: Text(
                            'アップロードされた写真がありません',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                      ],

                      // 左上にアイコンを表示
                      if (selectedIcon != null)
                        Positioned(
                          top: 20,
                          left: 20,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: selectedIcon is File
                                    ? FileImage(selectedIcon)
                                    : NetworkImage(selectedIcon),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                      // 名前〜趣味・特技を白いボックスに入れて左下に配置
                      Positioned(
                        left: 20,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          width: 260, // ボックスの幅を固定
                          height: 350, // 高さを378から350に減らしました
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
                                      widget.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.nameJapanese,
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 15.0),
                                          child: Text(
                                            '($age)',
                                            style: const TextStyle(
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
                              const SizedBox(height: 20),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(widget.birthDate,
                                        style: _detailTextStyle()),
                                    const SizedBox(width: 10),
                                    Text('${widget.birthPlace}出身',
                                        style: _detailTextStyle()),
                                  ],
                                ),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${widget.height} cm',
                                        style: _detailTextStyle()),
                                    const SizedBox(width: 10),
                                    Text('/ ${widget.weight} kg',
                                        style: _detailTextStyle()),
                                  ],
                                ),
                              ),
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('B: ${widget.bust}',
                                        style: _detailTextStyle()),
                                    const SizedBox(width: 10),
                                    Text('W: ${widget.waist}',
                                        style: _detailTextStyle()),
                                    const SizedBox(width: 10),
                                    Text('H: ${widget.hip}',
                                        style: _detailTextStyle()),
                                    const SizedBox(width: 10),
                                    Text('S: ${widget.shoeSize}',
                                        style: _detailTextStyle()),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '趣味: ${widget.hobby}',
                                style:
                                    _detailTextStyle().copyWith(fontSize: 14),
                              ),
                              Text(
                                '特技: ${widget.skill}',
                                style:
                                    _detailTextStyle().copyWith(fontSize: 14),
                              ),
                              Text(
                                '資格: ${widget.qualification}',
                                style:
                                    _detailTextStyle().copyWith(fontSize: 14),
                              ),
                              Text(
                                '学歴: ${widget.education}',
                                style:
                                    _detailTextStyle().copyWith(fontSize: 14),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                      // SNSの情報を白いボックスに表示
                      Positioned(
                        right: 20,
                        bottom: 120,
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
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
                                '@${widget.twitterAccount}',
                                'assets/images/twitter_icon.png',
                              ),
                              _buildSNSInfo(
                                'TikTok',
                                '@${widget.tiktokAccount}',
                                'assets/images/tiktok_icon.png',
                              ),
                              _buildSNSInfo(
                                'Instagram',
                                '@${widget.instagramAccount}',
                                'assets/images/instagram_icon.png',
                              ),
                            ],
                          ),
                        ),
                      ),
                      // マネージャー情報
                      Positioned(
                        right: 20,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.all(6.0),
                          width: 260,
                          height: 93,
                          decoration: BoxDecoration(
                            color: const Color(0xFFADD1F9),
                            borderRadius: BorderRadius.circular(1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '担当: ${widget.managerName}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                              Text(
                                'Email: ${widget.managerEmail}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                              Text(
                                'TEL: ${widget.managerPhone}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black),
                              ),
                              Text(
                                'Casting with: ${widget.agency}',
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.black),
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black.withOpacity(0.5),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: _captureAndSavePng,
                    child: Icon(Icons.download, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _detailTextStyle() {
    return const TextStyle(
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
        const SizedBox(width: 10),
        Text(account),
      ],
    );
  }
}

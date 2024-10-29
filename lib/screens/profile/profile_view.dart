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
  final String age;
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
    required this.age, // 年齢プロパティを追加
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

  String formatDate(String birthDate) {
    try {
      DateTime birth;

      if (birthDate.contains('/')) {
        List<String> parts = birthDate.split('/');
        birth = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      } else if (birthDate.contains('.')) {
        List<String> parts = birthDate.split('.');
        birth = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
      } else {
        birth = DateTime.parse(birthDate);
      }

      // 日付を "yyyy年MM月dd日" 形式にフォーマット
      return "\${birth.year}年\${birth.month}月\${birth.day}日";
    } catch (e) {
      print("Date formatting error: $e");
      return "不明な日付";
    }
  }

  @override
  Widget build(BuildContext context) {
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
                'アイコン追加',
                style: TextStyle(fontSize: 14, color: Colors.teal),
              ),
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          bool isMobile = width < 600;

          return SingleChildScrollView(
            child: Container(
              color: Colors.grey[300],
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isMobile ? double.infinity : 600,
                  ),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Stack(
                      children: [
                        RepaintBoundary(
                          key: widget._globalKey,
                          child: Stack(
                            children: [
                              // 背景画像があるかどうかをチェック
                              if (widget.backgroundImage != null)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: widget.backgroundImage is File
                                            ? FileImage(widget.backgroundImage)
                                            : NetworkImage(
                                                widget.backgroundImage),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                const Center(
                                  child: Text(
                                    'アップロードされた写真がありません',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black),
                                  ),
                                ),

                              // 左上にアイコンを表示
                              if (selectedIcon != null)
                                Positioned(
                                  top: isMobile ? 10 : 20,
                                  left: isMobile ? 10 : 20,
                                  child: Container(
                                    width: isMobile ? 50 : 70,
                                    height: isMobile ? 50 : 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(0),
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
                                left: isMobile ? 8 : 10,
                                bottom: isMobile ? 10 : 10,
                                child: Container(
                                  width: isMobile ? 240 : 290, // スマホの場合は幅を固定
                                  height: isMobile ? 300 : 355, // スマホの場合は高さを調整

                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // 名前ローマ字と日本語を中央揃え、年齢を日本語の名前の横に表示
                                      Center(
                                        child: Column(
                                          children: [
                                            Text(
                                              widget.name,
                                              style: TextStyle(
                                                fontSize: isMobile ? 13 : 16,
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
                                                      const EdgeInsets.only(
                                                          top: 15.0),
                                                  child: Text(
                                                    '(${widget.age})',
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
                                        child: Column(
                                          children: [
                                            Wrap(
                                              alignment: WrapAlignment.center,
                                              spacing: 10.0,
                                              runSpacing: 0.6,
                                              children: [
                                                Text(widget.birthDate,
                                                    style: _detailTextStyle()
                                                        .copyWith(
                                                      fontSize:
                                                          isMobile ? 12 : 14,
                                                    )),
                                                const Text('/'),
                                                Text(widget.birthPlace,
                                                    style: _detailTextStyle()
                                                        .copyWith(
                                                      fontSize:
                                                          isMobile ? 12 : 14,
                                                    )),
                                              ],
                                            ),
                                            Wrap(
                                              alignment: WrapAlignment.center,
                                              spacing: 10.0,
                                              runSpacing: 0.6,
                                              children: [
                                                Text('${widget.height} cm',
                                                    style: _detailTextStyle()
                                                        .copyWith(
                                                      fontSize:
                                                          isMobile ? 12 : 14,
                                                    )),
                                                Text('/ ${widget.weight} kg',
                                                    style: _detailTextStyle()
                                                        .copyWith(
                                                      fontSize:
                                                          isMobile ? 12 : 14,
                                                    )),
                                              ],
                                            ),
                                            Wrap(
                                              alignment: WrapAlignment.center,
                                              spacing: 10.0,
                                              runSpacing: 0.6,
                                              children: [
                                                Text('B: ${widget.bust}',
                                                    style: _detailTextStyle()
                                                        .copyWith(
                                                      fontSize:
                                                          isMobile ? 12 : 14,
                                                    )),
                                                Text('W: ${widget.waist}',
                                                    style: _detailTextStyle()
                                                        .copyWith(
                                                      fontSize:
                                                          isMobile ? 12 : 14,
                                                    )),
                                                Text('H: ${widget.hip}',
                                                    style: _detailTextStyle()
                                                        .copyWith(
                                                      fontSize:
                                                          isMobile ? 12 : 14,
                                                    )),
                                                Text('S: ${widget.shoeSize}',
                                                    style: _detailTextStyle()
                                                        .copyWith(
                                                      fontSize:
                                                          isMobile ? 12 : 14,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '趣味: ${widget.hobby}',
                                        style: _detailTextStyle().copyWith(
                                            fontSize: isMobile ? 12 : 14),
                                      ),
                                      Text(
                                        '特技: ${widget.skill}',
                                        style: _detailTextStyle().copyWith(
                                            fontSize: isMobile ? 12 : 14),
                                      ),
                                      Text(
                                        '資格: ${widget.qualification}',
                                        style: _detailTextStyle().copyWith(
                                            fontSize: isMobile ? 12 : 14),
                                      ),
                                      Text(
                                        '学歴: ${widget.education}',
                                        style: _detailTextStyle().copyWith(
                                            fontSize: isMobile ? 12 : 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // SNSの情報を白いボックスに表示
                              Positioned(
                                right: 20,
                                bottom: isMobile ? 75 : 80,
                                child: Container(
                                  padding: const EdgeInsets.all(8.0),
                                  width: isMobile ? 160 : 190,
                                  height: isMobile ? 140 : 155,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildSNSInfo(
                                        'Twitter',
                                        '@${widget.twitterAccount}',
                                        'assets/images/twitter_icon.png',
                                        isMobile ? 40.0 : 45.0,
                                      ),
                                      _buildSNSInfo(
                                        'TikTok',
                                        '@${widget.tiktokAccount}',
                                        'assets/images/tiktok_icon.png',
                                        isMobile ? 40.0 : 45.0,
                                      ),
                                      _buildSNSInfo(
                                        'Instagram',
                                        '@${widget.instagramAccount}',
                                        'assets/images/instagram_icon.png',
                                        isMobile ? 40.0 : 45.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // マネージャー情報
                              Positioned(
                                right: 20,
                                bottom: isMobile ? 10 : 10,
                                child: Container(
                                  padding: const EdgeInsets.all(6.0),
                                  width: isMobile ? 220 : 260,
                                  height: isMobile ? 58 : 65,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFADD1F9),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '担当: ${widget.managerName}',
                                        style: TextStyle(
                                          fontSize: isMobile ? 8 : 9,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Email: ${widget.managerEmail}',
                                        style: TextStyle(
                                          fontSize: isMobile ? 8 : 9,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'TEL: ${widget.managerPhone}',
                                        style: TextStyle(
                                          fontSize: isMobile ? 8 : 9,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Casting with: ${widget.agency}',
                                        style: TextStyle(
                                          fontSize: isMobile ? 8 : 9,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
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
              ),
            ),
          );
        },
      ),
    );
  }

  TextStyle _detailTextStyle() {
    return const TextStyle(
      fontSize: 16,
      color: Colors.black,
    );
  }

  Widget _buildSNSInfo(
      String platform, String account, String iconPath, double iconSize) {
    return Row(
      children: [
        Image.asset(
          iconPath,
          width: iconSize,
          height: iconSize,
        ),
        const SizedBox(width: 10),
        Text(account),
      ],
    );
  }
}

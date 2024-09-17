import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:html' as html;

class ProfileView extends StatelessWidget {
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

  const ProfileView({
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

  // 年齢を計算するメソッド
  int calculateAge(String birthDate) {
    try {
      // 生年月日の形式が不明なため、ピリオドやスラッシュに対応する
      List<String> parts;
      if (birthDate.contains('.')) {
        parts = birthDate.split('.');
      } else if (birthDate.contains('/')) {
        parts = birthDate.split('/');
      } else {
        // 期待される形式でなければ、エラーハンドリング
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
    // 年齢の計算
    int age = calculateAge(birthDate);

    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: 3 / 4, // 3:4のアスペクト比に設定
          child: Stack(
            children: [
              // 背景画像
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
                                fontSize: 16, // ローマ字の名前をさらに小さく
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
                                    fontSize: 28, // 日本語の名前をさらに大きく
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center, // 中央揃え
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end, // 年齢を名前の横に揃える
                                    children: [
                                      SizedBox(width: 2), // 名前と年齢の間にスペースを追加
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 15.0), // 年齢を少し下にずらす
                                        child: Text(
                                          '($age)', // 年齢を表示
                                          style: TextStyle(
                                            fontSize: 15, // 年齢のフォントサイズ
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20), // 名前と生年月日の間に余白を追加
                      // 生年月日と出身を同じ行に表示し、中央揃え
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 中央揃え
                          children: [
                            Text('$birthDate', style: _detailTextStyle()),
                            SizedBox(width: 10),
                            Text('$birthPlace出身', style: _detailTextStyle()),
                          ],
                        ),
                      ),
                      // 身長と体重を同じ行に表示し、中央揃え
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 中央揃え
                          children: [
                            Text('$height cm', style: _detailTextStyle()),
                            SizedBox(width: 10),
                            Text('/ $weight kg', style: _detailTextStyle()),
                          ],
                        ),
                      ),
                      // BWHと靴のサイズを同じ行に表示し、中央揃え
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 中央揃え
                          children: [
                            Text('B: $bust', style: _detailTextStyle()),
                            SizedBox(width: 10),
                            Text('W: $waist', style: _detailTextStyle()),
                            SizedBox(width: 10),
                            Text('H: $hip', style: _detailTextStyle()),
                            SizedBox(width: 10),
                            Text('S: $shoeSize', style: _detailTextStyle()),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        '趣味: $hobby',
                        style: _detailTextStyle()
                            .copyWith(fontSize: 14), // フォントサイズを12に変更
                      ),
                      Text(
                        '特技: $skill',
                        style: _detailTextStyle()
                            .copyWith(fontSize: 14), // フォントサイズを12に変更
                      ),
                      Text(
                        '資格: $qualification',
                        style: _detailTextStyle()
                            .copyWith(fontSize: 14), // フォントサイズを12に変更
                      ),
                      Text(
                        '学歴: $education',
                        style: _detailTextStyle()
                            .copyWith(fontSize: 14), // フォントサイズを12に変更
                      ),

                      SizedBox(height: 100), // キャッチフレーズ用の固定スペース
                    ],
                  ),
                ),
              ),
              // SNSの情報を白いボックスに表示
              Positioned(
                right: 20,
                bottom: 120, // マネージャー情報を追加するために少し上に配置
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  width: 200, // ボックスの幅を固定
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 左揃え
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
                  width: 280, // ボックスの幅を固定
                  decoration: BoxDecoration(
                    color: Color(0xFFADD1F9),
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '担当: $managerName',
                        style: TextStyle(
                            fontSize: 12, color: Colors.black), // サイズを小さく
                      ),
                      Text(
                        'Email: $managerEmail',
                        style: TextStyle(
                            fontSize: 12, color: Colors.black), // サイズを小さく
                      ),
                      Text(
                        'TEL: $managerPhone',
                        style: TextStyle(
                            fontSize: 12, color: Colors.black), // サイズを小さく
                      ),
                      Text(
                        'Casting with: $agency',
                        style: TextStyle(
                            fontSize: 12, color: Colors.black), // サイズを小さく
                      ),
                    ],
                  ),
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
        // アイコンをさらに大きく表示
        Image.asset(
          iconPath,
          width: 50, // アイコンのサイズをさらに大きく
          height: 50,
        ),
        SizedBox(width: 10),
        // アカウント名を大きく表示
        Expanded(
          child: Text(
            account,
            style: TextStyle(
              fontSize: 13, // アカウント名のサイズをさらに大きく
              color: Colors.black,
            ),
            overflow: TextOverflow.ellipsis, // 長いアカウント名を省略
          ),
        ),
      ],
    );
  }
}

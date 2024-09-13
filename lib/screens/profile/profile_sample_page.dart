import 'package:flutter/material.dart';
import 'dart:io';

class ProfileSamplePage extends StatelessWidget {
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
  final String catchphrase;
  final String followers;
  final String twitterAccount;
  final String tiktokAccount;
  final String instagramAccount;
  final String managerName;
  final String managerEmail;
  final String managerPhone;
  final String agency;
  final dynamic backgroundImage; // 背景画像用の変数

  ProfileSamplePage({
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
    required this.catchphrase,
    required this.followers,
    required this.twitterAccount,
    required this.tiktokAccount,
    required this.instagramAccount,
    required this.managerName,
    required this.managerEmail,
    required this.managerPhone,
    required this.agency,
    this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('プロフィールサンプルページ'),
      ),
      body: Stack(
        children: [
          if (backgroundImage != null) // 背景画像が設定されている場合に表示
            Positioned.fill(
              child: backgroundImage is String
                  ? Image.network(
                      backgroundImage,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      backgroundImage as File,
                      fit: BoxFit.cover,
                    ),
            ),
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('名前: $name', style: TextStyle(color: Colors.white)),
                  Text('名前（日本語）: $nameJapanese',
                      style: TextStyle(color: Colors.white)),
                  Text('生年月日: $birthDate',
                      style: TextStyle(color: Colors.white)),
                  Text('出身地: $birthPlace',
                      style: TextStyle(color: Colors.white)),
                  Text('身長: $height', style: TextStyle(color: Colors.white)),
                  Text('体重: $weight', style: TextStyle(color: Colors.white)),
                  Text('バスト: $bust', style: TextStyle(color: Colors.white)),
                  Text('ウエスト: $waist', style: TextStyle(color: Colors.white)),
                  Text('ヒップ: $hip', style: TextStyle(color: Colors.white)),
                  Text('靴のサイズ: $shoeSize',
                      style: TextStyle(color: Colors.white)),
                  Text('趣味: $hobby', style: TextStyle(color: Colors.white)),
                  Text('特技: $skill', style: TextStyle(color: Colors.white)),
                  Text('資格: $qualification',
                      style: TextStyle(color: Colors.white)),
                  Text('学歴: $education', style: TextStyle(color: Colors.white)),
                  Text('キャッチフレーズ: $catchphrase',
                      style: TextStyle(color: Colors.white)),
                  Text('フォロワー数: $followers',
                      style: TextStyle(color: Colors.white)),
                  Text('Twitterアカウント: $twitterAccount',
                      style: TextStyle(color: Colors.white)),
                  Text('TikTokアカウント: $tiktokAccount',
                      style: TextStyle(color: Colors.white)),
                  Text('Instagramアカウント: $instagramAccount',
                      style: TextStyle(color: Colors.white)),
                  Text('マネージャー名: $managerName',
                      style: TextStyle(color: Colors.white)),
                  Text('マネージャーEmail: $managerEmail',
                      style: TextStyle(color: Colors.white)),
                  Text('マネージャー電話番号: $managerPhone',
                      style: TextStyle(color: Colors.white)),
                  Text('所属事務所: $agency', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

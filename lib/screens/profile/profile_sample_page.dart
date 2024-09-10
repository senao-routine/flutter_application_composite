// profile_sample_page.dart
import 'package:flutter/material.dart';

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

  const ProfileSamplePage({
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
    required this.catchphrase,
    required this.followers,
    required this.twitterAccount,
    required this.tiktokAccount,
    required this.instagramAccount,
    required this.managerName,
    required this.managerEmail,
    required this.managerPhone,
    required this.agency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('プロフィールサンプルページ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('名前: $name'),
            Text('名前（日本語）: $nameJapanese'),
            Text('生年月日: $birthDate'),
            Text('出身地: $birthPlace'),
            Text('身長: $height'),
            Text('体重: $weight'),
            Text('バスト: $bust'),
            Text('ウエスト: $waist'),
            Text('ヒップ: $hip'),
            Text('靴のサイズ: $shoeSize'),
            Text('趣味: $hobby'),
            Text('特技: $skill'),
            Text('資格: $qualification'),
            Text('学歴: $education'),
            Text('キャッチフレーズ: $catchphrase'),
            Text('フォロワー数: $followers'),
            Text('Twitterアカウント: $twitterAccount'),
            Text('TikTokアカウント: $tiktokAccount'),
            Text('Instagramアカウント: $instagramAccount'),
            Text('マネージャー名: $managerName'),
            Text('マネージャーEmail: $managerEmail'),
            Text('マネージャー電話番号: $managerPhone'),
            Text('所属事務所: $agency'),
          ],
        ),
      ),
    );
  }
}

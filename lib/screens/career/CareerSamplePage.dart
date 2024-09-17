import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:html' as html;

class CareerView extends StatelessWidget {
  final List<Map<String, List<String>>> careerList; // キャリア情報
  final dynamic backgroundImage; // キャリアの背景画像

  const CareerView({
    Key? key,
    required this.careerList,
    required this.backgroundImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Careerページ'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 3 / 4, // 3:4のアスペクト比
          child: Stack(
            children: [
              // 背景画像がある場合とない場合の処理
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
                // 白い半透明のテキストボックス
                Positioned(
                  top: 80,
                  left: 30,
                  right: 30,
                  bottom: 40,
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8), // 半透明の白
                      borderRadius: BorderRadius.circular(1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildCareerTitle(context),
                        SizedBox(height: 20),
                        Expanded(child: _buildCareerDetails(context)),
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
      ),
    );
  }

  Widget _buildCareerTitle(BuildContext context) {
    return Row(
      children: [
        // キャリアセクションのタイトル
        Text(
          "Career",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildCareerDetails(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: careerList
            .asMap()
            .entries
            .map((entry) => _buildCareerCategory(entry.key, entry.value))
            .toList(),
      ),
    );
  }

  // キャリアカテゴリーごとの表示
  Widget _buildCareerCategory(int index, Map<String, List<String>> category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.keys.first, // カテゴリー名
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        ...category.values.first.map((item) => Text(
              item, // 各項目
              style: TextStyle(fontSize: 16, color: Colors.black),
            )),
        SizedBox(height: 20),
      ],
    );
  }
}

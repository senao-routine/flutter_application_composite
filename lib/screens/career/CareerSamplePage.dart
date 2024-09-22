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
          child: LayoutBuilder(
            builder: (context, constraints) {
              // 表示エリアの高さを計算
              double availableHeight = constraints.maxHeight - 160; // 上下の余白を引く

              // 1行あたりの推定高さを設定（適宜調整）
              double lineHeight = 24.0; // 各行の推定高さ
              int maxLines = (availableHeight / lineHeight).floor(); // 最大行数を計算

              return Stack(
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
                    // レイアウトを変更してテキストボックスの高さを文字数に応じて調整
                    SingleChildScrollView(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 80, horizontal: 30),
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
                              _buildCareerDetails(context, maxLines),
                            ],
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
                ],
              );
            },
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

  Widget _buildCareerDetails(BuildContext context, int maxLines) {
    int totalLines = 0;
    List<Widget> careerDetails = [];

    for (var entry in careerList) {
      if (totalLines >= maxLines) break; // 最大行数でストップ
      careerDetails.add(
        Text(
          '【${entry.keys.first}】', // カテゴリー名を【】で囲む
          style: TextStyle(
            fontSize: 18, // 文字の大きさを小さく
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      );
      totalLines++;

      for (var item in entry.values.first) {
        if (totalLines >= maxLines) break; // 最大行数でストップ
        careerDetails.add(
          Text(
            item, // 各項目
            style: TextStyle(fontSize: 14, color: Colors.black), // 文字サイズを小さく
          ),
        );
        totalLines++;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: careerDetails,
    );
  }
}

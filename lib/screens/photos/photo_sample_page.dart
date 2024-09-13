import 'package:flutter/material.dart';

class PhotoPage extends StatelessWidget {
  final List<dynamic> photos;

  PhotoPage({required this.photos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photoページ'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: photos.isEmpty
            ? Center(child: Text('アップロードされた写真がありません'))
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3列で表示
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: photos.length > 6 ? 6 : photos.length, // 最大6枚表示
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: photo is String
                        ? Image.network(
                            photo,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            photo,
                            fit: BoxFit.cover,
                          ),
                  );
                },
              ),
      ),
    );
  }
}

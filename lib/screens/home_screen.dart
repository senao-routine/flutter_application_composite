import 'package:flutter/material.dart';
import 'package:composite_app/fixed_size_view.dart';
import 'package:composite_app/screens/career/career_view.dart';
import 'package:composite_app/screens/photos/photos_view.dart';
import 'package:composite_app/screens/profile/profile_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    FixedSizeView(
      child: ProfileView(
        name: 'John Doe',
        nameJapanese: 'ジョン・ドー',
        birthDate: '1990-01-01',
        birthPlace: 'Tokyo',
        height: '180cm',
        weight: '70kg',
        bust: '90cm',
        waist: '70cm', // ここでwaistも渡す
        hip: '95cm',
        shoeSize: '27cm',
        hobby: '読書',
        skill: 'プログラミング',
        qualification: '英検1級',
        education: '東京大学',
        catchphrase: 'チャレンジ精神',
        followers: '10000',
        twitterAccount: '@johndoe',
        tiktokAccount: '@johndoe',
        instagramAccount: '@johndoe',
        managerName: '田中 太郎',
        managerEmail: 'tanaka@example.com',
        managerPhone: '080-1234-5678',
        agency: 'XYZプロダクション',
        backgroundImage: null, // ここで背景画像も渡せる
      ),
    ),
    FixedSizeView(child: CareerView()),
    FixedSizeView(child: PhotosView()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Talent Composite'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Career',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: 'Photos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

class InputFormView extends StatefulWidget {
  @override
  _InputFormViewState createState() => _InputFormViewState();
}

class _InputFormViewState extends State<InputFormView> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  List<dynamic> photos = []; // XFile or File

  // プロフィール情報
  String? name;
  String? nameJapanese;
  String? birthDate;
  String? birthPlace;
  String? height;
  String? weight;
  String? bust;
  String? waist;
  String? hip;
  String? shoeSize;
  String? hobby;
  String? skill;
  String? qualification;
  String? education;
  String? catchphrase;
  String? followers;
  String? twitterAccount;
  String? tiktokAccount;
  String? instagramAccount;
  String? managerName;
  String? managerEmail;
  String? managerPhone;
  String? agency;

  // キャリア情報
  List<Map<String, List<String>>> careerList = [];

  Future<void> _pickImage() async {
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
          photos.add(reader.result);
        });
      }
    } else {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        String savedImagePath = await _saveImageToTempDirectory(image);
        setState(() {
          photos.add(File(savedImagePath));
        });
      }
    }
  }

  Future<String> _saveImageToTempDirectory(XFile image) async {
    final directory = await getTemporaryDirectory();
    final imageName = path.basename(image.path);
    final savedImage =
        await File(image.path).copy('${directory.path}/$imageName');
    return savedImage.path;
  }

  void _addCareerCategory() {
    setState(() {
      careerList.add({'': []});
    });
  }

  void _addCareerItem(int categoryIndex) {
    setState(() {
      careerList[categoryIndex].values.first.add('');
    });
  }

  void _updateCategoryName(int index, String newName) {
    setState(() {
      String oldName = careerList[index].keys.first;
      careerList[index] = {newName: careerList[index][oldName]!};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('タレントプロフィール入力'),
        elevation: 0,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(primary: Colors.blue),
        ),
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _currentStep,
          onStepTapped: (step) => setState(() => _currentStep = step),
          onStepContinue: () {
            if (_currentStep < 6) {
              setState(() => _currentStep += 1);
            } else {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('プロフィールが保存されました')),
                );
              }
            }
          },
          onStepCancel:
              _currentStep > 0 ? () => setState(() => _currentStep -= 1) : null,
          steps: [
            Step(
              title: Text('基本情報'),
              content: _buildCenteredForm(_buildBasicInfoForm()),
              isActive: _currentStep >= 0,
            ),
            Step(
              title: Text('身体情報'),
              content: _buildCenteredForm(_buildPhysicalInfoForm()),
              isActive: _currentStep >= 1,
            ),
            Step(
              title: Text('経歴・特技'),
              content: _buildCenteredForm(_buildSkillsAndEducationForm()),
              isActive: _currentStep >= 2,
            ),
            Step(
              title: Text('SNS情報'),
              content: _buildCenteredForm(_buildSNSInfoForm()),
              isActive: _currentStep >= 3,
            ),
            Step(
              title: Text('マネージャー情報'),
              content: _buildCenteredForm(_buildManagerInfoForm()),
              isActive: _currentStep >= 4,
            ),
            Step(
              title: Text('キャリア情報'),
              content: _buildCenteredForm(_buildCareerForm()),
              isActive: _currentStep >= 5,
            ),
            Step(
              title: Text('写真'),
              content: _buildCenteredForm(_buildPhotoForm()),
              isActive: _currentStep >= 6,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenteredForm(Widget form) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          constraints: BoxConstraints(maxWidth: 600),
          child: form,
        ),
      ),
    );
  }

  Widget _buildBasicInfoForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildTextField('名前（ローマ字）', Icons.person, (value) => name = value),
          _buildTextField(
              '名前（日本語）', Icons.person_outline, (value) => nameJapanese = value),
          _buildTextField('生年月日', Icons.cake, (value) => birthDate = value),
          _buildTextField(
              '出身地', Icons.location_on, (value) => birthPlace = value),
        ],
      ),
    );
  }

  Widget _buildPhysicalInfoForm() {
    return Column(
      children: [
        _buildTextField('身長', Icons.height, (value) => height = value),
        _buildTextField('体重', Icons.monitor_weight, (value) => weight = value),
        _buildTextField('バスト', Icons.person, (value) => bust = value),
        _buildTextField('ウエスト', Icons.person, (value) => waist = value),
        _buildTextField('ヒップ', Icons.person, (value) => hip = value),
        _buildTextField(
            '靴のサイズ', Icons.shopping_bag, (value) => shoeSize = value),
      ],
    );
  }

  Widget _buildSkillsAndEducationForm() {
    return Column(
      children: [
        _buildTextField('趣味', Icons.favorite, (value) => hobby = value),
        _buildTextField('特技', Icons.star, (value) => skill = value),
        _buildTextField('資格', Icons.school, (value) => qualification = value),
        _buildTextField('学歴', Icons.school, (value) => education = value),
        _buildTextField(
            'キャッチフレーズ', Icons.catching_pokemon, (value) => catchphrase = value),
      ],
    );
  }

  Widget _buildSNSInfoForm() {
    return Column(
      children: [
        _buildTextField('フォロワー数', Icons.people, (value) => followers = value),
        _buildTextField('Twitterアカウント', Icons.alternate_email,
            (value) => twitterAccount = value),
        _buildTextField('TikTokアカウント', Icons.alternate_email,
            (value) => tiktokAccount = value),
        _buildTextField('Instagramアカウント', Icons.alternate_email,
            (value) => instagramAccount = value),
      ],
    );
  }

  Widget _buildManagerInfoForm() {
    return Column(
      children: [
        _buildTextField(
            'マネージャー名', Icons.person, (value) => managerName = value),
        _buildTextField(
            'マネージャーEmail', Icons.email, (value) => managerEmail = value),
        _buildTextField(
            'マネージャー電話番号', Icons.phone, (value) => managerPhone = value),
        _buildTextField('所属事務所', Icons.business, (value) => agency = value),
      ],
    );
  }

  Widget _buildTextField(
      String label, IconData icon, Function(String?) onSaved) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(icon),
          border: OutlineInputBorder(),
        ),
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildCareerForm() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _addCareerCategory,
          child: Text('新しいカテゴリーを追加'),
        ),
        SizedBox(height: 16),
        ...careerList.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, List<String>> category = entry.value;
          String categoryName = category.keys.first;
          List<String> items = category.values.first;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: categoryName,
                decoration: InputDecoration(
                  labelText: 'カテゴリー名',
                  hintText: 'カテゴリー名を入力してください',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _updateCategoryName(index, value),
              ),
              SizedBox(height: 8),
              ...items.asMap().entries.map((itemEntry) {
                int itemIndex = itemEntry.key;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: TextFormField(
                    initialValue: itemEntry.value,
                    decoration: InputDecoration(
                      labelText: '項目 ${itemIndex + 1}',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        careerList[index][categoryName]![itemIndex] = value;
                      });
                    },
                  ),
                );
              }).toList(),
              ElevatedButton(
                onPressed: () => _addCareerItem(index),
                child: Text('項目を追加'),
              ),
              SizedBox(height: 16),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPhotoForm() {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: Icon(Icons.add_a_photo),
          label: Text('写真を追加'),
          onPressed: _pickImage,
        ),
        SizedBox(height: 16),
        photos.isEmpty
            ? Text('写真が選択されていません')
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: photos.map((photo) {
                  if (kIsWeb) {
                    return Image.network(
                      photo,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  } else {
                    return Image.file(
                      photo,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    );
                  }
                }).toList(),
              ),
      ],
    );
  }
}

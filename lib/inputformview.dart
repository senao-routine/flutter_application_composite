import 'package:composite_app/screens/career/CareerSamplePage.dart';
import 'package:composite_app/screens/photos/photo_sample_page.dart';
import 'package:composite_app/screens/profile/profile_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:html' as html;
import 'package:path/path.dart' as path;

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class InputFormView extends StatefulWidget {
  const InputFormView({super.key});

  @override
  _InputFormViewState createState() => _InputFormViewState();
}

class _InputFormViewState extends State<InputFormView> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  List<dynamic> photos = [];
  dynamic backgroundImage;
  dynamic careerBackgroundImage; // キャリア情報用の背景画像

  // 各フィールド用のコントローラ
  TextEditingController nameController = TextEditingController();
  TextEditingController nameJapaneseController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController birthPlaceController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController bustController = TextEditingController();
  TextEditingController waistController = TextEditingController();
  TextEditingController hipController = TextEditingController();
  TextEditingController shoeSizeController = TextEditingController();
  TextEditingController hobbyController = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  TextEditingController twitterAccountController = TextEditingController();
  TextEditingController tiktokAccountController = TextEditingController();
  TextEditingController instagramAccountController = TextEditingController();
  TextEditingController managerNameController = TextEditingController();
  TextEditingController managerEmailController = TextEditingController();
  TextEditingController managerPhoneController = TextEditingController();
  TextEditingController agencyController = TextEditingController();

  // キャリア情報
  List<Map<String, List<String>>> careerList = [];

  // 写真をアップロードするメソッド
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
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        String savedImagePath = await _saveImageToTempDirectory(image);
        setState(() {
          photos.add(File(savedImagePath));
        });
      }
    }
  }

  // 画像を保存するメソッド
  Future<String> _saveImageToTempDirectory(XFile image) async {
    final directory = await getTemporaryDirectory();
    final imageName = path.basename(image.path);
    final savedImage =
        await File(image.path).copy('${directory.path}/$imageName');
    return savedImage.path;
  }

  // プロフィールページ用の背景画像を選択するメソッド
  Future<void> _pickBackgroundImage() async {
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
          backgroundImage = reader.result;
        });
      }
    } else {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        String savedImagePath = await _saveImageToTempDirectory(image);
        setState(() {
          backgroundImage = File(savedImagePath);
        });
      }
    }
  }

  // キャリアページ用の背景画像を選択するメソッド
  Future<void> _pickCareerBackgroundImage() async {
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
          careerBackgroundImage = reader.result;
        });
      }
    } else {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        String savedImagePath = await _saveImageToTempDirectory(image);
        setState(() {
          careerBackgroundImage = File(savedImagePath);
        });
      }
    }
  }

  // プロフィールページに遷移するメソッド
  void _goToProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileView(
          name: nameController.text,
          nameJapanese: nameJapaneseController.text,
          birthDate: birthDateController.text,
          birthPlace: birthPlaceController.text,
          height: heightController.text,
          weight: weightController.text,
          bust: bustController.text,
          waist: waistController.text,
          hip: hipController.text,
          shoeSize: shoeSizeController.text,
          hobby: hobbyController.text,
          skill: skillController.text,
          qualification: qualificationController.text,
          education: educationController.text,
          twitterAccount: twitterAccountController.text,
          tiktokAccount: tiktokAccountController.text,
          instagramAccount: instagramAccountController.text,
          managerName: managerNameController.text,
          managerEmail: managerEmailController.text,
          managerPhone: managerPhoneController.text,
          agency: agencyController.text,
          backgroundImage: backgroundImage, // プロフィールの背景画像
        ),
      ),
    );
  }

  // キャリアサンプルページに遷移するメソッド
  void _goToCareerPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CareerView(
          careerList: careerList, // キャリア情報を渡す
          backgroundImage: careerBackgroundImage, // キャリアの背景画像
        ),
      ),
    );
  }

  // Photoページに遷移するメソッド
  void _goToPhotoPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoPage(
          photos: photos, // 写真リストを渡す
        ),
      ),
    );
  }

  // 日付選択のダイアログを表示するメソッド
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale("ja"), // 日本語設定
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        birthDateController.text =
            "${picked.year}.${picked.month}.${picked.day}"; // 西暦.月.日形式
      });
    }
  }

  // 現在のキャリア行数を計算するメソッド
  int _calculateTotalLines() {
    int totalLines = 0;
    for (var category in careerList) {
      totalLines += category.values.first.length; // 各カテゴリー内の項目数を合計
    }
    return totalLines;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タレントプロフィール入力'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(primary: Colors.blue),
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
                        const SnackBar(content: Text('プロフィールが保存されました')),
                      );
                    }
                  }
                },
                onStepCancel: _currentStep > 0
                    ? () => setState(() => _currentStep -= 1)
                    : null,
                steps: [
                  Step(
                    title: const Text('基本情報'),
                    content: _buildCenteredForm(_buildBasicInfoForm()),
                    isActive: _currentStep >= 0,
                  ),
                  Step(
                    title: const Text('身体情報'),
                    content: _buildCenteredForm(_buildPhysicalInfoForm()),
                    isActive: _currentStep >= 1,
                  ),
                  Step(
                    title: const Text('経歴・特技'),
                    content: _buildCenteredForm(_buildSkillsAndEducationForm()),
                    isActive: _currentStep >= 2,
                  ),
                  Step(
                    title: const Text('SNS情報'),
                    content: _buildCenteredForm(_buildSNSInfoForm()),
                    isActive: _currentStep >= 3,
                  ),
                  Step(
                    title: const Text('マネージャー情報'),
                    content: _buildCenteredForm(_buildManagerInfoForm()),
                    isActive: _currentStep >= 4,
                  ),
                  Step(
                    title: const Text('キャリア情報'),
                    content: _buildCenteredForm(_buildCareerForm()),
                    isActive: _currentStep >= 5,
                  ),
                  Step(
                    title: const Text('写真'),
                    content: _buildCenteredForm(_buildPhotoForm()),
                    isActive: _currentStep >= 6,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _goToProfilePage,
                  child: const Text('プロフィールページを表示'),
                ),
                ElevatedButton(
                  onPressed: _goToCareerPage,
                  child: const Text('キャリアページを表示'),
                ),
                ElevatedButton(
                  onPressed: _goToPhotoPage, // Photoページに遷移
                  child: const Text('Photoページを表示'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenteredForm(Widget form) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          constraints: const BoxConstraints(maxWidth: 600),
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
          _buildTextField('名前（ローマ字）', Icons.person, nameController),
          _buildTextField(
              '名前（日本語）', Icons.person_outline, nameJapaneseController),
          // 生年月日の選択ウィジェット
          GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: TextFormField(
                controller: birthDateController,
                decoration: const InputDecoration(
                  labelText: '生年月日',
                  icon: Icon(Icons.cake),
                ),
              ),
            ),
          ),
          _buildTextField('出身', Icons.location_on, birthPlaceController),
          // 背景画像選択ボタンを追加
          ElevatedButton(
            onPressed: _pickBackgroundImage,
            child: const Text('プロフィールページの背景画像を選択'),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalInfoForm() {
    return Column(
      children: [
        _buildTextField('身長', Icons.height, heightController),
        _buildTextField('体重', Icons.monitor_weight, weightController),
        _buildTextField('バスト', Icons.person, bustController),
        _buildTextField('ウエスト', Icons.person, waistController),
        _buildTextField('ヒップ', Icons.person, hipController),
        _buildTextField('靴のサイズ', Icons.shopping_bag, shoeSizeController),
      ],
    );
  }

  Widget _buildSkillsAndEducationForm() {
    return Column(
      children: [
        _buildTextFieldWithLimit('趣味', Icons.favorite, hobbyController),
        _buildTextFieldWithLimit('特技', Icons.star, skillController),
        _buildTextFieldWithLimit('資格', Icons.school, qualificationController),
        _buildTextField(
            '学歴', Icons.school, educationController), // 学歴は特に文字制限を加えない
      ],
    );
  }

  Widget _buildTextFieldWithLimit(
      String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(icon),
          hintText: '30文字以内で入力してください', // ここで注意書きを表示
          border: const OutlineInputBorder(),
        ),
        maxLength: 30, // 文字制限を追加
      ),
    );
  }

  Widget _buildSNSInfoForm() {
    return Column(
      children: [
        _buildTextField(
            'Twitterアカウント', Icons.alternate_email, twitterAccountController),
        _buildTextField(
            'TikTokアカウント', Icons.alternate_email, tiktokAccountController),
        _buildTextField('Instagramアカウント', Icons.alternate_email,
            instagramAccountController),
      ],
    );
  }

  Widget _buildManagerInfoForm() {
    return Column(
      children: [
        _buildTextField('マネージャー名', Icons.person, managerNameController),
        _buildTextField('マネージャーEmail', Icons.email, managerEmailController),
        _buildTextField('マネージャー電話番号', Icons.phone, managerPhoneController),
        _buildTextField('所属事務所', Icons.business, agencyController),
      ],
    );
  }

  Widget _buildTextField(
      String label, IconData icon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          icon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildCareerForm() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            // キャリア全体の行数が20行以内なら新しいカテゴリーを追加
            if (_calculateTotalLines() < 20) {
              setState(() {
                careerList.add({'新しいカテゴリー': []});
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('最大20行までしか入力できません')),
              );
            }
          },
          child: const Text('新しいカテゴリーを追加'),
        ),

        const SizedBox(height: 16),
        for (var entry in careerList.asMap().entries)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'カテゴリー名'),
                    initialValue: entry.value.keys.first,
                    onChanged: (value) {
                      setState(() {
                        var items = careerList[entry.key]
                            .remove(entry.value.keys.first)!;
                        careerList[entry.key] = {value: items};
                      });
                    },
                  ),
                  for (var item in entry.value.values.first.asMap().entries)
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: '項目 ${item.key + 1}'),
                              initialValue: item.value,
                              onChanged: (value) {
                                setState(() {
                                  careerList[entry.key]
                                          [entry.value.keys.first]![item.key] =
                                      value;
                                });
                              },
                            ),
                          ),
                        ),
                        // 削除ボタンを追加
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.black),
                          onPressed: () {
                            setState(() {
                              careerList[entry.key][entry.value.keys.first]!
                                  .removeAt(item.key);
                            });
                          },
                        ),
                      ],
                    ),
                  ElevatedButton(
                    onPressed: () {
                      // キャリア全体の行数が20行以内なら項目を追加
                      if (_calculateTotalLines() < 20) {
                        setState(() {
                          careerList[entry.key][entry.value.keys.first]!
                              .add('');
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('最大20行までしか入力できません')),
                        );
                      }
                    },
                    child: const Text('項目を追加'),
                  ),
                ],
              ),
            ),
          ),
        // キャリア背景画像選択ボタンを追加
        ElevatedButton(
          onPressed: _pickCareerBackgroundImage,
          child: const Text('キャリアページの背景画像を選択'),
        ),
      ],
    );
  }

  Widget _buildPhotoForm() {
    return Column(
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.add_a_photo),
          label: const Text('写真を追加'),
          onPressed: _pickImage,
        ),
        const SizedBox(height: 16),
        photos.isEmpty
            ? const Text('写真が選択されていません')
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

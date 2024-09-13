import 'package:composite_app/screens/career/CareerSamplePage';
import 'package:composite_app/screens/photos/photo_sample_page.dart';
import 'package:composite_app/screens/profile/profile_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'dart:html' as html;

class InputFormView extends StatefulWidget {
  @override
  _InputFormViewState createState() => _InputFormViewState();
}

class _InputFormViewState extends State<InputFormView> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  List<dynamic> photos = [];
  dynamic backgroundImage;

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
  TextEditingController catchphraseController = TextEditingController();
  TextEditingController followersController = TextEditingController();
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

  // 画像を保存するメソッド
  Future<String> _saveImageToTempDirectory(XFile image) async {
    final directory = await getTemporaryDirectory();
    final imageName = path.basename(image.path);
    final savedImage =
        await File(image.path).copy('${directory.path}/$imageName');
    return savedImage.path;
  }

  // 背景画像を選択するメソッド
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
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        String savedImagePath = await _saveImageToTempDirectory(image);
        setState(() {
          backgroundImage = File(savedImagePath);
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
          catchphrase: catchphraseController.text,
          followers: followersController.text,
          twitterAccount: twitterAccountController.text,
          tiktokAccount: tiktokAccountController.text,
          instagramAccount: instagramAccountController.text,
          managerName: managerNameController.text,
          managerEmail: managerEmailController.text,
          managerPhone: managerPhoneController.text,
          agency: agencyController.text,
          backgroundImage: backgroundImage, // 背景画像
        ),
      ),
    );
  }

  // キャリアサンプルページに遷移するメソッド
  void _goToCareerPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CareerSamplePage(
          careerList: careerList, // キャリア情報を渡す
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('タレントプロフィール入力'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Theme(
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
                onStepCancel: _currentStep > 0
                    ? () => setState(() => _currentStep -= 1)
                    : null,
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
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _goToProfilePage,
                  child: Text('プロフィールページを表示'),
                ),
                ElevatedButton(
                  onPressed: _goToCareerPage,
                  child: Text('キャリアページを表示'),
                ),
                ElevatedButton(
                  onPressed: _goToPhotoPage, // Photoページに遷移
                  child: Text('Photoページを表示'),
                ),
                ElevatedButton(
                  onPressed: _pickBackgroundImage,
                  child: Text('背景画像を選択'),
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
          _buildTextField('名前（ローマ字）', Icons.person, nameController),
          _buildTextField(
              '名前（日本語）', Icons.person_outline, nameJapaneseController),
          _buildTextField('生年月日', Icons.cake, birthDateController),
          _buildTextField('出身地', Icons.location_on, birthPlaceController),
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
        _buildTextField('趣味', Icons.favorite, hobbyController),
        _buildTextField('特技', Icons.star, skillController),
        _buildTextField('資格', Icons.school, qualificationController),
        _buildTextField('学歴', Icons.school, educationController),
        _buildTextField(
            'キャッチフレーズ', Icons.catching_pokemon, catchphraseController),
      ],
    );
  }

  Widget _buildSNSInfoForm() {
    return Column(
      children: [
        _buildTextField('フォロワー数', Icons.people, followersController),
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
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildCareerForm() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              careerList.add({'新しいカテゴリー': []});
            });
          },
          child: Text('新しいカテゴリーを追加'),
        ),
        SizedBox(height: 16),
        for (var entry in careerList.asMap().entries)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'カテゴリー名'),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextFormField(
                        decoration:
                            InputDecoration(labelText: '項目 ${item.key + 1}'),
                        initialValue: item.value,
                        onChanged: (value) {
                          setState(() {
                            careerList[entry.key]
                                [entry.value.keys.first]![item.key] = value;
                          });
                        },
                      ),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        careerList[entry.key][entry.value.keys.first]!.add('');
                      });
                    },
                    child: Text('項目を追加'),
                  ),
                ],
              ),
            ),
          ),
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

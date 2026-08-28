import 'package:assignment_7/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import '../controller/profile_controller.dart';
import '../controller/theme_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();

  final ProfileController controller = ProfileController();


  @override
  XFile? profileImage;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        profileImage = image;
      });
    }
  }

  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark
            ? Color(0xff061526)
            : Color(0xff052659),
        foregroundColor: Colors.white,
        title: const Text('Profile',style: TextStyle( fontSize: 30)),
      ),

      backgroundColor: isDark
          ? Color(0xff0B1D33)
          : Color(0xfffbf8f1),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: profileImage != null
                    ? FileImage(File(profileImage!.path))
                    : null,
                child: profileImage == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
            ),

            SizedBox(height: 30),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                hintText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 25),

            ElevatedButton(
              onPressed: () {
                controller.saveProfile(nameController.text, profileImage?.path);
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(theme: ThemeController())));
              },
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark
                    ? Color(0xff5483B3)
                    : Color(0xffd06536),
                foregroundColor: Colors.white,
                fixedSize: Size(150, 70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

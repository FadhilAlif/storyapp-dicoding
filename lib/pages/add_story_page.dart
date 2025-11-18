import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:storyapp_dicoding/providers/story_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:storyapp_dicoding/widgets/language_switcher_widget.dart';

class AddStoryPage extends StatefulWidget {
  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  XFile? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(tr('gallery_option')),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text(tr('camera_option')),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('add_story_title')),
        actions: const [LanguageSwitcherWidget()],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () => _showImageSourceActionSheet(context),
                child: _imageFile == null
                    ? Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo,
                                color: Colors.grey[600], size: 50),
                            const SizedBox(height: 8),
                            Text(
                              tr('choose_image_button'),
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(_imageFile!.path),
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: tr('description_label'),
                  hintText: 'Write something about your story...',
                  border: const OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr('error_description_empty');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Consumer<StoryProvider>(
                builder: (context, provider, child) {
                  return ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: provider.isUploading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate() &&
                                _imageFile != null) {
                              final result = await provider.addNewStory(
                                _descriptionController.text,
                                _imageFile!.path,
                              );
                              if (mounted) {
                                if (result) {
                                  context.go('/');
                                } else {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(
                                        content: Text(provider.uploadMessage),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                }
                              }
                            } else if (_imageFile == null) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Text(tr('error_no_image')),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                            }
                          },
                    icon: provider.isUploading
                        ? Container(
                            width: 24,
                            height: 24,
                            padding: const EdgeInsets.all(2.0),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Icon(Icons.upload),
                    label: Text(tr('upload_button')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

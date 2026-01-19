import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CustomImagePicker extends StatefulWidget {
  const CustomImagePicker({super.key});

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  File? _selectedImage;

  Future<void> pickImage() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image, // only pick image files
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedImage = File(result.files.single.path!);
      });
    }
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: pickImage,
        child: DottedBorder(
          options: RectDottedBorderOptions(
            dashPattern: [10, 5],
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.primaryContainer
          ),
          child: _selectedImage == null ? SizedBox(
            width: double.infinity,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 10,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.1),
                    child: Icon(Icons.upload, color: Theme.of(context).colorScheme.primaryContainer, size: 15,),
                ),
                Text('Upload Claim Document', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.primaryContainer),),
                Text('Format should be in .pdf .jpeg .png less than 5MB', style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ) : Image.file(
            _selectedImage!,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          _selectedImage != null
              ? Image.file(
            _selectedImage!,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          )
              : const Text('No image selected'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: pickImage,
            child: const Text('Select Image'),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:localstorage/localstorage.dart';

class CircularImageSelectionWidget extends StatefulWidget {
  final String text;

  CircularImageSelectionWidget({super.key, required this.text});

  @override
  _CircularImageSelectionWidgetState createState() => _CircularImageSelectionWidgetState();
}

class _CircularImageSelectionWidgetState extends State<CircularImageSelectionWidget> {
  File? _imageFile;

Future<void> _getImage(ImageSource source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.getImage(source: source);

  if (pickedFile != null) {
    final String imagePath = pickedFile.path;
    setState(() {
      _imageFile = File(imagePath);
      localStorage.setItem("latestImage", imagePath);
    });
  }
}

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("לצלם עכשיו"),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.camera);
                  localStorage.setItem("imagFromCamera", _imageFile!.path);
                },
              ),
              ListTile(
                leading:const Icon(Icons.photo_library),
                title:  const Text('לבחור מהגלריה'),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.gallery);
                },
              ),
                   ListTile(
                leading: const Icon(Icons.fullscreen),
                title: const Text('הצג תמונה מוגדלת'),
                onTap: () {
                  Navigator.of(context).pop();
                  if (_imageFile != null) {
                    _showFullScreenImage(context, _imageFile!.path);
                  } else {
                    final latestImagePath = localStorage.getItem("latestImage");
                    if (latestImagePath != null) {
                      _showFullScreenImage(context, latestImagePath);
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

    void _showFullScreenImage(BuildContext context, String imagePath) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FullScreenImage(imagePath: imagePath)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Center(child: Text(widget.text)),
        ),
        GestureDetector(
          onTap: () {
            _showImageSourceActionSheet(context);
          },
          child: CircleAvatar(
  radius: 27,
  backgroundColor: Colors.grey[300],
  backgroundImage: _imageFile != null
    ? FileImage(_imageFile!)
    : localStorage.getItem("latestImage") != null
      ? FileImage(File(localStorage.getItem("latestImage")!))
      : null,
  child: _imageFile == null && localStorage.getItem("latestImage") == null
    ? Icon(Icons.camera_alt, size: 30, color: Colors.grey[600])
    : null,
),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}


class FullScreenImage extends StatelessWidget {
  final String imagePath;

  FullScreenImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.file(
          File(imagePath),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
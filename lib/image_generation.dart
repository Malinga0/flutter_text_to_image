import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageGeneration extends StatefulWidget {
  const ImageGeneration({super.key});

  @override
  State<ImageGeneration> createState() => _ImageGenerationState();
}

class _ImageGenerationState extends State<ImageGeneration> {
  TextEditingController prompt = TextEditingController();
  Uint8List? imagebyte;
  bool isloading = false;
  Future<void> generateImage() async {
    setState(() {
      isloading = true;
    });
    try {
      const MYAPIKEY = '';
      final url = Uri.parse(
        "https://api.stability.ai/v2beta/stable-image/generate/ultra",
      );
      final headers = {
        "authorization": "Bearer $MYAPIKEY",
        "accept": "image/*",
      };
      final request =
          http.MultipartRequest('POST', url)
            ..headers.addAll(headers)
            ..fields['prompt'] = prompt.text
            ..fields['output_format'] = 'webp';

      final response = await request.send();

      if (response.statusCode == 200) {
        final byte = await response.stream.toBytes();
        setState(() {
          imagebyte = byte;
        });
      }
    } catch (e) {
      print(e);
    }
    setState(() {
      isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 28, 48),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Text to Image',
              style: TextStyle(color: Colors.white, fontSize: 36),
            ),
            SizedBox(height: size.height * .1),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
                  imagebyte == null
                      ? Image.asset('assets/place.jpeg', width: size.width * .6)
                      : Image.memory(imagebyte!, width: size.width * .6),
            ),
            SizedBox(height: size.height * .05),
            Container(
              margin: EdgeInsets.all(10),
              child: TextField(
                controller: prompt,
                maxLines: 5,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Enter Text',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            isloading
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: () {
                    if (!prompt.text.isEmpty) {
                      generateImage();
                    }
                  },
                  child: Text('Generate Image'),
                ),
          ],
        ),
      ),
    );
  }
}

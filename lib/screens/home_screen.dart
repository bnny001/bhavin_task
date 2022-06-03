import 'dart:html' as html;
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart' as Path;
import 'package:image_picker_web/image_picker_web.dart';
import 'package:file_picker/file_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isUploaded = false;
  bool isLoaded = false;
  List<ImageData> imageUrls = [];

  @override
  initState(){
    getImage();
  }


  getImage() async {

             print("${ FirebaseAuth.instance.currentUser!.uid}");
              final storageRef = FirebaseStorage.instance.ref().child("uploads/${FirebaseAuth.instance.currentUser!.uid}");
              final listResult = await storageRef.listAll();
              for (var prefix in listResult.prefixes) {
                print("prefix: ${prefix.fullPath}");
              }

              List<ImageData> urlList = [];
              for (var item in listResult.items) {
                var name = item.name;
                var url = await item.getDownloadURL();
                print("item url: ${url}");

                urlList.add(ImageData(fileName: name.toString(), fileUrl: url.toString()));
              }


              setState(() {
                imageUrls = urlList;
                isLoaded = true;

                isUploaded = false;
                
              });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bhavin"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            SizedBox(height: 60,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green
            ),
            onPressed: () async {
               setState(() {
                isUploaded = false;
              });

             

              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                Uint8List? fileBytes = result.files.first.bytes;
                String fileName = result.files.first.name;


                await FirebaseStorage.instance
                    .ref('uploads/${FirebaseAuth.instance.currentUser!.uid}/$fileName')
                    .putData(fileBytes!);
              }

              setState(() {
                isUploaded = true;
                isLoaded = false;
              });

              getImage();
            },
            child: Text("upload"),
          ),
          SizedBox(height: 60,),

          if(isUploaded == true)
          Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: new BorderRadius.circular(10.0),
                  ),
            child: Center(child: Text("Uploaded file", style: TextStyle(color: Colors.white),)),
          ),

          SizedBox(height: 60,),
          // ElevatedButton(
          //    style: ElevatedButton.styleFrom(
          //     primary: Colors.green
          //   ),
          //   onPressed: () async {


          //   },
          //   child: Text("get images"),
          // ),

          if(isLoaded == false)
          CircularProgressIndicator(),
          if (imageUrls.isNotEmpty && isLoaded == true)
           ListView.builder(
             shrinkWrap: true,
             itemCount: imageUrls.length,
             itemBuilder: (context, index){
               return  Container(
                 child: TextButton(onPressed: (){
                   html.window.open(imageUrls[index].fileUrl, '_blank');
                 },child: Text(imageUrls[index].fileName)),
              // child: Text(imageUrls[index].toString()),
            );
             })
        ]),
      ),
    );
  }
}





class ImageData{
  final String fileName;
  final String fileUrl;

  ImageData({required this.fileName, required this.fileUrl});
}
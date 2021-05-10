import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:good_deed/utils/layout.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerFormWidget extends StatefulWidget{
  final List<File> pictures;

  ImagePickerFormWidget({this.pictures});

  @override
  _ImagePickerFormWidgetState createState() => _ImagePickerFormWidgetState(defautSelection: pictures);
}

class _ImagePickerFormWidgetState extends State<ImagePickerFormWidget>{
  List<File> _pictures = [];
  File file;

  _ImagePickerFormWidgetState({List<File> defautSelection}){
    if(defautSelection != null){
      this._pictures.addAll(defautSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick images'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: this._pictures.length,
                itemBuilder: (BuildContext ctx, index){
                  return Card(
                    child: Column(
                      children: [
                        Image.file(this._pictures[index], height: 190, width: 190,),
                        ElevatedButton(
                          child: const Text('DELETE'),
                          onPressed: () {
                            setState(() {
                              this._pictures.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
          ),
          LayoutUtils.widenButton(
            ElevatedButton(
              onPressed: () {
                // Close the screen and return the selected images as the result.
                Navigator.pop(context, this._pictures);
              },
              child: Text('Confirm Image Selection'),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if(this._pictures.length < 5){
            ImagePicker picker = ImagePicker();
            var pickedFile = await picker.getImage(source: ImageSource.gallery);
            File file = File(pickedFile.path);

            //TODO make sure user can't select same image multiple times SEEMS IMPOSSIBLE as each selected image is cached and cannot be uniquely identified even if it's the same in the filesystem...
            if(_pictures.indexOf(file) > 0){  //_pictures.any((e) => e.absolute == file.absolute)
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Image already selected'),
                duration: const Duration(seconds: 3),
              ));
            } else {
              setState(() {
                _pictures.add(file);
              });
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('You have selected the maximum amount of images'),
              duration: const Duration(seconds: 3),
            ));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
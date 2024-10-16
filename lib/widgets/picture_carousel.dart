import 'package:flutter/material.dart';

class PictureCarouselWidget extends StatelessWidget {
  final List<String> imageUrls;
  final double imageDimensions;

  PictureCarouselWidget({Key key, this.imageUrls, this.imageDimensions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //https://www.javatpoint.com/flutter-slider Maybe use swiper? NO this would add another dependancy for no real reason...
    if(this.imageUrls != null && this.imageUrls.isNotEmpty){
      return Container(
        height: imageDimensions,
        child: Center(  //Makes layout cleaner when there aren't enough images to horizontally scroll through
          child: ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal, //Makes list horizontal
              itemCount: this.imageUrls.length,
              itemBuilder: (context, index) {
                return Container(
                  width: imageDimensions,
                  height: imageDimensions,
                  child: Image.network(this.imageUrls[index]),
                );
              }
          ),
        ),
      );
    } else {
      print("Y");
      return Container();
    }
  }
}

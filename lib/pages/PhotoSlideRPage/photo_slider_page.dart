import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:MysteryConnect/network/entity/photo.dart';
import 'package:MysteryConnect/utilities/constants.dart';

import '../../network/entity/user.dart';

class PhotoSliderPage extends StatefulWidget {
  const PhotoSliderPage({super.key, required this.user});
  final User user;
  @override
  State<PhotoSliderPage> createState() => _PhotoSliderPageState();
}

class _PhotoSliderPageState extends State<PhotoSliderPage> {
  @override
  Widget build(BuildContext context) {
    User user = widget.user;
    List<Photo> images = user.photoList;
    return SizedBox(
      height: MediaQuery.of(context).size.height - 10,
      width: MediaQuery.of(context).size.width - 10,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 5),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        child: CarouselSlider.builder(
          options: CarouselOptions(
            scrollDirection: Axis.horizontal,
            aspectRatio: 1.0,
            height: MediaQuery.of(context).size.height,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
          ),
          itemCount: images.length,
          itemBuilder: (context, index, realIndex) {
            return ImageCard(
              imageUrl:
                  "http://$baseIP/api/v1/photo/getPhotoById/${images[index].id}",
            );
          },
        ),
      ),
    );
  }
}

class ImageCard extends StatelessWidget {
  const ImageCard({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
      ),
    );
  }
}

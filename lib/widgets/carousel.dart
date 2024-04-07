// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:felix/models/topratedseries.dart';
import 'package:felix/pages/descriptionPage.dart';
import 'package:felix/utils.dart';
import 'package:flutter/material.dart';

class CustomCarouselSlider extends StatelessWidget {
  final TopRatedSeriesModel data;
  const CustomCarouselSlider({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
      child: CarouselSlider.builder(
        itemCount: data.results.length,
        itemBuilder: (context, index, count) {
          var url = data.results[index].backdropPath.toString();

          return GestureDetector(
              child: SingleChildScrollView(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DescriptionPage(
                      movieId: data.results[index].id,
                    ),
                  ),
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                child: Column(
                  children: [
                    CachedNetworkImage(imageUrl: "$imageUrl$url"),
                    SizedBox(
                      height: 15.0,
                    ),
                    Text(
                      data.results[index].title,
                      style: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 20.0),
                    ),
                  ],
                ),
              ),
            ),
          ));
        },
        options: CarouselOptions(
            height: (size.height * 0.33 < 300) ? 300 : size.height * 0.33,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.decelerate,
            reverse: false,
            autoPlayAnimationDuration: Duration(milliseconds: 500),
            autoPlayInterval: Duration(seconds: 2),
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal),
      ),
    );
  }
}

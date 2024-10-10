import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:task_wafarha/features/photo/model/photo_model.dart';

class PhotoItem extends StatelessWidget {
  Photo photo;
  PhotoItem({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black26, width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: photo.thumbnailUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error)),
          ),
          const SizedBox(height: 20),
          Expanded(child: Text(photo.title)),
          const SizedBox(height: 10),
          Text(photo.albumId.toString()),

        ],
      ),
    );
  }
}

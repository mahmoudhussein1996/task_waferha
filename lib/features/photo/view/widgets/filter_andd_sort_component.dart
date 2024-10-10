import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_wafarha/features/photo/controller/cubit/photo_cubit.dart';

class SortAndFilterComponent extends StatelessWidget {
  SortAndFilterComponent({super.key});

  final TextEditingController _filterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _filterController,
            decoration: InputDecoration(
              labelText: 'Filter by Album ID',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  final albumId = int.tryParse(_filterController.text);
                  if (albumId != null) {
                    context.read<PhotoCubit>().filterPhotosByAlbumId(albumId);
                  }
                },
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.sort_by_alpha),
          onPressed: () => context.read<PhotoCubit>().sortPhotosByTitle(),
        ),
        IconButton(
          icon: const Icon(Icons.sort),
          onPressed: () => context.read<PhotoCubit>().sortPhotosByAlbumId(),
        ),
      ],
    );
  }
}

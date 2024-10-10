import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_wafarha/features/photo/controller/cubit/photo_cubit.dart';
import 'package:task_wafarha/features/photo/controller/cubit/photo_states.dart';
import 'package:task_wafarha/features/photo/view/widgets/filter_andd_sort_component.dart';
import 'package:task_wafarha/features/photo/view/widgets/photo_item.dart';

class PhotosScreen extends StatelessWidget {
  const PhotosScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PhotoCubit()..loadPhotos(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Photos'),
        ),
        body: BlocBuilder<PhotoCubit, PhotoState>(
          builder: (context, state) {
            if (state is PhotoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PhotoLoaded) {
              return Column(
                children: [
                  SortAndFilterComponent(),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                      itemCount: state.photos.length,
                      itemBuilder: (context, index) {
                        return PhotoItem(photo: state.photos[index]);
                      },
                    ),
                  ),
                  // SizedBox(height: MediaQuery.of(context).size.height * .1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        state.currentPage > 0 ?
                        GestureDetector(
                          onTap: state.currentPage > 0
                              ? () => context.read<PhotoCubit>().previousPage()
                              : null,
                          child: const Icon(Icons.arrow_back_ios, color: Colors.black),
                        ) : const SizedBox(),
                        state.currentPage < state.totalPages - 1 ?
                        GestureDetector(
                          onTap: state.currentPage < state.totalPages - 1
                              ? () => context.read<PhotoCubit>().nextPage()
                              : null,
                          child: const Icon(Icons.arrow_forward_ios, color: Colors.black,),
                        ) : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              );
            }else{
              return const Center(child: Text('No Photos Found'));
            }
          },
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     _photoCubit.loadMorePhotos();
        //   },
        //   child: Icon(Icons.more_horiz),
        // ),
      ),
    );
  }
}

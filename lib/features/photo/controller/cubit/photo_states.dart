
import 'package:task_wafarha/features/photo/model/photo_model.dart';

abstract class PhotoState {}

class PhotoLoading extends PhotoState {}

class PhotoError extends PhotoState {
  String error;

  PhotoError({required this.error});
}

class PhotoLoaded extends PhotoState {
  final List<Photo> photos;
  final int currentPage;
  final int totalPages;

  PhotoLoaded({required this.photos, required this.currentPage, required this.totalPages});
}
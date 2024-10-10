import 'dart:convert';
import 'dart:isolate';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:task_wafarha/features/photo/controller/cubit/photo_states.dart';
import 'package:task_wafarha/features/photo/model/photo_model.dart';


class PhotoCubit extends Cubit<PhotoState> {
  PhotoCubit() : super(PhotoLoading());

  List<Photo> _allPhotos = [];
  List<Photo> _filteredPhotos = [];
  static const int photosPerPage = 10;
  int _currentPage = 0;


  Future<void> loadPhotos() async {
    emit(PhotoLoading());
    try {
      // Load JSON data in the main thread
      final jsonString = await rootBundle.loadString('assets/json/photos.json');
      _allPhotos = await _processPhotosInIsolate(jsonString);
      _filteredPhotos = List.from(_allPhotos);
      emit(PhotoLoaded(photos: _getPhotosForPage(_currentPage), currentPage: _currentPage, totalPages: _calculateTotalPages()));
    } catch (e) {
      emit(PhotoError(error: e.toString()));
    }
  }

  Future<List<Photo>> _processPhotosInIsolate(String jsonString) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(_isolateFunction, receivePort.sendPort);

    // Send JSON string to isolate for processing
    final sendPort = await receivePort.first as SendPort;
    final responsePort = ReceivePort();

    sendPort.send([jsonString, responsePort.sendPort]);
    final photos = await responsePort.first as List<Photo>;

    receivePort.close();
    responsePort.close();

    return photos;
  }

  static void _isolateFunction(SendPort sendPort) {
    final port = ReceivePort();
    sendPort.send(port.sendPort);

    // Listen for messages
    port.listen((message) {
      final jsonString = message[0] as String;
      final responseSendPort = message[1] as SendPort;

      // Process the JSON data
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final List<Photo> photos = jsonData.map((json) => Photo.fromJson(json as Map<String, dynamic>)).toList();

      // Send back the processed photos
      responseSendPort.send(photos);
    });
  }

  // get photos by pagination
  List<Photo> _getPhotosForPage(int page) {
    final startIndex = page * photosPerPage;
    final endIndex = startIndex + photosPerPage;
    return _filteredPhotos.sublist(
      startIndex,
      endIndex > _filteredPhotos.length ? _filteredPhotos.length : endIndex,
    );
  }

  // get total num of pages in photos list
  int _calculateTotalPages() {
    return (_allPhotos.length / photosPerPage).ceil();
  }

  // load next page in photos
  void nextPage() {
    if (_currentPage < _calculateTotalPages() - 1) {
      _currentPage++;
      emit(PhotoLoaded(photos: _getPhotosForPage(_currentPage), currentPage: _currentPage, totalPages: _calculateTotalPages()));
    }
  }

  // load next page in photos
  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      emit(PhotoLoaded(photos: _getPhotosForPage(_currentPage), currentPage: _currentPage, totalPages: _calculateTotalPages()));
    }
  }


  // sort images by title
  void sortPhotosByTitle() {
    emit(PhotoLoading());
    _filteredPhotos.sort((a, b) => a.title.compareTo(b.title));
    _currentPage = 0; // Reset to first page
    emit(PhotoLoaded(photos: _getPhotosForPage(_currentPage), currentPage: _currentPage, totalPages: _calculateTotalPages()));
  }

  // sort images by album id
  void sortPhotosByAlbumId() {
    emit(PhotoLoading());
    _filteredPhotos.sort((a, b) => a.albumId.compareTo(b.albumId));
    _currentPage = 0; // Reset to first page
    emit(PhotoLoaded(photos: _getPhotosForPage(_currentPage), currentPage: _currentPage, totalPages: _calculateTotalPages()));
  }

  // sort images by album id, user enter album id, fun get all photos with this album id
  void filterPhotosByAlbumId(int albumId) {
    emit(PhotoLoading());
    _filteredPhotos = _allPhotos.where((photo) => photo.albumId == albumId).toList();
    _currentPage = 0; // Reset to first page
    emit(PhotoLoaded(photos: _getPhotosForPage(_currentPage), currentPage: _currentPage, totalPages: _calculateTotalPages()));

  }
}

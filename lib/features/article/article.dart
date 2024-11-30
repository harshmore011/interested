
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';


enum ArticleState { created, updated, /*markedForDeletion,*/ deleted }
enum ArticlePublishState { draft, scheduled, published, /*unpublished*/ }

class ArticleParams extends Equatable {

  final String? id;
  final String? title;
  final String? description;
  final List<String> labels = [];
  final List<String> imageDeleteList = [];
  final List<XFile> images = []; // ??
  final DateTime? scheduledDateTime;

  ArticleParams({
    this.id,
    this.title,
    this.description,/*
    this.labels,
    this.images,*/
    this.scheduledDateTime
  });

  @override
  List<Object?> get props => [id, title, description, labels,imageDeleteList,
    images,scheduledDateTime,];
}

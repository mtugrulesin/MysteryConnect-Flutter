import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:retrofit/http.dart';

import '../../entity/photo.dart';
import '../../response/generic_response.dart';

part 'photo_service.g.dart';

@RestApi(baseUrl: 'http://16.170.215.96:8082/api/v1/')
abstract class PhotoService {
  factory PhotoService(Dio dio, {String? baseUrl}) = _PhotoService;

  // Future<dynamic> sendRandomPhoto(int userId, File imageFile) async {
  //   var request = http.MultipartRequest(
  //       'POST', Uri.parse("http://16.170.215.96:8082/api/v1/photo/send"));
  //   request.files.add(http.MultipartFile(
  //       'imageFile', imageFile.readAsBytes().asStream(), imageFile.lengthSync(),
  //       filename: imageFile.path.split("/").last));
  //   request.fields['userId'] = "$userId";
  //   await request.send();
  // }

  @GET('/photo/getMyPhotos/{id}')
  Future<List<Photo>> getMyPhotos(@Path("id") userId);

  @POST('/photo/deleteById')
  @FormUrlEncoded()
  Future<GenericResponse> deleteById(
    @Field("photoId") photoId,
  );
}

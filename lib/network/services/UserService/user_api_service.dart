import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:MysteryConnect/network/entity/user.dart';

import '../../response/generic_response.dart';
import '../../response/list_of_random_users_response.dart';
import '../../response/login_response.dart';

part 'user_api_service.g.dart';

@RestApi(baseUrl: 'http://16.170.215.96:8082/api/v1/')
abstract class UserApiService {
  factory UserApiService(Dio dio, {String? baseUrl}) = _UserApiService;

  @POST('/user/login')
  @FormUrlEncoded()
  Future<LoginResponse> loginUser(
      @Field("email") email, @Field("password") password);

  @POST('/user/create_user')
  @FormUrlEncoded()
  Future<GenericResponse> registerUser(
      @Field("fullName") fullName,
      @Field("email") email,
      @Field("birthDay") birthDay,
      @Field("password") password,
      @Field("countryCode") countryCode,
      @Field("gender") gender);

  @POST('/user/deletePhotoToList')
  @FormUrlEncoded()
  Future<LoginResponse> deletePhotoToList(
    @Field("userId") userId,
    @Field("photoId") photoId,
  );

  @POST('/user/updateDiamondCount')
  @FormUrlEncoded()
  Future<LoginResponse> updateDiamondCount(
    @Field("userId") userId,
    @Field("count") count,
  );

  @POST('/user/getUser')
  @FormUrlEncoded()
  Future<User> getUser(
    @Field("userId") userId,
  );

  @POST('/user/randomUsers')
  @FormUrlEncoded()
  Future<ListOfRandomUsersResponse> getListOfRandomUsers(
    @Field("userId") userId,
  );
}

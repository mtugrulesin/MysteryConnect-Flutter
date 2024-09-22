import 'package:MysteryConnect/utilities/constants.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:MysteryConnect/network/entity/chat.dart';
import '../../response/list_of_messages_response.dart';

part 'chat_service.g.dart';


const String baseIP2 = "";

@RestApi(baseUrl: 'http://$baseIP2/api/v1/')
abstract class ChatService {
  factory ChatService(Dio dio, {String? baseUrl}) = _ChatService;

  @POST('/chat/getUserChats')
  @FormUrlEncoded()
  Future<List<Chat>> getUserChats(
    @Field("userId") userId,
  );

  @POST('/chat/getChatMessages')
  @FormUrlEncoded()
  Future<ListOfMessagesResponse> getChatMessages(
    @Field("chatId") chatId,
    @Field("userId") userId,
  );

  @POST('/message/createMessage')
  @FormUrlEncoded()
  Future<bool> createMessage(
    @Field("senderId") senderId,
    @Field("receiverId") receiverId,
    @Field("context") context,
    @Field("chatId") chatId,
  );
}

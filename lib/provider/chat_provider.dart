
import 'package:sparsh_user/data/model/response/base/api_response.dart';
import 'package:sparsh_user/data/model/response/chat_model.dart';
import 'package:sparsh_user/data/model/response/order_model.dart';
import 'package:sparsh_user/data/repository/chat_repo.dart';
import 'package:sparsh_user/helper/api_checker.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../data/repository/notification_repo.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepo chatRepo;
  final NotificationRepo notificationRepo;
  ChatProvider({@required this.chatRepo, @required this.notificationRepo});

  List<bool> _showDate;
  List<XFile> _imageFiles;
  // XFile _imageFile;
  bool _isSendButtonActive = false;
  bool _isSeen = false;
  bool _isSend = true;
  bool _isMe = false;
  bool _isLoading= false;
  bool get isLoading => _isLoading;

  List<bool> get showDate => _showDate;
  List<XFile> get imageFiles => _imageFiles;
  // XFile get imageFile => _imageFile;
  bool get isSendButtonActive => _isSendButtonActive;
  bool get isSeen => _isSeen;
  bool get isSend => _isSend;
  bool get isMe => _isMe;
  List<Messages>  _deliveryManMessage = [];
  List<Messages>  _messageList = [];
  List<Messages> get messageList => _messageList;
  List<Messages> get deliveryManMessage => _deliveryManMessage;
  List<Messages>  _adminManMessage = [];
  List<Messages> get adminManMessages => _adminManMessage;
  List <XFile>_chatImage = [];
  List<XFile> get chatImage => _chatImage;

  Future<void> getDeliveryManMessages (BuildContext context, int orderId) async {
    ApiResponse apiResponse = await chatRepo.getDeliveryManMessage(orderId,1);
    // _deliveryManMessages = [];
    if (apiResponse.response != null&& apiResponse.response.data['messages']!= {} && apiResponse.response.statusCode == 200) {
      _messageList.addAll(ChatModel.fromJson(apiResponse.response.data).messages);
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  Future<void> getMessages (BuildContext context, int offset, OrderModel orderModel, bool isFirst) async {
    ApiResponse _apiResponse;
    if(isFirst) {
      _messageList = [];
    }
    //
    if(orderModel == null) {
      _apiResponse = await chatRepo.getAdminMessage(1);
    }else {
     _apiResponse = await chatRepo.getDeliveryManMessage(orderModel.id, 1);
    }
    if (_apiResponse.response != null&& _apiResponse.response.data['messages'] != {} && _apiResponse.response.statusCode == 200) {
      _messageList = [];
      _messageList.addAll(ChatModel.fromJson(_apiResponse.response.data).messages);
    } else {
      ApiChecker.checkApi(context, _apiResponse);
    }
    notifyListeners();
  }


  void pickImage(bool isRemove) async {
    if(isRemove) {
      _imageFiles = [];
      _chatImage = [];
    }else {
      _imageFiles = await ImagePicker().pickMultiImage(imageQuality: 40);
      if (_imageFiles != null) {
        _chatImage = imageFiles;
        _isSendButtonActive = true;
      }
    }
    notifyListeners();
  }
  void removeImage(int index){
    chatImage.removeAt(index);
    notifyListeners();
  }

  Future<http.StreamedResponse> sendMessageToDeliveryMan(String message, List<XFile> file, int orderId, BuildContext context, String token) async {
    _isLoading = true;
    // notifyListeners();
    http.StreamedResponse response = await chatRepo.sendMessageToDeliveryMan(message, file, orderId, token);
    if (response.statusCode == 200) {
      // _imageFiles = [];
      // _chatImage = [];
      file =[];
      getDeliveryManMessages(context, orderId);
      _isLoading = false;
    } else {
      print('===${response.statusCode}');
    }
    _imageFiles = [];
    _chatImage = [];
    _isSendButtonActive = false;
    notifyListeners();
    _isLoading = false;
    return response;
  }

  Future<http.StreamedResponse> sendMessage(String message, BuildContext context, String token, OrderModel order) async {
    http.StreamedResponse _response;
    _isLoading = true;
    // notifyListeners();
    if(order == null) {
      _response = await chatRepo.sendMessageToAdmin(message, _chatImage, token);
    }else {
      _response = await chatRepo.sendMessageToDeliveryMan(message, _chatImage, order.id, token);
    }
    if (_response.statusCode == 200) {
      getMessages(context,1, order, false);
      _isLoading = false;
    }
    _imageFiles = [];
    _chatImage = [];
    _isSendButtonActive = false;
    notifyListeners();
    _isLoading = false;
    return _response;
  }

  void toggleSendButtonActivity() {
    _isSendButtonActive = !_isSendButtonActive;
    notifyListeners();
  }

  void setImageList(List<XFile> images) {
    _imageFiles = [];
    _imageFiles = images;
    _isSendButtonActive = true;
    notifyListeners();
  }

  void setIsMe(bool value) {
    _isMe = value;
  }

}
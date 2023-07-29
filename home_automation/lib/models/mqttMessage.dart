import 'dart:io';

class MQTTMessageModel {
  String topic;
  String message;
  MQTTMessageModel({required this.topic, required this.message});
}

part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatSuccess extends ChatState {
  List<Message> messages;

  ChatSuccess({required this.messages});
}

class ChatIndicator extends ChatState {}

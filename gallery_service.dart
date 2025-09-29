import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gallery_model.dart';
import '../models/message_model.dart';

class GalleryService {
  static const String _messagesKey = 'birthday_messages';
  static const String _galleryKey = 'birthday_gallery';

  List<BirthdayMessage> _messages = [];
  List<GalleryItem> _galleryItems = [];

  GalleryService() {
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadMessages();
    await _loadGalleryItems();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getString(_messagesKey);
    if (messagesJson != null) {
      final List<dynamic> messagesList = json.decode(messagesJson);
      _messages = messagesList
          .map((msgJson) => BirthdayMessage.fromJson(msgJson))
          .toList();
    }
  }

  Future<void> _loadGalleryItems() async {
    final prefs = await SharedPreferences.getInstance();
    final galleryJson = prefs.getString(_galleryKey);
    if (galleryJson != null) {
      final List<dynamic> galleryList = json.decode(galleryJson);
      _galleryItems = galleryList
          .map((itemJson) => GalleryItem.fromJson(itemJson))
          .toList();
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson =
        json.encode(_messages.map((msg) => msg.toJson()).toList());
    await prefs.setString(_messagesKey, messagesJson);
  }

  Future<void> _saveGalleryItems() async {
    final prefs = await SharedPreferences.getInstance();
    final galleryJson =
        json.encode(_galleryItems.map((item) => item.toJson()).toList());
    await prefs.setString(_galleryKey, galleryJson);
  }

  List<BirthdayMessage> getMessages() {
    return _messages;
  }

  Future<void> addMessage(BirthdayMessage message) async {
    _messages.add(message);
    await _saveMessages();
  }

  Future<bool> deleteMessage(String id) async {
    final initialLength = _messages.length;
    _messages.removeWhere((msg) => msg.id == id);
    if (_messages.length != initialLength) {
      await _saveMessages();
      return true;
    }
    return false;
  }

  List<GalleryItem> getGalleryItems() {
    return _galleryItems;
  }

  List<GalleryItem> getImages() {
    return _galleryItems.where((item) => item.type == 'image').toList();
  }

  List<GalleryItem> getVideos() {
    return _galleryItems.where((item) => item.type == 'video').toList();
  }

  Future<void> addGalleryItem(GalleryItem item) async {
    _galleryItems.add(item);
    await _saveGalleryItems();
  }

  Future<bool> deleteGalleryItem(String id) async {
    final initialLength = _galleryItems.length;
    _galleryItems.removeWhere((item) => item.id == id);
    if (_galleryItems.length != initialLength) {
      await _saveGalleryItems();
      return true;
    }
    return false;
  }
}

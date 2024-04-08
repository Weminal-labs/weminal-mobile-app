import 'package:flutter/foundation.dart';
import 'package:weminal_app/services/old_project/api_service.dart';
import 'package:weminal_app/states/old_project/topic_state.dart';
import 'package:weminal_app/utilities/old_project/page_response.dart';

import '../../models/old_project/topic_model.dart';

class TopicProvider extends ChangeNotifier {
  TopicState _state = TopicState.initial;
  final List<TopicModel> _topics = [];

  TopicState get state => _state;
  List<TopicModel> get topics => _topics;

  Future<void> fetchTopics() async {
    _state = TopicState.loading;
    notifyListeners();

    PageResponse pageResponse = await ApiService.getPageTopic();
    for (Map<String, dynamic> i in pageResponse.items) {
      _topics.add(TopicModel.fromJson(i));
    }
    _state = TopicState.loaded;
    notifyListeners();
  }
}

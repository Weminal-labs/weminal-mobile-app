import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weminal_app/topic/topic_provider.dart';
import 'package:weminal_app/topic/topic_state.dart';

class TopicPage extends StatefulWidget {
  const TopicPage({Key? key}) : super(key: key);

  @override
  State<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  @override
  void initState() {
    if (Provider.of<TopicProvider>(context, listen: false).state ==
        TopicState.initial) {
      Future.microtask(() =>
          Provider.of<TopicProvider>(context, listen: false).fetchTopics());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildListTopic;
  }

  Widget get _buildListTopic {
    return Consumer<TopicProvider>(
      builder: (context, topicProvider, child) {
        switch (topicProvider.state) {
          case TopicState.loading:
            return const CircularProgressIndicator();
          case TopicState.initial:
            return _buildEmptyTodoBackground();
          case TopicState.loaded:
            return ListView.builder(
              itemBuilder: _buildTopicItem,
              itemCount: topicProvider.topics.length,
            );
          default:
            return const Text('XXXXXXXXXXXXXXXXXXXXXXXXXXX');
        }
      },
    );
  }

  Widget _buildEmptyTodoBackground() {
    return AspectRatio(
        aspectRatio: 1,
        child: Image.asset('assets/images/img_empty_todo_list.jpg'));
  }

  Widget _buildTopicItem(BuildContext context, int index) {
    return Card(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    Provider.of<TopicProvider>(context).topics[index].name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('words'),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(
                            'https://vtv1.mediacdn.vn/zoom/640_400/562122370168008704/2023/6/14/photo1686714465501-16867144656101728954756.png'),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Peterlll',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 100,
            width: 100,
            margin: const EdgeInsets.only(right: 10),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://vtv1.mediacdn.vn/zoom/640_400/562122370168008704/2023/6/14/photo1686714465501-16867144656101728954756.png'))),
          ),
        ],
      ),
    );
  }
}

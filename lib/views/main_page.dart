import 'package:flutter/material.dart';
import 'package:weminal_app/views/detail_page.dart';
import 'package:weminal_app/views/page3.dart';
import 'package:weminal_app/views/page4.dart';
import 'package:weminal_app/views/topic_page.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  int maxCount = 4;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _indexPage = 0;

  /// widget list
  final List<Widget> bottomBarPages = [
    const HomePage(),
    const TopicPage(),
    const Page3(),
    const Page4(),
  ];
  final List<String> topicString = ['Home', 'Topic', 'Folder', 'User Setting'];

  final List<IconData?> actionList = [
    null,
    Icons.add,
    Icons.add,
    null,
  ];

  final List<IconData> iconList = [
    Icons.home,
    Icons.topic,
    Icons.folder_outlined,
    Icons.person
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          topicString[_indexPage],
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontFamily: 'Pacifico'),
        ),
        centerTitle: true,
        elevation: 4,
        shadowColor: Colors.grey,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: actionList[_indexPage] != null
                ? Icon(actionList[_indexPage])
                : null,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        onPressed: () {
          _showAddBottomPopup();
        },
        child: const Icon(Icons.add),
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedBottomNavigationBar.builder(
              height: 80,
              tabBuilder: (int index, bool isActive) {
                return Icon(
                  iconList[index],
                  size: 24,
                  color: isActive ? Colors.green : Colors.grey,
                );
              },
              activeIndex: _indexPage,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.softEdge,
              leftCornerRadius: 24,
              rightCornerRadius: 24,
              onTap: (index) => _changePage(index),
              itemCount: iconList.length,
              //other params
            )
          : null,
    );
  }

  void _showAddBottomPopup() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: Colors.amber,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    child: const Text('Topic'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    child: const Text('Folder'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _changePage(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _indexPage = index;
    });
  }

  void _showAddTopicBottomPopup() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: Colors.amber,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    child: const Text('Topic'),
                    onPressed: () {},
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    child: const Text('Folder'),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

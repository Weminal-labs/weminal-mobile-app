import 'package:flutter/material.dart';
import 'package:weminal_app/views/home_page.dart';
import 'package:weminal_app/views/page3.dart';
import 'package:weminal_app/views/profile_page.dart';
import 'package:weminal_app/views/topic_page.dart';

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
    const ProfilePage(),
  ];
  final List<AppBar> appBarList = [
    AppBar(
      title: Row(
        children: [
          const Text('Event'),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 52,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: const Color(0xffF3F8FE),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xffF3F8FE), width: 1)),
              child: const Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 20,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                      child: TextField(
                    decoration: InputDecoration(border: InputBorder.none),
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    AppBar(
      title: Text('Event'),
    ),
    AppBar(
      title: Text('Event'),
    ),
    AppBar(
      title: const Text(
        'Profile',
        style: TextStyle(
            fontSize: 20,
            color: Color(0xff5669FF),
            fontWeight: FontWeight.w800),
      ),
    ),
  ];

  final List<IconData?> actionList = [
    null,
    Icons.add,
    Icons.add,
    null,
  ];

  final List<IconData> iconList = [
    Icons.home_filled,
    Icons.topic,
    Icons.folder_outlined,
    Icons.person
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarList[_indexPage],
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
            bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar:
          (bottomBarPages.length <= maxCount) ? _buildBottomNav() : null,
    );
  }

  void _changePage(int index) {
    _pageController.jumpToPage(index);
    setState(() {
      _indexPage = index;
    });
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0xffdedede),
            blurRadius: 22,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(40),
          topLeft: Radius.circular(40),
        ),
        child: BottomNavigationBar(
          selectedFontSize: 24,
          unselectedFontSize: 20,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: _indexPage,
          onTap: (value) {
            _changePage(value);
          },
          items: const [
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/images/icon_home.png")),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/images/icon_ticket.png")),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/images/icon_heart.png")),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/images/icon_profile.png")),
                label: 'Home'),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:weminal_app/views/home_page.dart';
import 'package:weminal_app/views/profile_page.dart';

import '../utilities/router_manager.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /// Controller to handle PageView and also handles initial page
  final _pageController = PageController(initialPage: 0);

  int maxCount = 2;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _indexPage = 0;

  /// widget list
  final List<Widget> bottomBarPages = [
    const HomePage(),
    // const Page3(),
    const ProfilePage(),
  ];
  final List<AppBar?> appBarList = [
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
    null
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
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.lightBlue,
        onPressed: () {
          _showAddBottomPopup();
        },
        child: const Icon(
          Icons.add,
          color: Color(0xffE5E4E4FF),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
  void _showAddBottomPopup() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "New Event",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  Divider(
                    thickness: 1.2,
                    color: Colors.grey.shade200,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Name",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6)),
                    child: TextField(
                      decoration: InputDecoration(
                           enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "",
                          hintStyle: TextStyle(color: Colors.grey
                          )),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Description",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(6)),
                    child: TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          hintText: "",
                          hintStyle: TextStyle(color: Colors.grey
                          )),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)
                            )
                        ),
                        child: Text(
                            "Create Event",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16
                            )
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
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
          topRight: Radius.elliptical(60, 60),
          topLeft: Radius.elliptical(60, 60),
        ),
        child: BottomNavigationBar(
          selectedFontSize: 18,
          unselectedFontSize: 17,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: _indexPage,
          onTap: (value) {
            _changePage(value);
          },
          items: [
            BottomNavigationBarItem(
                icon: Container(
                    alignment: Alignment.center,
                    child: const ImageIcon(
                        AssetImage("assets/images/icon_home.png"))),
                label: 'Home'),
            // BottomNavigationBarItem(
            //     // icon: ImageIcon(AssetImage("assets/images/icon_heart.png")),
            //     icon: Container(),
            //     label: 'Home'),
            const BottomNavigationBarItem(
                icon: ImageIcon(AssetImage("assets/images/icon_profile.png")),
                label: 'Home'),
          ],
        ),
      ),
    );
  }
}
